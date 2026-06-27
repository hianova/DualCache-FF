extern crate alloc;
#[cfg(not(feature = "std"))]
use alloc::{vec, vec::Vec, boxed::Box};


use crate::daemon::{Command, Daemon, DaemonStatus, DaemonGuard};
use crate::lossy_queue::{LossyQueue, OneshotAck};
use crate::storage::Cache;
use crate::filters::{T1, T2};
use crate::workers::WorkerSlot;
use ahash::RandomState;
use core::hash::{BuildHasher, Hash, Hasher};
use crate::sync::atomic::{AtomicBool, AtomicU32, Ordering};
use crate::sync::index_types::{AtomicTick, TickType};
use crate::sync::Arc;
use crate::config::Config;

use crate::components::{WorkerState, GLOBAL_EPOCH};
use crate::shared_core::SharedCore;
use crate::core_cache::CoreCache;


use crate::components::{DefaultTls, DefaultSpawner};

// ── DualCacheFF ───────────────────────────────────────────────────────────

pub struct DualCacheFF<K, V, S = RandomState> {
    pub hasher: S,
    pub t1: Arc<T1<K, V>>,
    pub t2: Arc<T2<K, V>>,
    pub cache: Arc<Cache<K, V>>,
    pub cmd_tx: Arc<LossyQueue<Command<K, V>>>,
    pub hit_tx: Arc<LossyQueue<[usize; 64]>>,
    pub epoch: Arc<AtomicU32>,
    /// ThreadRegistry for dynamic WorkerState and BatchBuf.
    pub registry: Arc<crate::registry::ThreadRegistry<K, V>>,
    /// Daemon tick counter — shared with the Daemon thread.
    /// Workers read this (Relaxed) to implement time-based TLS flush.
    pub daemon_tick: Arc<AtomicTick>,
    /// Number of daemon_tick advances that correspond to ≈1 ms of real time.
    pub flush_tick_threshold: TickType,
    /// Cold-start flag: Daemon sets this to false when capacity is reached.
    pub is_cold_start: Arc<AtomicBool>,
    /// The thread-local storage provider, injected at compile-time for zero overhead.
    pub tls: DefaultTls,
    /// Shared core for fallback sleep mode routing
    pub shared_core: Arc<SharedCore<K, V>>,
    /// Guard that sends Shutdown command when the last clone drops
    pub drop_guard: Arc<DualCacheDropGuard<K, V>>,
    /// Optional bloom filter to prevent cache penetration.
    pub bloom_filter: Option<Arc<dyn crate::filters::BloomFilter<K> + Send + Sync>>,
    /// SingleFlight protection against cache penetration (std only)
    #[cfg(feature = "std")]
    pub singleflight: Arc<std::sync::Mutex<std::collections::HashMap<u64, Arc<std::sync::Condvar>>>>,
}

pub struct DualCacheDropGuard<K, V> {
    pub cmd_tx: Arc<LossyQueue<Command<K, V>>>,
    pub has_daemon: bool,
}

impl<K, V> Drop for DualCacheDropGuard<K, V> {
    fn drop(&mut self) {
        if self.has_daemon {
            let _ = self.cmd_tx.try_send(Command::Shutdown(None));
        }
    }
}

// ── Internal Helpers ──────────────────────────────────────────────────────

impl<K, V, S> DualCacheFF<K, V, S> {
    #[inline(always)]
    fn get_worker_state(&self, id: usize) -> &Arc<WorkerState> {
        if let Some(old_ptr) = self.registry.ensure_capacity(id) {
            let _ = self.cmd_tx.try_send(Command::RetireRegistry(old_ptr as usize));
        }
        let inner = unsafe { &*self.registry.get_inner() };
        &inner.states[id]
    }

    #[inline(always)]
    fn get_miss_buffer(&self, id: usize) -> &Arc<WorkerSlot<K, V>> {
        if let Some(old_ptr) = self.registry.ensure_capacity(id) {
            let _ = self.cmd_tx.try_send(Command::RetireRegistry(old_ptr as usize));
        }
        let inner = unsafe { &*self.registry.get_inner() };
        &inner.buffers[id]
    }
}

impl<K, V, S: Clone> Clone for DualCacheFF<K, V, S> {
    fn clone(&self) -> Self {
        Self {
            hasher: self.hasher.clone(),
            t1: self.t1.clone(),
            t2: self.t2.clone(),
            cache: self.cache.clone(),
            cmd_tx: self.cmd_tx.clone(),
            hit_tx: self.hit_tx.clone(),
            epoch: self.epoch.clone(),
            registry: self.registry.clone(),
            daemon_tick: self.daemon_tick.clone(),
            flush_tick_threshold: self.flush_tick_threshold,
            is_cold_start: self.is_cold_start.clone(),
            tls: self.tls.clone(),
            shared_core: self.shared_core.clone(),
            drop_guard: self.drop_guard.clone(),
            bloom_filter: self.bloom_filter.clone(),
            #[cfg(feature = "std")]
            singleflight: self.singleflight.clone(),
        }
    }
}

// ── Constructor (std mode — auto-spawns Daemon thread) ────────────────────

#[cfg(feature = "std")]
impl<K, V> DualCacheFF<K, V, RandomState>
where
    K: Hash + Eq + Send + Sync + Clone + 'static,
    V: Send + Sync + Clone + 'static,
{
    /// Create a new `DualCacheFF` and automatically spawn the background Daemon.
    ///
    /// Use this in `std` environments (servers, desktops).
    #[inline]
    pub fn new(config: Config) -> Self {
        Self::new_with_spawner(config, DefaultSpawner)
    }

    /// Create a new `DualCacheFF` with eviction and promotion callbacks.
    #[inline]
    pub fn new_with_callbacks(
        config: Config,
        on_evict: Option<Arc<dyn Fn(K, V) + Send + Sync>>,
        on_promote: Option<Arc<dyn Fn(K, V) + Send + Sync>>,
    ) -> Self {
        Self::new_with_tls_and_spawner_and_callbacks(config, DefaultTls::default(), DefaultSpawner::default(), on_evict, on_promote)
    }
}

