extern crate alloc;
#[cfg(not(feature = "std"))]
use alloc::{vec, vec::Vec, boxed::Box};
#[cfg(feature = "std")]
use std::vec;
use crate::cache_padded::CachePadded;
use crate::daemon::{Command, Daemon};
use crate::lossy_queue::{LossyQueue, OneshotAck};
use crate::unsafe_core::{Cache, T1, T2, WorkerSlot};
use ahash::RandomState;
use core::hash::{BuildHasher, Hash};
use crate::sync::atomic::{AtomicBool, AtomicU32, AtomicUsize, Ordering};
use crate::sync::index_types::{AtomicTick, TickType};
use crate::sync::{Arc, ArcSlice, new_arc_slice};
use crate::config::Config;

// ── QSBR global epoch ─────────────────────────────────────────────────────

// Global QSBR epoch. Daemon increments this every maintenance cycle.
// Workers store their local epoch on `get()` entry and reset to 0 on exit,
// allowing Daemon to safely reclaim stale pointers.
#[cfg(any(feature = "loom", loom))]
loom::lazy_static! {
    pub static ref GLOBAL_EPOCH: loom::sync::atomic::AtomicUsize = loom::sync::atomic::AtomicUsize::new(1);
}

#[cfg(not(any(feature = "loom", loom)))]
pub static GLOBAL_EPOCH: AtomicUsize = AtomicUsize::new(1);

/// Per-worker QSBR state — cache-line padded to prevent false sharing
/// between workers checking in/out simultaneously.
pub struct WorkerState {
    pub local_epoch: CachePadded<AtomicUsize>,
}

impl WorkerState {
    pub fn new() -> Self {
        Self {
            local_epoch: CachePadded::new(AtomicUsize::new(0)),
        }
    }
}

// ── Trait-based custom executors and thread-local providers ───────────────

/// Trait for custom thread/task executors to spawn the background Daemon.
///
/// Decouples `std::thread::spawn` from `DualCacheFF::new`, enabling execution on Tokio,
/// FreeRTOS tasks, Loom virtual threads, or other user-defined runtimes.
pub trait DaemonSpawner: Send + Sync {
    /// Spawn a closure as a concurrent background execution unit.
    fn spawn(&self, f: alloc::boxed::Box<dyn FnOnce() + Send + 'static>);
}

/// A default spawner using `std::thread::spawn` for `std` environments.
#[cfg(feature = "std")]
#[derive(Debug, Clone, Copy, Default)]
pub struct DefaultSpawner;

#[cfg(feature = "std")]
impl DaemonSpawner for DefaultSpawner {
    #[inline]
    fn spawn(&self, f: alloc::boxed::Box<dyn FnOnce() + Send + 'static>) {
        #[cfg(any(feature = "loom", loom))]
        loom::thread::spawn(move || f());
        #[cfg(not(any(feature = "loom", loom)))]
        std::thread::spawn(move || f());
    }
}

/// Trait for plug-and-play Thread-Local Storage (TLS) in `no_std` or custom RTOS environments.
///
/// Enables thread-local batching of hits and L1 probation filtering on platforms
/// where standard `thread_local!` is not available.
pub trait TlsProvider: Send + Sync {
    /// Get the current worker thread ID (0..config.threads).
    ///
    /// Returns `None` if the thread is not registered or cannot be resolved.
    fn get_worker_id(&self) -> Option<usize>;

    /// Access the thread-local Hit Buffer array.
    ///
    /// The provider must execute the given closure with a mutable reference to the
    /// current thread's batch buffer: `([usize; 64], usize)`.
    fn with_hit_buf(&self, f: &mut dyn FnMut(&mut ([usize; 64], usize)));

    /// Access the thread-local L1 Probation Filter.
    ///
    /// The provider must execute the given closure with a mutable reference to the
    /// current thread's L1 probation filter state: `([u8; 4096], usize)`.
    fn with_l1_filter(&self, f: &mut dyn FnMut(&mut ([u8; 4096], usize)));

