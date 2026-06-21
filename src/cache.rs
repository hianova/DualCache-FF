extern crate alloc;
#[cfg(not(feature = "std"))]
use alloc::{vec, vec::Vec, boxed::Box};


use crate::daemon::{Command, Daemon};
use crate::lossy_queue::{LossyQueue, OneshotAck};
use crate::unsafe_core::{Cache, T1, T2, WorkerSlot};
use ahash::RandomState;
use core::hash::{BuildHasher, Hash, Hasher};
use crate::sync::atomic::{AtomicBool, AtomicU32, Ordering};
use crate::sync::index_types::{AtomicTick, TickType};
use crate::sync::{Arc, ArcSlice, new_arc_slice};
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
    /// QSBR registry: one entry per thread slot.
    pub worker_states: ArcSlice<WorkerState>,
    /// Per-worker zero-lock batch buffers, indexed by WORKER_ID.
    pub miss_buffers: ArcSlice<WorkerSlot<K, V>>,
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
            worker_states: self.worker_states.clone(),
            miss_buffers: self.miss_buffers.clone(),
            daemon_tick: self.daemon_tick.clone(),
            flush_tick_threshold: self.flush_tick_threshold,
            is_cold_start: self.is_cold_start.clone(),
            tls: self.tls.clone(),
            shared_core: self.shared_core.clone(),
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
    pub fn new_with_spawner(config: Config, spawner: DefaultSpawner) -> Self {
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
        Self::new_headless_with_callbacks(config, DefaultTls, RandomState::new(), None, None)
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
    pub fn new_with_tls_and_spawner(config: Config, tls: DefaultTls, spawner: DefaultSpawner) -> Self
    where
        S: Default,
    {
        Self::new_with_tls_and_spawner_and_callbacks(config, tls, spawner, None, None)
    }

    #[cfg(feature = "std")]
    pub fn new_with_tls_and_spawner_and_callbacks(
        config: Config,
        tls: DefaultTls,
        spawner: DefaultSpawner,
        on_evict: Option<Arc<dyn Fn(K, V) + Send + Sync>>,
        on_promote: Option<Arc<dyn Fn(K, V) + Send + Sync>>,
    ) -> Self
    where
        S: Default,
    {
        let (cache, daemon) = Self::new_headless_with_callbacks(config, tls, S::default(), on_evict, on_promote);
        spawner.spawn(alloc::boxed::Box::new(move || daemon.run()));
        cache
    }

    pub fn new_headless_with_callbacks(
        config: Config,
        tls: DefaultTls,
        hasher: S,
        on_evict: Option<Arc<dyn Fn(K, V) + Send + Sync>>,
        on_promote: Option<Arc<dyn Fn(K, V) + Send + Sync>>,
    ) -> (Self, Daemon<K, V, S>) {
        let t1 = Arc::new(T1::new(config.t1_slots));
        let t2 = Arc::new(T2::new(config.t2_slots));
        let cache = Arc::new(Cache::new(config.capacity));
        let cmd_q: Arc<LossyQueue<Command<K, V>>> = Arc::new(LossyQueue::new(8192));
        let hit_q: Arc<LossyQueue<[usize; 64]>> = Arc::new(LossyQueue::new(1024));
        let epoch = Arc::new(AtomicU32::new(0));
        let daemon_tick = Arc::new(AtomicTick::new(0));
        let is_cold_start = Arc::new(AtomicBool::new(true));

        let mut buffers = Vec::with_capacity(config.threads);
        let mut states = Vec::with_capacity(config.threads);
        for _ in 0..config.threads {
            buffers.push(WorkerSlot::new());
            states.push(WorkerState::new());
        }
        let miss_buffers = new_arc_slice(buffers);
        let worker_states = new_arc_slice(states);

        let core_cache = CoreCache::new(
            config.capacity,
            t1.clone(),
            t2.clone(),
            cache.clone(),
            epoch.clone(),
            config.duration,
            worker_states.clone(),
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
            cmd_tx: cmd_q,
            hit_tx: hit_q,
            epoch,
            worker_states,
            miss_buffers,
            daemon_tick,
            flush_tick_threshold: (config.poll_us as TickType).max(1),
            is_cold_start,
            tls,
            shared_core,
        };
        
        (this, daemon)
    }
}



// ── Public API (std + no_std) ─────────────────────────────────────────────

impl<K, V, S> DualCacheFF<K, V, S>
where
    K: Hash + Eq + Send + Sync + Clone + 'static,
    V: Send + Sync + Clone + 'static,
    S: BuildHasher + Clone + Send + 'static,
{
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

        // ── flush all worker slots ───────────────────────────────────
        for slot in self.miss_buffers.iter() {
            let buf: &mut crate::unsafe_core::BatchBuf<K, V> = slot.get_mut_safe();
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
        let hash = self.hash(key);
        let current_epoch_cache = self.epoch.load(Ordering::Relaxed);

        // ── QSBR Check-in ───────────────────────
        let mut id_opt = None;
        let global_epoch = GLOBAL_EPOCH.load(Ordering::Relaxed);
        self.with_worker_id(|id| {
            if id < self.worker_states.len() {
                self.worker_states[id]
                    .local_epoch
                    .store(global_epoch, Ordering::Relaxed);
                id_opt = Some(id);
            }
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
                    self.tls.with_warmup_state(|s| *s = s.saturating_add(10));
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
            self.worker_states[id]
                .local_epoch
                .store(0, Ordering::Relaxed);
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
                if id < self.worker_states.len() {
                    self.worker_states[id]
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
                self.worker_states[id]
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
            if id >= self.miss_buffers.len() {
                let _ = self.cmd_tx.try_send(Command::Insert(k, v, hash, is_t1));
                return;
            }
            let buf: &mut crate::unsafe_core::BatchBuf<K, V> = self.miss_buffers[id].get_mut_safe();
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
            if id < self.miss_buffers.len() {
                let buf: &mut crate::unsafe_core::BatchBuf<K, V> = self.miss_buffers[id].get_mut_safe();
                if !buf.is_empty() {
                    let batch = buf.drain_to_vec();
                    let _ = self.cmd_tx.try_send(Command::BatchInsert(batch));
                    let tick = self.daemon_tick.load(Ordering::Relaxed);
                    self.with_last_flush_tick(|c| *c = tick);
                }
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
            let idx = state.1;
            state.0[idx] = global_idx;
            state.1 += 1;
            if state.1 == 64_usize {
                let _ = self.hit_tx.try_send(state.0);
                #[cfg(feature = "std")]
                self.wake_daemon_if_parked();
                state.0 = [usize::MAX; 64];
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

impl<K, V, S> Drop for DualCacheFF<K, V, S> {
    fn drop(&mut self) {
        if Arc::strong_count(&self.cmd_tx) <= 2 {
            let _ = self.cmd_tx.try_send(Command::Shutdown);
            #[cfg(feature = "std")]
            self.wake_daemon_if_parked();
        }
    }
}

pub struct ColdStartSession<'a, K, V, S> {
    cache: &'a DualCacheFF<K, V, S>,
}

impl<'a, K, V, S> ColdStartSession<'a, K, V, S>
where
    K: Hash + Eq + Send + Sync + Clone + 'static,
    V: Send + Sync + Clone + 'static,
    S: BuildHasher + Clone + Send + 'static,
{
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
}