#[cfg(feature = "std")]
impl<K, V> DualCacheFF<K, V, RandomState>
where
    K: Hash + Eq + Send + Sync + Clone + 'static,
    V: Send + Sync + Clone + 'static,
{
    /// Create a new `DualCacheFF` and automatically spawn the background Daemon using a custom thread-local storage provider.
    #[inline]
    pub fn new_with_tls(config: Config, tls: DefaultTls) -> Self {
        Self::new_with_tls_and_spawner(config, tls, DefaultSpawner)
    }

    /// Create a new `DualCacheFF` with a custom TLS provider and callbacks.
    #[inline]
    pub fn new_with_tls_and_callbacks(
        config: Config,
        tls: DefaultTls,
        on_evict: Option<Arc<dyn Fn(K, V) + Send + Sync>>,
        on_promote: Option<Arc<dyn Fn(K, V) + Send + Sync>>,
    ) -> Self {
        Self::new_with_tls_and_spawner_and_callbacks(config, tls, DefaultSpawner::default(), on_evict, on_promote)
    }
}

// ── Constructor (universal — returns Daemon for manual scheduling) ─────────

impl<K, V> DualCacheFF<K, V, RandomState>
where
    K: Hash + Eq + Send + Sync + Clone + 'static,
    V: Send + Sync + Clone + 'static,
{
    /// Create a new `DualCacheFF` and automatically spawn the background Daemon using a custom spawner.
    #[cfg(feature = "std")]
    pub fn new_with_spawner<Sp: crate::components::Spawner>(config: Config, spawner: Sp) -> Self {
        Self::new_with_tls_and_spawner(config, DefaultTls::default(), spawner)
    }

    /// Create a `DualCacheFF` and its `Daemon` without spawning any thread.
    ///
    /// # std mode
    /// Prefer `DualCacheFF::new()` which spawns the daemon automatically.
    ///
    /// # no_std / RTOS mode
    /// Use `new_headless()` to obtain both the cache handle and the daemon.
    /// Schedule `daemon.run()` on a dedicated RTOS task:
    /// ```ignore
    /// let (cache, daemon) = DualCacheFF::new_headless(config);
    /// rtos::spawn_task(|| daemon.run()); // RTOS-specific API
    /// ```
    pub fn new_headless(config: Config) -> (Self, Daemon<K, V, RandomState>) {
        Self::new_headless_with_callbacks(config, DefaultTls, RandomState::new(), None, None, None, None)
    }
}

impl<K, V, S> DualCacheFF<K, V, S> {
    #[inline(always)]
    #[cfg(feature = "std")]
    pub(crate) fn wake_daemon_if_parked(&self) {
        if self.shared_core.is_parked.load(Ordering::Relaxed) {
            if self.shared_core.is_parked.compare_exchange(true, false, Ordering::Acquire, Ordering::Relaxed).is_ok() {
                if let Ok(guard) = self.shared_core.daemon_thread.lock() {
                    if let Some(thread) = guard.as_ref() {
                        thread.unpark();
                    }
                }
            }
        }
    }
}

impl<K, V, S> DualCacheFF<K, V, S>
where
    K: Hash + Eq + Send + Sync + Clone + 'static,
    V: Send + Sync + Clone + 'static,
    S: BuildHasher + Clone + Send + 'static,
{
    #[cfg(feature = "std")]
    pub fn new_with_tls_and_spawner<Sp: crate::components::Spawner>(config: Config, tls: DefaultTls, spawner: Sp) -> Self
    where
        S: Default,
    {
        Self::new_with_tls_and_spawner_and_callbacks(config, tls, spawner, None, None)
    }

    #[cfg(feature = "std")]
    pub fn new_with_tls_and_spawner_and_callbacks<Sp: crate::components::Spawner>(
        config: Config,
        tls: DefaultTls,
        spawner: Sp,
        on_evict: Option<Arc<dyn Fn(K, V) + Send + Sync>>,
        on_promote: Option<Arc<dyn Fn(K, V) + Send + Sync>>,
    ) -> Self
    where
        S: Default,
    {
        let (cache, daemon) = Self::new_headless_with_callbacks(config, tls, S::default(), on_evict, on_promote, None, None);
        let status_ref = cache.shared_core.clone();
        spawner.spawn(alloc::boxed::Box::new(move || {
            status_ref.status.store(DaemonStatus::Running as u8, Ordering::Release);
            let _guard = DaemonGuard(&status_ref.status);
            daemon.run()
        }));
        cache
    }

    pub fn new_headless_with_callbacks(
        config: Config,
        tls: DefaultTls,
        hasher: S,
        on_evict: Option<Arc<dyn Fn(K, V) + Send + Sync>>,
        on_promote: Option<Arc<dyn Fn(K, V) + Send + Sync>>,
        bloom_filter: Option<Arc<dyn crate::filters::BloomFilter<K> + Send + Sync>>,
        on_lossy_drop: Option<Arc<dyn Fn(usize) + Send + Sync>>,
    ) -> (Self, Daemon<K, V, S>) {
        let t1 = Arc::new(T1::new(config.t1_slots));
        let t2 = Arc::new(T2::new(config.t2_slots));
        let cache = Arc::new(Cache::new(config.capacity));
        
        let cmd_q = if let Some(ref cb) = on_lossy_drop {
            Arc::new(LossyQueue::new_with_callback(8192, cb.clone()))
        } else {
            Arc::new(LossyQueue::new(8192))
        };
        let hit_q = if let Some(ref cb) = on_lossy_drop {
            Arc::new(LossyQueue::new_with_callback(1024, cb.clone()))
        } else {
            Arc::new(LossyQueue::new(1024))
        };
        let epoch = Arc::new(AtomicU32::new(0));
        let daemon_tick = Arc::new(AtomicTick::new(0));
        let is_cold_start = Arc::new(AtomicBool::new(true));

        let registry = Arc::new(crate::registry::ThreadRegistry::new(config.threads.max(16)));

        let core_cache = CoreCache::new(
            config.capacity,
            t1.clone(),
            t2.clone(),
            cache.clone(),
            epoch.clone(),
            config.duration,
            registry.clone(),
            is_cold_start.clone(),
            on_evict,
            on_promote,
        );
        let shared_core = Arc::new(SharedCore::new(core_cache));

        let daemon = Daemon::new(
            hasher.clone(),
            shared_core.clone(),
            cmd_q.clone(),
            hit_q.clone(),
            config.poll_us,
            daemon_tick.clone(),
        );

        let this = Self {
            hasher,
            t1,
            t2,
            cache,
            cmd_tx: cmd_q.clone(),
            hit_tx: hit_q,
            epoch,
            registry,
            daemon_tick,
            flush_tick_threshold: (config.poll_us as TickType).max(1),
            is_cold_start,
            tls,
            shared_core,
            drop_guard: Arc::new(DualCacheDropGuard {
                cmd_tx: cmd_q.clone(),
                has_daemon: true,
            }),
            bloom_filter,
            #[cfg(feature = "std")]
            singleflight: Arc::new(std::sync::Mutex::new(std::collections::HashMap::new())),
        };
        
        (this, daemon)
    }
}