    /// Access the thread-local Last Flush Tick.
    ///
    /// The provider must execute the given closure with a mutable reference to the
    /// current thread's last flush tick value.
    fn with_last_flush_tick(&self, f: &mut dyn FnMut(&mut TickType));
}

// ── Thread-local state (std only) ────────────────────────────────────────
// In no_std / RTOS mode, TLS is not available. Worker state must be
// managed by the application (e.g. passed as function arguments or stored
// in RTOS task-local storage). The cache's `get` / `insert` / `remove`
// methods fall back to safe, lock-free direct-send paths in no_std mode.

#[cfg(all(feature = "std", not(any(feature = "loom", loom))))]
use std::sync::Mutex;

#[cfg(all(feature = "std", not(any(feature = "loom", loom))))]
struct IdAllocator {
    free_list: Mutex<Vec<usize>>,
    next_id: AtomicUsize,
}

#[cfg(all(feature = "std", not(any(feature = "loom", loom))))]
static ALLOCATOR: IdAllocator = IdAllocator {
    free_list: Mutex::new(Vec::new()),
    next_id: AtomicUsize::new(0),
};

#[cfg(all(feature = "std", not(any(feature = "loom", loom))))]
struct ThreadIdGuard {
    id: usize,
}

#[cfg(all(feature = "std", not(any(feature = "loom", loom))))]
impl Drop for ThreadIdGuard {
    fn drop(&mut self) {
        if let Ok(mut list) = ALLOCATOR.free_list.lock() {
            list.push(self.id);
        }
    }
}

#[cfg(all(feature = "std", not(any(feature = "loom", loom))))]
use core::cell::{Cell, RefCell};

#[cfg(all(feature = "std", not(any(feature = "loom", loom))))]
thread_local! {
    static WORKER_ID: usize = {
        let id = if let Ok(mut list) = ALLOCATOR.free_list.lock() {
            list.pop().unwrap_or_else(|| ALLOCATOR.next_id.fetch_add(1, Ordering::Relaxed))
        } else {
            ALLOCATOR.next_id.fetch_add(1, Ordering::Relaxed)
        };
        
        GUARD.with(|g| {
            *g.borrow_mut() = Some(ThreadIdGuard { id });
        });
        id
    };

    static GUARD: RefCell<Option<ThreadIdGuard>> = const { RefCell::new(None) };

    /// Hit index buffer: batches 64 Cache-hit global indices before sending
    /// to Daemon via the hit queue.
    static HIT_BUF: RefCell<([usize; 64], usize)> = const { RefCell::new(([0; 64], 0)) };

    /// TLS probation filter: prevents single-hit items from reaching the
    /// Arena. A 4 KB sketch that decays periodically.
    static L1_FILTER: RefCell<([u8; 4096], usize)> = const { RefCell::new(([0; 4096], 0)) };

    /// Task 6 — last daemon_tick observed at TLS flush time.
    /// When `daemon_tick - LAST_FLUSH_TICK >= flush_tick_threshold`, the
    /// Worker force-drains its TLS buffer even if it is not full.
    static LAST_FLUSH_TICK: Cell<TickType> = const { Cell::new(0) };
}

#[cfg(any(feature = "loom", loom))]
loom::lazy_static! {
    static ref NEXT_THREAD_ID: loom::sync::atomic::AtomicUsize = loom::sync::atomic::AtomicUsize::new(0);
}

#[cfg(any(feature = "loom", loom))]
use core::cell::{Cell, RefCell};

#[cfg(any(feature = "loom", loom))]
loom::thread_local! {
    static WORKER_ID: usize = NEXT_THREAD_ID.fetch_add(1, Ordering::Relaxed);

    /// Hit index buffer: batches 64 Cache-hit global indices before sending
    /// to Daemon via the hit queue.
    static HIT_BUF: RefCell<([usize; 64], usize)> = RefCell::new(([0; 64], 0));

    /// TLS probation filter: prevents single-hit items from reaching the
    /// Arena. A 4 KB sketch that decays periodically.
    /// Heap-allocated under Loom via `vec!` to prevent virtual coroutine stack overflow.
    static L1_FILTER: RefCell<(Box<[u8]>, usize)> = RefCell::new((vec![0u8; 4096].into_boxed_slice(), 0));

    /// Task 6 — last daemon_tick observed at TLS flush time.
    /// When `daemon_tick - LAST_FLUSH_TICK >= flush_tick_threshold`, the
    /// Worker force-drains its TLS buffer even if it is not full.
    static LAST_FLUSH_TICK: Cell<TickType> = Cell::new(0);
}

// ── Default TLS Provider ──────────────────────────────────────────────────
pub struct DefaultTls;

impl Clone for DefaultTls {
    fn clone(&self) -> Self {
        Self
    }
}

#[cfg(any(feature = "std", feature = "loom", loom))]
impl TlsProvider for DefaultTls {
    #[inline(always)]
    fn get_worker_id(&self) -> Option<usize> {
        Some(WORKER_ID.with(|id| *id))
    }