impl<K, V, S> DualCacheFF<K, V, S>
where
    K: Hash + Eq + Send + Sync + Clone + 'static,
    V: Send + Sync + Clone + 'static,
    S: BuildHasher + Clone + Send + 'static,
{
    /// Manually declare a quiescent (quiet) state for the current thread.
    ///
    /// This clears the current thread's local epoch marker, indicating it is not
    /// accessing any cached data. This allows the background Daemon thread to safely
    /// reclaim any retired memory nodes. It should be called periodically by threads
    /// that perform long-running tasks or stay active without making cache reads/writes.
    #[inline(always)]
    pub fn quiescent(&self) {
        if let Some(id) = self.tls.get_worker_id() {
            let state = self.get_worker_state(id);
            state.local_epoch.store(0, Ordering::Release);
        }
    }

    /// Returns the health status of the Daemon background thread.
    pub fn daemon_health(&self) -> crate::daemon::DaemonStatus {
        let val = self.shared_core.status.load(crate::sync::atomic::Ordering::Acquire);
        match val {
            0 => crate::daemon::DaemonStatus::NotStarted,
            1 => crate::daemon::DaemonStatus::Running,
            2 => crate::daemon::DaemonStatus::ShuttingDown,
            3 => crate::daemon::DaemonStatus::Stopped,
            _ => crate::daemon::DaemonStatus::Panicked,
        }
    }

    /// Restart the daemon if it has panicked or stopped.
    #[cfg(feature = "std")]
    pub fn restart_daemon<Sp: crate::components::Spawner>(&self, spawner: Sp, poll_us: u64) {
        let status = self.daemon_health();
        if status == crate::daemon::DaemonStatus::Running || status == crate::daemon::DaemonStatus::ShuttingDown {
            return;
        }

        let new_daemon = Daemon {
            hasher: self.hasher.clone(),
            core: self.shared_core.clone(),
            cmd_rx: self.cmd_tx.clone(),
            hit_rx: self.hit_tx.clone(),
            poll_us,
            daemon_tick: Arc::new(crate::sync::index_types::AtomicTick::new(0)),
        };

        let status_ref = self.shared_core.clone();
        spawner.spawn(alloc::boxed::Box::new(move || {
            status_ref.status.store(crate::daemon::DaemonStatus::Running as u8, crate::sync::atomic::Ordering::Release);
            let _guard = crate::daemon::DaemonGuard(&status_ref.status);
            new_daemon.run()
        }));
    }

    /// Shutdown the daemon gracefully, waiting for queues to drain.
    /// This will block until the daemon is fully stopped or panicked.
    pub fn shutdown_gracefully(&self, timeout: Option<core::time::Duration>) {
        let ack = crate::lossy_queue::OneshotAck::new();
        let _ = self.cmd_tx.try_send(Command::Shutdown(Some(ack.clone())));
        #[cfg(feature = "std")]
        self.wake_daemon_if_parked();
        
        if let Some(t) = timeout {
            #[cfg(feature = "std")]
            let _ = ack.wait_timeout(t);
            #[cfg(not(feature = "std"))]
            ack.wait();
        } else {
            ack.wait();
        }
    }

    /// Returns the number of active/occupied entries in (T1, T2, Core Cache)
    pub fn entry_count(&self) -> (usize, usize, usize) {
        let t1_count = self.t1.slots.iter().filter(|ptr| !ptr.load(Ordering::Relaxed).is_null()).count();
        let t2_count = self.t2.slots.iter().filter(|ptr| !ptr.load(Ordering::Relaxed).is_null()).count();
        let cache_count = self.cache.nodes.iter().filter(|ptr| !ptr.load(Ordering::Relaxed).is_null()).count();
        (t1_count, t2_count, cache_count)
    }

    /// Flush all pending TLS buffers and wait for the Daemon to process them.
    ///
    /// Blocks via `OneshotAck::wait()` (spin-wait, safe in both std and no_std).
    pub fn sync(&self) {
        // ── flush TLS hit buffer ─────────────────────────────────────
        self.with_hit_buf(|state| {
            if state.1 > 0_usize {
                let _ = self.hit_tx.try_send(state.0);
                #[cfg(feature = "std")]
                self.wake_daemon_if_parked();
                state.1 = 0;
            }
        });

        for i in 0..self.registry.len() {
            let slot = self.get_miss_buffer(i);
            let buf: &mut crate::workers::BatchBuf<K, V> = slot.get_mut_safe();
            if !buf.is_empty() {
                let batch = buf.drain_to_vec();
                let _ = self.cmd_tx.try_send(Command::BatchInsert(batch));
                #[cfg(feature = "std")]
                self.wake_daemon_if_parked();
            }
        }

        // Send a Sync command and spin-wait for acknowledgment
        let ack = OneshotAck::new();
        self.cmd_tx.send_blocking(Command::Sync(ack.clone()));
        #[cfg(feature = "std")]
        self.wake_daemon_if_parked();
        ack.wait();
    }

    /// Suspend the background Daemon thread and route all requests synchronously (like StaticDualCache).
    /// Safe to call concurrently. The Daemon will park (zero CPU) until `resume()` is called.
    #[cfg(feature = "std")]
    pub fn suspend(&self) {
        self.shared_core.is_suspended.store(true, Ordering::Release);
    }

    /// Resume the background Daemon thread and restore wait-free processing mode.
    #[cfg(feature = "std")]
    pub fn resume(&self) {
        self.shared_core.is_suspended.store(false, Ordering::Release);
        if let Ok(guard) = self.shared_core.daemon_thread.lock() {
            if let Some(thread) = guard.as_ref() {
                thread.unpark();
            }
        }
    }

    /// Look up a key.
    ///
    /// Hot-path order: T1 (L1 direct-map) → T2 (L2 direct-map) → Cache (L3).
    /// Records a hit signal into the TLS buffer for Daemon processing.
    pub fn get(&self, key: &K) -> Option<V> {
        if let Some(bloom) = &self.bloom_filter {
            if !bloom.might_contain(key) {
                return None;
            }
        }
        let hash = self.hash(key);
        let current_epoch_cache = self.epoch.load(Ordering::Relaxed);

        // ── QSBR Check-in ───────────────────────
        let mut id_opt = None;
        let global_epoch = GLOBAL_EPOCH.load(Ordering::Relaxed);
        self.with_worker_id(|id| {
            self.get_worker_state(id)
                .local_epoch
                .store(global_epoch, Ordering::Relaxed);
            id_opt = Some(id);
        });

        let has_epoch = id_opt.is_some() || {
            #[cfg(not(feature = "std"))]
            { true }
            #[cfg(feature = "std")]
            { false }
        };

        let mut res: Option<V> = None;
        let mut hit_g_idx: Option<u32> = None;

        if has_epoch {
            // ── T1 check ──────────────────────────────────────────────────────
            if let Some(node) = self.t1.get_node(hash)
                && node.key == *key
                    && (node.expire_at == 0 || node.expire_at >= current_epoch_cache)
                {
                    res = Some(node.value.clone());
                    hit_g_idx = Some(node.g_idx);
                }

            // ── T2 check ──────────────────────────────────────────────────────
            if res.is_none()
                && let Some(node) = self.t2.get_node(hash)
                    && node.key == *key
                        && (node.expire_at == 0 || node.expire_at >= current_epoch_cache)
                    {
                        res = Some(node.value.clone());
                        hit_g_idx = Some(node.g_idx);
                    }

            // ── Cache (L3) check ──────────────────────────────────────────────
            if res.is_none() {
                let tag = (hash >> 48) as u16;
                if let Some(global_idx) = self.cache.index_probe(hash, tag)
                    && let Some(v) = self
                        .cache
                        .node_get_full(global_idx, key, current_epoch_cache)
                    {
                        res = Some(v);
                        hit_g_idx = Some(global_idx as u32);
                        self.tls.with_warmup_state(|s| *s = s.saturating_sub(10));
                    }
            }
        }

        // ── QSBR Check-out ─────────────────────────────────────
        if let Some(id) = id_opt {
            self.get_worker_state(id)
                .local_epoch
                .store(0, Ordering::Release);
        }

        if let Some(g_idx) = hit_g_idx {
            if self.shared_core.is_suspended.load(Ordering::Relaxed) {
                let mut core = self.shared_core.acquire_lock();
                core.process_hits(&[g_idx as usize]);
            } else {
                self.record_hit(g_idx as usize);
            }
        }

        res
    }

    /// Retrieve an item from the cache, but immediately return `None` if the `filter` returns `false`.
    /// This is useful for Bloom Filter integration to prevent cache penetration (Cache Breakdown).
    pub fn get_with_filter<F>(&self, key: &K, filter: F) -> Option<V>
    where
        F: FnOnce(&K) -> bool,
    {
        if !filter(key) {
            return None;
        }
        self.get(key)
    }

    /// Attempt to get a key. If it misses, execute the provided `load_fn` to fetch the data
    /// (e.g. from database), and immediately insert it into the cache.
    /// This provides a convenient coalescing / fall-back mechanism.
    pub fn get_or_load<E, F>(&self, key: &K, load_fn: F) -> Result<V, E>
    where
        F: FnOnce() -> Result<V, E>,
    {
        if let Some(v) = self.get(key) {
            return Ok(v);
        }
        
        let loaded = load_fn()?;
        self.insert(key.clone(), loaded.clone());
        Ok(loaded)
    }

    /// SingleFlight enabled `get_or_load`.
    /// Guarantees that only one thread will execute `load_fn` for a given key at a time.
    /// Other concurrent misses for the same key will block and wait for the result.
    #[cfg(feature = "std")]
    pub fn get_or_load_singleflight<E, F>(&self, key: &K, load_fn: F) -> Result<V, E>
    where
        F: FnOnce() -> Result<V, E>,
    {
        if let Some(v) = self.get(key) {
            return Ok(v);
        }

        let hash = self.hash(key);
        let condvar = {
            let mut map = self.singleflight.lock().unwrap();
            if let Some(cv) = map.get(&hash) {
                Some(cv.clone())
            } else {
                let cv = Arc::new(std::sync::Condvar::new());
                map.insert(hash, cv.clone());
                None
            }
        };

        if let Some(cv) = condvar {
            // Another thread is loading this key. Wait for it to finish.
            let mut map = self.singleflight.lock().unwrap();
            while map.contains_key(&hash) {
                map = cv.wait(map).unwrap();
            }
            // Once it finishes, the value should be in the cache.
            // If the load failed on the other thread, we might miss again.
            if let Some(v) = self.get(key) {
                return Ok(v);
            }
            // If we still miss (e.g. other thread failed), we retry by just falling through to the lock
            // But to avoid infinite loop of failures, we'll just fall back to normal execution.
        }

        // We are the loading thread.
        let loaded_res = load_fn();
        
        if let Ok(loaded) = &loaded_res {
            // We do a synchronous insert here to avoid the async gap where waiting threads
            // wake up, miss the cache, and trigger duplicate loads.
            let hash = self.hash(key);
            let mut core = self.shared_core.acquire_lock();
            core.handle_admission_insert(key.clone(), loaded.clone(), hash, true);
            drop(core);
        }

        // Wake up waiters and remove from map
        {
            let mut map = self.singleflight.lock().unwrap();
            if let Some(cv) = map.remove(&hash) {
                cv.notify_all();
            }
        }

        loaded_res
    }

    /// Increment the hit count (heat) for a key by an arbitrary weight without overwriting value.
    pub fn boost_heat(&self, key: &K, weight: u8) {
        if weight == 0 {
            return;
        }
        let hash = self.hash(key);
        // We simulate `weight` hits by pushing the hash into the hit buffer multiple times.
        self.with_hit_buf(|state| {
            for _ in 0..weight {
                if state.1 >= 64 {
                    let mut batch = [0usize; 64];
                    batch.copy_from_slice(&state.0[..]);
                    let _ = self.hit_tx.try_send(batch);
                    state.1 = 0;
                }
                state.0[state.1] = hash as usize;
                state.1 += 1;
            }
        });
    }

    /// Get a value and apply a custom heat weight if found.
    pub fn get_with_weight(&self, key: &K, weight: u8) -> Option<V> {
        let res = self.get(key);
        if res.is_some() && weight > 1 {
            // get() already applied a weight of 1, so we add the rest.
            self.boost_heat(key, weight - 1);
        }
        res
    }

    /// Query the cache to retrieve the internal epoch/rank of a key.
    /// This is useful for proactive memory management in a tiered architecture.
    pub fn get_heat_rank(&self, key: &K) -> Option<u32> {
        let hash = self.hash(key);
        
        // Check T1
        if let Some(node) = self.t1.get_node(hash) {
            if node.key == *key {
                return Some(node.expire_at);
            }
        }
        // Check T2
        if let Some(node) = self.t2.get_node(hash) {
            if node.key == *key {
                return Some(node.expire_at);
            }
        }
        // Check L3
        let tag = (hash >> 48) as u16;
        if let Some(global_idx) = self.cache.index_probe(hash, tag) {
            // Read core.ranks
            let current_epoch = self.epoch.load(Ordering::Relaxed);
            if let Some(node) = self.cache.get_node(global_idx) {
                if node.key == *key && (node.expire_at == 0 || node.expire_at >= current_epoch) {
                    return Some(node.expire_at);
                }
            }
        }
        None
    }

    /// Insert a key-value pair.
    pub fn insert(&self, key: K, value: V) {
        let hash = self.hash(&key);

        if self.shared_core.is_suspended.load(Ordering::Relaxed) {
            let mut core = self.shared_core.acquire_lock();
            core.handle_admission_insert(key, value, hash, false);
            return;
        }

        let mut id_opt = None;
        let is_cold = self.is_cold_start.load(Ordering::Relaxed);
        let mut bypass = is_cold;

        if !bypass {
            let global_epoch = GLOBAL_EPOCH.load(Ordering::Relaxed);
            self.with_worker_id(|id| {
                if id < self.registry.len() {
                    self.get_worker_state(id)
                        .local_epoch
                        .store(global_epoch, Ordering::Relaxed);
                    id_opt = Some(id);
                }
            });

            if id_opt.is_some() {
                if self.t1.get_node(hash).is_some_and(|node| node.key == key) {
                    bypass = true;
                }
                if !bypass
                    && self.t2.get_node(hash).is_some_and(|node| node.key == key) {
                        bypass = true;
                    }
                if !bypass {
                    let tag = (hash >> 48) as u16;
                    if self.cache.index_probe(hash, tag)
                        .and_then(|global_idx| self.cache.get_node(global_idx))
                        .is_some_and(|node| node.key == key) 
                    {
                        bypass = true;
                    }
                }
            }

            if let Some(id) = id_opt {
                self.get_worker_state(id)
                    .local_epoch
                    .store(0, Ordering::Relaxed);
            }
        }

        let pass = if bypass {
            true
        } else {
            self.with_l1_filter(|state| {
                let idx = (hash as usize) & 4095_usize;
                let val = state.0[idx];
                state.1 += 1;
                if state.1 >= 4096_usize {
                    for x in state.0.iter_mut() { *x >>= 1; }
                    state.1 = 0;
                }
                if val < 1_u8 { state.0[idx] = 1; false } 
                else { if val < 2_u8 { state.0[idx] = 2; } true }
            }).unwrap_or(true)
        };

        if !pass { return; }

        let mut warmup_state = 255;
        self.tls.with_warmup_state(|s| warmup_state = *s);
        let is_t1 = warmup_state < 100;

        let current_tick = self.daemon_tick.load(Ordering::Relaxed);
        let mut should_time_flush = false;
        self.with_last_flush_tick(|tick| {
            should_time_flush = current_tick.wrapping_sub(*tick) >= self.flush_tick_threshold;
        });

        let mut option_kv = Some((key, value));
        let pushed_to_buf = self.with_worker_id(|id| {
            let (k, v) = option_kv.take().unwrap();
            let buf: &mut crate::workers::BatchBuf<K, V> = self.get_miss_buffer(id).get_mut_safe();
            let capacity_flush = buf.push((k, v, hash, is_t1));

            if capacity_flush || (should_time_flush && !buf.is_empty()) {
                let batch = buf.drain_to_vec();
                let _ = self.cmd_tx.try_send(Command::BatchInsert(batch));
                #[cfg(feature = "std")]
                self.wake_daemon_if_parked();
                self.with_last_flush_tick(|tick| { *tick = current_tick; });
            }
        });

        if pushed_to_buf.is_none()
            && let Some((k, v)) = option_kv {
                let _ = self.cmd_tx.try_send(Command::Insert(k, v, hash, is_t1));
                #[cfg(feature = "std")]
                self.wake_daemon_if_parked();
            }
    }

    /// Insert an item and block until the Daemon has processed it.
    pub fn insert_sync(&self, key: K, value: V) {
        self.insert(key, value);
        self.sync();
    }

    /// Start a Cold Start Session to inject items directly to T1.
    pub fn begin_cold_start_session(&self) -> ColdStartSession<'_, K, V, S> {
        ColdStartSession { cache: self }
    }

    /// Remove a key from the cache.
    pub fn remove(&self, key: &K) {
        let hash = self.hash(key);
        self.with_worker_id(|id| {
            let buf: &mut crate::workers::BatchBuf<K, V> = self.get_miss_buffer(id).get_mut_safe();
            if !buf.is_empty() {
                let batch = buf.drain_to_vec();
                let _ = self.cmd_tx.try_send(Command::BatchInsert(batch));
                let tick = self.daemon_tick.load(Ordering::Relaxed);
                self.with_last_flush_tick(|c| *c = tick);
            }
        });
        self.cmd_tx.send_blocking(Command::Remove(key.clone(), hash));
    }

    /// Clear all cached data.
    pub fn clear(&self) {
        if self.shared_core.is_suspended.load(Ordering::Acquire) {
            let mut core = self.shared_core.acquire_lock();
            core.handle_clear();
            return;
        }
        let ack = OneshotAck::new();
        self.cmd_tx.send_blocking(Command::Clear(ack.clone()));
        #[cfg(feature = "std")]
        self.wake_daemon_if_parked();
        ack.wait();
    }

    // ── Internals ─────────────────────────────────────────────────────────

    #[inline(always)]
    fn with_worker_id<F, R>(&self, f: F) -> Option<R>
    where F: FnOnce(usize) -> R { self.tls.get_worker_id().map(f) }

    #[inline(always)]
    fn with_hit_buf<F, R>(&self, f: F) -> Option<R>
    where F: FnOnce(&mut ([usize; 64], usize)) -> R { self.tls.with_hit_buf(f) }

    #[inline(always)]
    fn with_l1_filter<F, R>(&self, f: F) -> Option<R>
    where F: FnOnce(&mut ([u8; 4096], usize)) -> R { self.tls.with_l1_filter(f) }

    #[inline(always)]
    fn with_last_flush_tick<F, R>(&self, f: F) -> Option<R>
    where F: FnOnce(&mut TickType) -> R { self.tls.with_last_flush_tick(f) }

    #[inline(always)]
    fn hash(&self, key: &K) -> u64 { self.hasher.hash_one(key) }

    #[inline(always)]
    fn record_hit(&self, global_idx: usize) {
        let opt = self.with_hit_buf(|state| {
            state.0[state.1] = global_idx;
            state.1 += 1;
            if state.1 == 64_usize {
                let _ = self.hit_tx.try_send(state.0);
                #[cfg(feature = "std")]
                self.wake_daemon_if_parked();
                state.1 = 0;
            }
        });

        if opt.is_none() {
            let mut batch = [usize::MAX; 64];
            batch[0] = global_idx;
            let _ = self.hit_tx.try_send(batch);
            #[cfg(feature = "std")]
            self.wake_daemon_if_parked();
        }
    }
}



/// A session helper designed to bypass standard admission/eviction probation filters (e.g. L1 filter)
/// and directly inject data into T1, T2, or Core storage. 
///
/// This is highly recommended for cold-starts, batch warmups, or manual cache tiering.
pub struct ColdStartSession<'a, K, V, S> {
    cache: &'a DualCacheFF<K, V, S>,
}

impl<'a, K, V, S> ColdStartSession<'a, K, V, S>
where
    K: Hash + Eq + Send + Sync + Clone + 'static,
    V: Send + Sync + Clone + 'static,
    S: BuildHasher + Clone + Send + 'static,
{
    /// Insert an item directly into T1 (Hot Tier), bypassing local TLS buffers and probation filters.
    pub fn insert_t1(&self, key: K, value: V) {
        let mut s = self.cache.hasher.build_hasher();
        key.hash(&mut s);
        let hash = s.finish();
        
        if self.cache.shared_core.is_suspended.load(Ordering::Acquire) {
            let mut core = self.cache.shared_core.acquire_lock();
            core.handle_insert_t1(key, value, hash);
            return;
        }

        let _ = self.cache.cmd_tx.try_send(Command::InsertT1(key, value, hash));
        #[cfg(feature = "std")]
        self.cache.wake_daemon_if_parked();
    }

    /// Batch insert items into T1 (fastest warmup for large datasets).
    pub fn warmup_batch(&self, items: impl IntoIterator<Item = (K, V)>) {
        let mut batch = Vec::with_capacity(128);
        for (key, value) in items {
            let mut s = self.cache.hasher.build_hasher();
            key.hash(&mut s);
            let hash = s.finish();
            batch.push((key, value, hash));
            
            if batch.len() >= 128 {
                if self.cache.shared_core.is_suspended.load(Ordering::Acquire) {
                    let mut core = self.cache.shared_core.acquire_lock();
                    for (k, v, h) in batch.drain(..) {
                        core.handle_insert_t1(k, v, h);
                    }
                } else {
                    let _ = self.cache.cmd_tx.try_send(Command::BatchInsertT1(batch.clone()));
                    #[cfg(feature = "std")]
                    self.cache.wake_daemon_if_parked();
                    batch.clear();
                }
            }
        }
        
        if !batch.is_empty() {
            if self.cache.shared_core.is_suspended.load(Ordering::Acquire) {
                let mut core = self.cache.shared_core.acquire_lock();
                for (k, v, h) in batch {
                    core.handle_insert_t1(k, v, h);
                }
            } else {
                let _ = self.cache.cmd_tx.try_send(Command::BatchInsertT1(batch));
                #[cfg(feature = "std")]
                self.cache.wake_daemon_if_parked();
            }
        }
    }

    /// Batch insert items into T2.
    pub fn warmup_batch_t2(&self, items: impl IntoIterator<Item = (K, V)>) {
        let mut batch = Vec::with_capacity(128);
        for (key, value) in items {
            let mut s = self.cache.hasher.build_hasher();
            key.hash(&mut s);
            let hash = s.finish();
            batch.push((key, value, hash));
            
            if batch.len() >= 128 {
                if self.cache.shared_core.is_suspended.load(Ordering::Acquire) {
                    let mut core = self.cache.shared_core.acquire_lock();
                    for (k, v, h) in batch.drain(..) {
                        core.handle_insert_t2(k, v, h);
                    }
                } else {
                    let _ = self.cache.cmd_tx.try_send(Command::BatchInsertT2(batch.clone()));
                    #[cfg(feature = "std")]
                    self.cache.wake_daemon_if_parked();
                    batch.clear();
                }
            }
        }
        
        if !batch.is_empty() {
            if self.cache.shared_core.is_suspended.load(Ordering::Acquire) {
                let mut core = self.cache.shared_core.acquire_lock();
                for (k, v, h) in batch {
                    core.handle_insert_t2(k, v, h);
                }
            } else {
                let _ = self.cache.cmd_tx.try_send(Command::BatchInsertT2(batch));
                #[cfg(feature = "std")]
                self.cache.wake_daemon_if_parked();
            }
        }
    }

    /// Batch insert items into Core (L3) only.
    pub fn warmup_batch_core(&self, items: impl IntoIterator<Item = (K, V)>) {
        let mut batch = Vec::with_capacity(128);
        for (key, value) in items {
            let mut s = self.cache.hasher.build_hasher();
            key.hash(&mut s);
            let hash = s.finish();
            batch.push((key, value, hash));
            
            if batch.len() >= 128 {
                if self.cache.shared_core.is_suspended.load(Ordering::Acquire) {
                    let mut core = self.cache.shared_core.acquire_lock();
                    for (k, v, h) in batch.drain(..) {
                        core.handle_insert_core(k, v, h);
                    }
                } else {
                    let _ = self.cache.cmd_tx.try_send(Command::BatchInsertCore(batch.clone()));
                    #[cfg(feature = "std")]
                    self.cache.wake_daemon_if_parked();
                    batch.clear();
                }
            }
        }
        
        if !batch.is_empty() {
            if self.cache.shared_core.is_suspended.load(Ordering::Acquire) {
                let mut core = self.cache.shared_core.acquire_lock();
                for (k, v, h) in batch {
                    core.handle_insert_core(k, v, h);
                }
            } else {
                let _ = self.cache.cmd_tx.try_send(Command::BatchInsertCore(batch));
                #[cfg(feature = "std")]
                self.cache.wake_daemon_if_parked();
            }
        }
    }

    /// Warmup with a specific frequency rank injected.
    pub fn warmup_with_rank(&self, key: K, value: V, tier: crate::daemon::CacheTier, rank: u8) {
        let mut s = self.cache.hasher.build_hasher();
        key.hash(&mut s);
        let hash = s.finish();
        
        if self.cache.shared_core.is_suspended.load(Ordering::Acquire) {
            let mut core = self.cache.shared_core.acquire_lock();
            core.handle_insert_with_rank(key, value, hash, tier.clone(), rank);
            return;
        }

        let _ = self.cache.cmd_tx.try_send(Command::InsertWithRank(key, value, hash, tier, rank));
        #[cfg(feature = "std")]
        self.cache.wake_daemon_if_parked();
    }

    /// Wait for all background warmup commands to be fully processed by the Daemon.
    pub fn warmup_sync(&self) {
        self.cache.sync();
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::config::Config;

    #[test]
    fn test_daemon_command_insert_coverage() {
        let config = Config::new_expert(1024, 8, 8, 200, 8);
        let cache = DualCacheFF::<u64, u64>::new(config);
        
        // Directly push commands to the daemon's queue
        let _ = cache.cmd_tx.try_send(Command::Insert(1, 1, 1, true));
        let _ = cache.cmd_tx.try_send(Command::Insert(2, 2, 2, false));
        let _ = cache.cmd_tx.try_send(Command::BatchInsert(alloc::vec![(3, 3, 3, true)]));
        let _ = cache.cmd_tx.try_send(Command::InsertT1(4, 4, 4));
        let _ = cache.cmd_tx.try_send(Command::BatchInsertT1(alloc::vec![(5, 5, 5)]));
        let _ = cache.cmd_tx.try_send(Command::BatchInsertT2(alloc::vec![(6, 6, 6)]));
        let _ = cache.cmd_tx.try_send(Command::BatchInsertCore(alloc::vec![(7, 7, 7)]));
        let _ = cache.cmd_tx.try_send(Command::InsertWithRank(8, 8, 8, crate::daemon::CacheTier::Tier1, 100));
        
        let inner = crate::registry::RegistryInner::<u64, u64> {
            states: alloc::vec![].into_boxed_slice(),
            buffers: alloc::vec![].into_boxed_slice(),
        };
        let ptr = alloc::boxed::Box::into_raw(alloc::boxed::Box::new(inner));
        let _ = cache.cmd_tx.try_send(Command::RetireRegistry(ptr as usize));
        
        let _ = cache.cmd_tx.try_send(Command::Remove(9, 9));
        let _ = cache.cmd_tx.try_send(Command::SetPollInterval(2000));
        
        cache.sync(); // Force processing
    }

    #[test]
    fn test_daemon_shutdown_with_garbage() {
        let config = Config::new_expert(1024, 8, 8, 200, 8);
        
        let evict_count = Arc::new(std::sync::atomic::AtomicUsize::new(0));
        let evict_clone = evict_count.clone();
        let on_evict = Arc::new(move |_k, _v| {
            evict_clone.fetch_add(1, Ordering::SeqCst);
        });
        
        let (cache, daemon) = DualCacheFF::<u64, u64>::new_headless_with_callbacks(
            config, crate::components::DefaultTls, Default::default(), Some(on_evict), None, None, None
        );
        
        let handle_daemon = std::thread::spawn(move || {
            daemon.run();
        });
        
        // 1. Manually set worker 0's local epoch to block GC
        let inner = unsafe { &*cache.registry.get_inner() };
        inner.states[0].local_epoch.store(1, Ordering::Release);
        
        // 2. Insert and remove an item to generate garbage
        cache.insert(100, 100);
        cache.remove(&100);
        
        // 3. Retire a registry to generate registry garbage
        let ptr: *mut crate::registry::RegistryInner<u64, u64> = alloc::boxed::Box::into_raw(alloc::boxed::Box::new(crate::registry::RegistryInner {
            states: vec![].into_boxed_slice(),
            buffers: vec![].into_boxed_slice(),
        }));
        let _ = cache.cmd_tx.try_send(Command::RetireRegistry(ptr as usize));
        
        // Wait a bit to ensure daemon picks up the commands
        std::thread::sleep(std::time::Duration::from_millis(10));
        
        // 4. Start shutdown in background thread
        let c2 = cache.clone();
        let handle = std::thread::spawn(move || {
            c2.shutdown_gracefully(None);
        });
        
        // 5. Wait a bit so the daemon spins > 100 times
        std::thread::sleep(std::time::Duration::from_millis(50));
        
        // 6. Release the epoch so it can finish
        inner.states[0].local_epoch.store(0, Ordering::Release);
        
        handle.join().unwrap();
        handle_daemon.join().unwrap();
        
        // Verify drop callbacks
        assert!(evict_count.load(Ordering::SeqCst) > 0);
    }

    #[test]
    fn test_daemon_panic_guard() {
        let config = Config::new_expert(1024, 8, 8, 200, 8);
        
        let (cache, daemon) = DualCacheFF::<u64, u64>::new_headless(config);
        
        let handle = std::thread::spawn(move || {
            daemon.run();
        });
        
        // Force an eviction to trigger the panic? No, we use SetPollInterval(0) to trigger it
        let _ = cache.cmd_tx.try_send(Command::SetPollInterval(0));
        
        // Wait for the daemon thread to panic
        let _ = handle.join();
        
        // Check that the status is Panicked
        assert_eq!(
            cache.shared_core.status.load(Ordering::Acquire),
            crate::daemon::DaemonStatus::Panicked as u8
        );
    }

    #[test]
    fn test_quiescent() {
        let config = Config::new_expert(256, 8, 8, 200, 8);
        let cache = DualCacheFF::<u64, u64>::new(config);
        
        // Call quiescent
        cache.quiescent();
        
        // Also test StaticDualCache quiescent
        let static_cache = crate::static_cache::StaticDualCache::<u64, u64>::new(Config::new_expert(256, 8, 8, 200, 8));
        static_cache.quiescent();
        
        cache.shutdown_gracefully(None);
    }
}

#[cfg(test)]
mod extra_coverage_tests {
    use super::*;
    use crate::config::Config;
    #[test]
    fn test_wake_daemon_if_parked() {
        let config = Config::new_expert(256, 8, 8, 200, 2);
        let cache = DualCacheFF::<u64, u64>::new(config);
        
        // Since is_parked is an atomic bool in shared_core, we can set it
        cache.shared_core.is_parked.store(true, core::sync::atomic::Ordering::Relaxed);
        cache.wake_daemon_if_parked();
        
        // To test when thread is None
        if let Ok(mut guard) = cache.shared_core.daemon_thread.lock() {
            *guard = None;
        }
        cache.shared_core.is_parked.store(true, core::sync::atomic::Ordering::Relaxed);
        cache.wake_daemon_if_parked();
    }
}