    #[inline(always)]
    fn with_hit_buf(&self, f: &mut dyn FnMut(&mut ([usize; 64], usize))) {
        HIT_BUF.with(|buf| {
            f(&mut *buf.borrow_mut());
        });
    }

    #[inline(always)]
    fn with_l1_filter(&self, f: &mut dyn FnMut(&mut ([u8; 4096], usize))) {
        L1_FILTER.with(|filter| {
            #[cfg(any(feature = "loom", loom))]
            {
                let mut state = filter.borrow_mut();
                let mut arr = [0u8; 4096];
                arr.copy_from_slice(&state.0);
                let mut temp = (arr, state.1);
                f(&mut temp);
                state.0.copy_from_slice(&temp.0);
                state.1 = temp.1;
            }
            #[cfg(not(any(feature = "loom", loom)))]
            {
                f(&mut *filter.borrow_mut());
            }
        });
    }

    #[inline(always)]
    fn with_last_flush_tick(&self, f: &mut dyn FnMut(&mut TickType)) {
        LAST_FLUSH_TICK.with(|cell| {
            let mut val = cell.get();
            f(&mut val);
            cell.set(val);
        });
    }
}

#[cfg(not(any(feature = "std", feature = "loom", loom)))]
impl TlsProvider for DefaultTls {
    #[inline(always)]
    fn get_worker_id(&self) -> Option<usize> {
        None
    }

    #[inline(always)]
    fn with_hit_buf(&self, _f: &mut dyn FnMut(&mut ([usize; 64], usize))) {}

    #[inline(always)]
    fn with_l1_filter(&self, _f: &mut dyn FnMut(&mut ([u8; 4096], usize))) {}

    #[inline(always)]
    fn with_last_flush_tick(&self, _f: &mut dyn FnMut(&mut TickType)) {}
}

// ── DualCacheFF ───────────────────────────────────────────────────────────

pub struct DualCacheFF<K, V, S = RandomState, Tls: TlsProvider = DefaultTls> {
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
    pub tls: Tls,
}

impl<K, V, S: Clone, Tls: TlsProvider + Clone> Clone for DualCacheFF<K, V, S, Tls> {
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
        }
    }
}

// ── Constructor (std mode — auto-spawns Daemon thread) ────────────────────

#[cfg(feature = "std")]
impl<K, V> DualCacheFF<K, V, RandomState, DefaultTls>
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
}

#[cfg(feature = "std")]
impl<K, V, Tls> DualCacheFF<K, V, RandomState, Tls>
where
    K: Hash + Eq + Send + Sync + Clone + 'static,
    V: Send + Sync + Clone + 'static,
    Tls: TlsProvider + 'static,
{
    /// Create a new `DualCacheFF` and automatically spawn the background Daemon using a custom thread-local storage provider.
    #[inline]
    pub fn new_with_tls(config: Config, tls: Tls) -> Self {
        Self::new_with_tls_and_spawner(config, tls, DefaultSpawner)
    }
}

// ── Constructor (universal — returns Daemon for manual scheduling) ─────────

impl<K, V> DualCacheFF<K, V, RandomState, DefaultTls>
where
    K: Hash + Eq + Send + Sync + Clone + 'static,
    V: Send + Sync + Clone + 'static,
{
    /// Create a new `DualCacheFF` and automatically spawn the background Daemon using a custom spawner.
    pub fn new_with_spawner<Sp: DaemonSpawner + 'static>(config: Config, spawner: Sp) -> Self {
        let (cache, daemon) = Self::new_headless(config);
        #[cfg(any(feature = "loom", loom))]
        {
            let _ = daemon;
            let _ = spawner;
        }
        #[cfg(not(any(feature = "loom", loom)))]
        {
            spawner.spawn(alloc::boxed::Box::new(move || daemon.run()));
        }
        cache
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
        Self::new_headless_with_tls(config, DefaultTls)
    }
}

impl<K, V, Tls> DualCacheFF<K, V, RandomState, Tls>
where
    K: Hash + Eq + Send + Sync + Clone + 'static,
    V: Send + Sync + Clone + 'static,
    Tls: TlsProvider + 'static,
{
    /// Create a `DualCacheFF` and its `Daemon` with a custom thread-local storage provider.
    pub fn new_headless_with_tls(
        config: Config,
        tls: Tls,
    ) -> (Self, Daemon<K, V, RandomState>) {
        let hasher = RandomState::new();
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

        let daemon = Daemon::new(
            hasher.clone(),
            config.capacity,
            t1.clone(),
            t2.clone(),
            cache.clone(),
            cmd_q.clone(),
            hit_q.clone(),
            epoch.clone(),
            config.duration,
            config.poll_us,
            worker_states.clone(),
            daemon_tick.clone(),
            is_cold_start.clone(),
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
        };
        
        (this, daemon)
    }

    /// Create a `DualCacheFF` and spawn its `Daemon` using both a custom TLS provider and custom spawner.
    pub fn new_with_tls_and_spawner<Sp: DaemonSpawner + 'static>(config: Config, tls: Tls, spawner: Sp) -> Self
    {
        let (cache, daemon) = Self::new_headless_with_tls(config, tls);
        #[cfg(any(feature = "loom", loom))]
        {
            let _ = daemon;
            let _ = spawner;
        }
        #[cfg(not(any(feature = "loom", loom)))]
        {
            spawner.spawn(alloc::boxed::Box::new(move || daemon.run()));
        }
        cache
    }

}

// ── Public API (std + no_std) ─────────────────────────────────────────────

impl<K, V, S, Tls: TlsProvider> DualCacheFF<K, V, S, Tls>
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
                state.1 = 0;
            }
        });

        // ── flush all worker slots ───────────────────────────────────
        for slot in self.miss_buffers.iter() {
            let buf: &mut crate::unsafe_core::BatchBuf<K, V> = slot.get_mut_safe();
            if buf.len() > 0 {
                let batch = buf.drain_to_vec();
                let _ = self.cmd_tx.try_send(Command::BatchInsert(batch));
            }
        }

        // Send a Sync command and spin-wait for acknowledgment
        let ack = OneshotAck::new();
        self.cmd_tx.send_blocking(Command::Sync(ack.clone()));
        ack.wait();
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
            if let Some(node) = self.t1.get_node(hash) {
                if node.key == *key
                    && (node.expire_at == 0 || node.expire_at >= current_epoch_cache)
                {
                    res = Some(node.value.clone());
                    hit_g_idx = Some(node.g_idx);
                }
            }

            // ── T2 check ──────────────────────────────────────────────────────
            if res.is_none() {
                if let Some(node) = self.t2.get_node(hash) {
                    if node.key == *key
                        && (node.expire_at == 0 || node.expire_at >= current_epoch_cache)
                    {
                        res = Some(node.value.clone());
                        hit_g_idx = Some(node.g_idx);
                    }
                }
            }

            // ── Cache (L3) check ──────────────────────────────────────────────
            if res.is_none() {
                let tag = (hash >> 48) as u16;
                if let Some(global_idx) = self.cache.index_probe(hash, tag) {
                    if let Some(v) = self
                        .cache
                        .node_get_full(global_idx, key, current_epoch_cache)
                    {
                        res = Some(v);
                        hit_g_idx = Some(global_idx as u32);
                    }
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
            self.record_hit(g_idx as usize);
        }

        res
    }

    /// Insert a key-value pair.
    ///
    /// # L1 Probation Filter (std only)
    /// Items that appear only once in a TLS epoch are silently dropped.
    /// This prevents cache pollution from scan traffic.
    /// In no_std mode the filter is skipped and all items are forwarded.
    ///
    /// # Task 6 — Time-based TLS Flush (std only)
    /// The TLS batch buffer normally flushes when it reaches 32 items.
    /// Additionally, if the Daemon tick counter has advanced by at least
    /// `flush_tick_threshold` since the last flush, the buffer is force-drained
    /// even if nearly empty. This prevents hot items from being invisible to
    /// the Daemon for too long (the "split-brain eviction" bug).
    pub fn insert(&self, key: K, value: V) {
        let hash = self.hash(&key);

        let mut id_opt = None;
        let is_cold = self.is_cold_start.load(Ordering::Relaxed);
        let mut bypass = is_cold;

        if !bypass {
            // Perform thread-safe fast lookup to see if key exists
            // ── QSBR Check-in ───────────────────────
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
                // T1 check
                if let Some(node) = self.t1.get_node(hash) {
                    if node.key == key {
                        bypass = true;
                    }
                }

                // T2 check
                if !bypass {
                    if let Some(node) = self.t2.get_node(hash) {
                        if node.key == key {
                            bypass = true;
                        }
                    }
                }

                // Cache (L3) check
                if !bypass {
                    let tag = (hash >> 48) as u16;
                    if let Some(global_idx) = self.cache.index_probe(hash, tag) {
                        if let Some(node) = self.cache.get_node(global_idx) {
                            if node.key == key {
                                bypass = true;
                            }
                        }
                    }
                }
            }

            // ── QSBR Check-out ─────────────────────────────────────
            if let Some(id) = id_opt {
                self.worker_states[id]
                    .local_epoch
                    .store(0, Ordering::Relaxed);
            }
        }

        let pass = if bypass {
            true
        } else {
            // L1 Probation Filter
            self.with_l1_filter(|state| {
                let idx = (hash as usize) & 4095_usize;
                let val = state.0[idx];

                state.1 += 1;
                if state.1 >= 4096_usize {
                    for x in state.0.iter_mut() {
                        *x >>= 1;
                    }
                    state.1 = 0;
                }

                if val < 1_u8 {
                    state.0[idx] = 1;
                    false
                } else {
                    if val < 2_u8 {
                        state.0[idx] = 2;
                    }
                    true
                }
            }).unwrap_or(true) // no TLS -> pass-through
        };

        if !pass {
            return;
        }

        // Task 6: Time-based flush detection
        let current_tick = self.daemon_tick.load(Ordering::Relaxed);
        let mut should_time_flush = false;
        self.with_last_flush_tick(|tick| {
            should_time_flush = current_tick.wrapping_sub(*tick) >= self.flush_tick_threshold;
        });

        // Worker TLS batch buffer
        let mut option_kv = Some((key, value));
        let pushed_to_buf = self.with_worker_id(|id| {
            let (k, v) = option_kv.take().unwrap();
            if id >= self.miss_buffers.len() {
                // Worker overflow: gracefully degrade to direct send
                let _ = self.cmd_tx.try_send(Command::Insert(k, v, hash));
                return;
            }

            // Safety: id is unique per thread → exclusive slot access
            let buf: &mut crate::unsafe_core::BatchBuf<K, V> = self.miss_buffers[id].get_mut_safe();
            let capacity_flush = buf.push((k, v, hash));

            if capacity_flush || (should_time_flush && !buf.is_empty()) {
                let batch = buf.drain_to_vec();
                let _ = self.cmd_tx.try_send(Command::BatchInsert(batch));
                self.with_last_flush_tick(|tick| {
                    *tick = current_tick;
                });
            }
        });

        if pushed_to_buf.is_none() {
            if let Some((k, v)) = option_kv {
                let _ = self.cmd_tx.try_send(Command::Insert(k, v, hash));
            }
        }
    }

    /// Insert a key-value pair directly as a high-priority "genius" item.
    /// This bypasses the L1 probation filter, doesn't use the thread-local batch buffer,
    /// and assigns the item the maximum survival rank (e.g. 255) and promotes it to T1 immediately.
    pub fn insert_t1(&self, key: K, value: V) {
        let hash = self.hash(&key);
        let _ = self.cmd_tx.try_send(Command::InsertT1(key, value, hash));
    }

    /// Remove a key from the cache.
    pub fn remove(&self, key: &K) {
        let hash = self.hash(key);

        // ── flush this thread's buffer first for causal ordering ─────
        self.with_worker_id(|id| {
            if id < self.miss_buffers.len() {
                let buf: &mut crate::unsafe_core::BatchBuf<K, V> = self.miss_buffers[id].get_mut_safe();
                if buf.len() > 0 {
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
        let ack = OneshotAck::new();
        self.cmd_tx.send_blocking(Command::Clear(ack.clone()));
        ack.wait();
    }

    // ── Internals ─────────────────────────────────────────────────────────

    #[inline(always)]
    fn with_worker_id<F, R>(&self, f: F) -> Option<R>
    where
        F: FnOnce(usize) -> R,
    {
        self.tls.get_worker_id().map(f)
    }

    #[inline(always)]
    fn with_hit_buf<F, R>(&self, mut f: F) -> Option<R>
    where
        F: FnMut(&mut ([usize; 64], usize)) -> R,
    {
        let mut res = None;
        self.tls.with_hit_buf(&mut |buf| {
            res = Some(f(buf));
        });
        res
    }

    #[inline(always)]
    fn with_l1_filter<F, R>(&self, mut f: F) -> Option<R>
    where
        F: FnMut(&mut ([u8; 4096], usize)) -> R,
    {
        let mut res = None;
        self.tls.with_l1_filter(&mut |filter| {
            res = Some(f(filter));
        });
        res
    }

    #[inline(always)]
    fn with_last_flush_tick<F, R>(&self, mut f: F) -> Option<R>
    where
        F: FnMut(&mut TickType) -> R,
    {
        let mut res = None;
        self.tls.with_last_flush_tick(&mut |tick| {
            res = Some(f(tick));
        });
        res
    }

    #[inline(always)]
    fn hash(&self, key: &K) -> u64 {
        self.hasher.hash_one(key)
    }

    /// Buffer a Cache-hit global index for Daemon processing.
    ///
    /// std: fills the 64-element TLS array and ships it to `hit_tx` when full.
    /// no_std: sends directly (no TLS batch buffering available).
    #[inline(always)]
    fn record_hit(&self, global_idx: usize) {
        let opt = self.with_hit_buf(|state| {
            let idx = state.1;
            state.0[idx] = global_idx;
            state.1 += 1;
            if state.1 == 64_usize {
                let _ = self.hit_tx.try_send(state.0);
                state.1 = 0;
            }
        });

        if opt.is_none() {
            let mut batch = [0usize; 64];
            batch[0] = global_idx;
            let _ = self.hit_tx.try_send(batch);
        }
    }
}

impl<K, V, S, Tls: TlsProvider> Drop for DualCacheFF<K, V, S, Tls> {
    fn drop(&mut self) {
        if Arc::strong_count(&self.cmd_tx) <= 2 {
            let _ = self.cmd_tx.try_send(Command::Shutdown);
        }
    }
}

