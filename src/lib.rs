// ── no_std gate ───────────────────────────────────────────────────────────
// When the "std" feature is disabled we enter no_std mode.
// `extern crate alloc` provides Vec, Box, Arc etc. from the allocator crate.
// The RTOS / bare-metal environment must supply a global allocator.
#![cfg_attr(not(feature = "std"), no_std)]
#[cfg(not(feature = "std"))]
extern crate alloc;

// ── Public sub-modules ────────────────────────────────────────────────────
pub mod arena;
pub mod cache_padded;
pub mod daemon;
pub mod filters;
pub mod lossy_queue;
pub mod storage;
pub mod unsafe_core;
pub mod workers;

// ── Internal sync abstraction ─────────────────────────────────────────────
/// Type-routing module: selects the correct `Arc` implementation based on
/// the active feature flags.
///
/// | Feature    | Source               |
/// |------------|----------------------|
/// | `std`      | `std::sync::Arc`     |
/// | `loom`     | `loom::sync::Arc`    |
/// | _(neither)_| `alloc::sync::Arc`   |
pub(crate) mod sync {
    #[cfg(all(feature = "std", not(any(feature = "loom", loom))))]
    pub use std::sync::Arc;

    #[cfg(any(feature = "loom", loom))]
    pub use loom::sync::Arc;

    #[cfg(all(not(feature = "std"), not(any(feature = "loom", loom))))]
    pub use alloc::sync::Arc;

    #[cfg(not(any(feature = "loom", loom)))]
    pub type ArcSlice<T> = Arc<[T]>;

    #[cfg(any(feature = "loom", loom))]
    pub type ArcSlice<T> = Arc<Vec<T>>;

    #[cfg(not(any(feature = "loom", loom)))]
    #[inline(always)]
    pub fn new_arc_slice<T>(vec: Vec<T>) -> ArcSlice<T> {
        vec.into_boxed_slice().into()
    }

    #[cfg(any(feature = "loom", loom))]
    #[inline(always)]
    pub fn new_arc_slice<T>(vec: Vec<T>) -> ArcSlice<T> {
        Arc::new(vec)
    }

    pub mod atomic {
        #[cfg(not(any(feature = "loom", loom)))]
        pub use core::sync::atomic::{
            AtomicBool, AtomicPtr, AtomicU16, AtomicU32, AtomicU64, AtomicUsize, AtomicU8, Ordering,
        };

        #[cfg(any(feature = "loom", loom))]
        pub use loom::sync::atomic::{
            AtomicBool, AtomicPtr, AtomicU16, AtomicU32, AtomicU64, AtomicUsize, AtomicU8, Ordering,
        };
    }

    pub mod cell {
        #[cfg(not(any(feature = "loom", loom)))]
        pub struct UnsafeCell<T>(core::cell::UnsafeCell<T>);

        #[cfg(not(any(feature = "loom", loom)))]
        impl<T> UnsafeCell<T> {
            #[inline(always)]
            pub const fn new(data: T) -> Self {
                Self(core::cell::UnsafeCell::new(data))
            }

            #[inline(always)]
            pub fn get(&self) -> *mut T {
                self.0.get()
            }

            #[inline(always)]
            pub fn with<F, R>(&self, f: F) -> R
            where
                F: FnOnce(*const T) -> R,
            {
                f(self.0.get() as *const T)
            }

            #[inline(always)]
            pub fn with_mut<F, R>(&self, f: F) -> R
            where
                F: FnOnce(*mut T) -> R,
            {
                f(self.0.get())
            }
        }

        #[cfg(any(feature = "loom", loom))]
        pub use loom::cell::UnsafeCell;
    }
}

// ── Imports ───────────────────────────────────────────────────────────────
#[cfg(not(feature = "std"))]
use alloc::vec::Vec;

use crate::cache_padded::CachePadded;
use crate::daemon::{Command, Daemon};
use crate::lossy_queue::{LossyQueue, OneshotAck};
use crate::unsafe_core::{Cache, T1, T2, WorkerSlot};
use ahash::RandomState;
use core::hash::{BuildHasher, Hash};
use sync::atomic::{AtomicU32, AtomicU64, AtomicUsize, Ordering};
use sync::{Arc, ArcSlice, new_arc_slice};

// ── Config ────────────────────────────────────────────────────────────────

pub struct Config {
    pub capacity: usize,
    pub t1_slots: usize,
    pub t2_slots: usize,
    /// TTL duration in epoch ticks (one tick ≈ 100 ms in std mode).
    pub duration: u32,
    pub threads: usize,
    /// Daemon poll interval in **microseconds** (1 000–10 000 µs = 1–10 ms).
    /// Controls the latency vs. idle-CPU trade-off.
    /// Lower = faster hit-signal delivery, higher CPU when idle.
    /// Higher = more efficient idle, but hotter TLS buffers may stall longer.
    pub poll_us: u64,
    /// TLS flush threshold in **daemon ticks**.
    /// A Worker forces a TLS buffer flush when it detects that the Daemon
    /// tick counter has advanced by at least this many ticks since the last
    /// flush, regardless of buffer fill level.
    ///
    /// Rule of thumb: `flush_tick_threshold ≈ 1ms / poll_us`.
    /// For poll_us = 1 000 µs (1 ms): threshold = 1.
    /// For poll_us = 5 000 µs (5 ms): threshold = 1 (flush every 5 ms).
    pub flush_tick_threshold: u64,
}

impl Config {
    /// Budget-based constructor: specify RAM and TTL, the engine picks sizes.
    pub fn with_memory_budget(ram_mb: usize, duration: u32) -> Self {
        // Assume total overhead per item is ~128 bytes
        let raw_capacity = (ram_mb * 1024 * 1024) / 128;
        let capacity = raw_capacity.next_power_of_two().max(256);

        Self {
            capacity,
            // T1 fits in L1 cache: max 2048 × 8-byte pointers = 16 KB
            t1_slots: 2048,
            // T2 intercepts warm data: 20% of capacity (80/20 rule)
            t2_slots: (capacity / 5).next_power_of_two().max(4096),
            duration,
            #[cfg(feature = "std")]
            threads: std::thread::available_parallelism()
                .map(|p| p.get())
                .unwrap_or(16),
            #[cfg(not(feature = "std"))]
            threads: 8,
            poll_us: 1_000,
            flush_tick_threshold: 1,
        }
    }

    /// Expert constructor with explicit physical-law assertions.
    pub fn new_expert(
        capacity: usize,
        t1_slots: usize,
        t2_slots: usize,
        duration: u32,
        threads: usize,
    ) -> Self {
        // Physical Law 1: Bitmask routing requires powers of two
        assert!(capacity.is_power_of_two(), "Capacity MUST be a power of two");
        assert!(t1_slots.is_power_of_two(), "T1 slots MUST be a power of two");
        assert!(t2_slots.is_power_of_two(), "T2 slots MUST be a power of two");

        // Physical Law 2: T1 absolutely cannot exceed L1 cache
        assert!(
            t1_slots <= 4096,
            "T1 size exceeds L1 Cache physical limits! Max slots: 4096"
        );

        Self {
            capacity,
            t1_slots,
            t2_slots,
            duration,
            threads,
            poll_us: 1_000,
            flush_tick_threshold: 1,
        }
    }

    /// Builder: set Daemon poll interval (1 000–10 000 µs).
    pub fn with_poll_us(mut self, poll_us: u64) -> Self {
        self.poll_us = poll_us.clamp(1_000, 10_000);
        self
    }

    /// Builder: set TLS flush threshold in daemon ticks.
    pub fn with_flush_tick_threshold(mut self, ticks: u64) -> Self {
        self.flush_tick_threshold = ticks.max(1);
        self
    }
}

// ── QSBR global epoch ─────────────────────────────────────────────────────

/// Global QSBR epoch. Daemon increments this every maintenance cycle.
/// Workers store their local epoch on `get()` entry and reset to 0 on exit,
/// allowing Daemon to safely reclaim stale pointers.
#[cfg(any(feature = "loom", loom))]
loom::lazy_static! {
    pub static ref GLOBAL_EPOCH: loom::sync::atomic::AtomicUsize = loom::sync::atomic::AtomicUsize::new(1);
}

#[cfg(not(any(feature = "loom", loom)))]
pub static GLOBAL_EPOCH: sync::atomic::AtomicUsize = sync::atomic::AtomicUsize::new(1);

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
    next_id: sync::atomic::AtomicUsize,
}

#[cfg(all(feature = "std", not(any(feature = "loom", loom))))]
static ALLOCATOR: IdAllocator = IdAllocator {
    free_list: Mutex::new(Vec::new()),
    next_id: sync::atomic::AtomicUsize::new(0),
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
    static LAST_FLUSH_TICK: Cell<u64> = Cell::new(0);
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
    static LAST_FLUSH_TICK: Cell<u64> = Cell::new(0);
}

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
    pub daemon_tick: Arc<AtomicU64>,
    /// Number of daemon_tick advances that correspond to ≈1 ms of real time.
    pub flush_tick_threshold: u64,
    /// Cold-start flag: Daemon sets this to false when capacity is reached.
    pub is_cold_start: Arc<sync::atomic::AtomicBool>,
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
    pub fn new(config: Config) -> Self {
        let (cache, daemon) = Self::new_headless(config);
        #[cfg(any(feature = "loom", loom))]
        {
            let _ = daemon;
        }
        #[cfg(not(any(feature = "loom", loom)))]
        std::thread::spawn(move || daemon.run());
        cache
    }
}

// ── Constructor (universal — returns Daemon for manual scheduling) ─────────

impl<K, V> DualCacheFF<K, V, RandomState>
where
    K: Hash + Eq + Send + Sync + Clone + 'static,
    V: Send + Sync + Clone + 'static,
{
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
        let hasher = RandomState::new();
        let t1 = Arc::new(T1::new(config.t1_slots));
        let t2 = Arc::new(T2::new(config.t2_slots));
        let cache = Arc::new(Cache::new(config.capacity));
        let cmd_q: Arc<LossyQueue<Command<K, V>>> = Arc::new(LossyQueue::new(8192));
        let hit_q: Arc<LossyQueue<[usize; 64]>> = Arc::new(LossyQueue::new(1024));
        let epoch = Arc::new(AtomicU32::new(0));
        let daemon_tick = Arc::new(AtomicU64::new(0));
        let is_cold_start = Arc::new(sync::atomic::AtomicBool::new(true));

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
            flush_tick_threshold: config.flush_tick_threshold,
            is_cold_start,
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
        // ── std: flush TLS hit buffer ─────────────────────────────────────
        #[cfg(feature = "std")]
        HIT_BUF.with(|buf: &RefCell<([usize; 64], usize)>| {
            let mut state = buf.borrow_mut();
            if state.1 > 0_usize {
                let _ = self.hit_tx.try_send(state.0);
                state.1 = 0;
            }
        });

        // ── std: flush all worker slots ───────────────────────────────────
        #[cfg(feature = "std")]
        for slot in self.miss_buffers.iter() {
            let buf = unsafe { slot.get_mut_unchecked() };
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

        // ── QSBR Check-in (std only — requires TLS) ───────────────────────
        #[cfg(feature = "std")]
        let mut id_opt = None;
        #[cfg(feature = "std")]
        {
            let global_epoch = GLOBAL_EPOCH.load(Ordering::Relaxed);
            WORKER_ID.with(|&id| {
                if id < self.worker_states.len() {
                    self.worker_states[id]
                        .local_epoch
                        .store(global_epoch, Ordering::Relaxed);
                    id_opt = Some(id);
                }
            });
        }

        #[cfg(feature = "std")]
        let has_epoch = id_opt.is_some();
        #[cfg(not(feature = "std"))]
        let has_epoch = true;

        let mut res: Option<V> = None;
        let mut hit_g_idx: Option<u32> = None;

        if has_epoch {
            // ── T1 check ──────────────────────────────────────────────────────
            let ptr_t1: *mut crate::storage::Node<K, V> = self.t1.load_slot(hash);
            if !ptr_t1.is_null() {
                let node = unsafe { &*ptr_t1 };
                if node.key == *key
                    && (node.expire_at == 0 || node.expire_at >= current_epoch_cache)
                {
                    res = Some(node.value.clone());
                    hit_g_idx = Some(node.g_idx);
                }
            }

            // ── T2 check ──────────────────────────────────────────────────────
            if res.is_none() {
                let ptr_t2: *mut crate::storage::Node<K, V> = self.t2.load_slot(hash);
                if !ptr_t2.is_null() {
                    let node = unsafe { &*ptr_t2 };
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

        // ── QSBR Check-out (std only) ─────────────────────────────────────
        #[cfg(feature = "std")]
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

        // ── std path: L1 Probation Filter + TLS batch ─────────────────────
        #[cfg(feature = "std")]
        {
            let is_cold = self.is_cold_start.load(Ordering::Relaxed);
            let mut bypass = is_cold;

            if !bypass {
                // Perform thread-safe fast lookup to see if key exists
                // ── QSBR Check-in ───────────────────────
                let global_epoch = GLOBAL_EPOCH.load(Ordering::Relaxed);
                let mut id_opt = None;
                WORKER_ID.with(|&id| {
                    if id < self.worker_states.len() {
                        self.worker_states[id]
                            .local_epoch
                            .store(global_epoch, Ordering::Relaxed);
                        id_opt = Some(id);
                    }
                });

                if id_opt.is_some() {
                    // T1 check
                    let ptr_t1 = self.t1.load_slot(hash);
                    if !ptr_t1.is_null() {
                        let node = unsafe { &*ptr_t1 };
                        if node.key == key {
                            bypass = true;
                        }
                    }

                    // T2 check
                    if !bypass {
                        let ptr_t2 = self.t2.load_slot(hash);
                        if !ptr_t2.is_null() {
                            let node = unsafe { &*ptr_t2 };
                            if node.key == key {
                                bypass = true;
                            }
                        }
                    }

                    // Cache (L3) check
                    if !bypass {
                        let tag = (hash >> 48) as u16;
                        if let Some(global_idx) = self.cache.index_probe(hash, tag) {
                            let ptr = self.cache.nodes[global_idx].load(Ordering::Acquire);
                            if !ptr.is_null() {
                                let node = unsafe { &*ptr };
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
                #[cfg(any(feature = "loom", loom))]
                {
                    L1_FILTER.with(|f| {
                        let mut state = f.borrow_mut();
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
                    })
                }

                #[cfg(not(any(feature = "loom", loom)))]
                {
                    L1_FILTER.with(|f: &RefCell<([u8; 4096], usize)>| {
                        let mut state = f.borrow_mut();
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
                    })
                }
            };

            if !pass {
                return;
            }

            // Task 6: Time-based flush detection
            let current_tick = self.daemon_tick.load(Ordering::Relaxed);
            let should_time_flush = LAST_FLUSH_TICK.with(|c: &Cell<u64>| {
                current_tick.wrapping_sub(c.get()) >= self.flush_tick_threshold
            });

            // Worker TLS batch buffer
            WORKER_ID.with(|&id| {
                if id >= self.miss_buffers.len() {
                    // Worker overflow: gracefully degrade to direct send
                    let _ = self.cmd_tx.try_send(Command::Insert(key, value, hash));
                    return;
                }

                // Safety: WORKER_ID is unique per thread → exclusive slot access
                let buf = unsafe { self.miss_buffers[id].get_mut_unchecked() };
                let capacity_flush = buf.push((key, value, hash));

                if capacity_flush || (should_time_flush && !buf.is_empty()) {
                    let batch = buf.drain_to_vec();
                    let _ = self.cmd_tx.try_send(Command::BatchInsert(batch));
                    LAST_FLUSH_TICK.with(|c: &Cell<u64>| c.set(current_tick));
                }
            });
        }

        // ── no_std path: direct send (no TLS available) ───────────────────
        #[cfg(not(feature = "std"))]
        {
            let _ = self.cmd_tx.try_send(Command::Insert(key, value, hash));
        }
    }

    /// Remove a key from the cache.
    pub fn remove(&self, key: &K) {
        let hash = self.hash(key);

        // ── std: flush this thread's buffer first for causal ordering ─────
        #[cfg(feature = "std")]
        WORKER_ID.with(|&id| {
            if id < self.miss_buffers.len() {
                let buf = unsafe { self.miss_buffers[id].get_mut_unchecked() };
                if buf.len() > 0 {
                    let batch = buf.drain_to_vec();
                    let _ = self.cmd_tx.try_send(Command::BatchInsert(batch));
                    let tick = self.daemon_tick.load(Ordering::Relaxed);
                    LAST_FLUSH_TICK.with(|c: &Cell<u64>| c.set(tick));
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
    fn hash(&self, key: &K) -> u64 {
        self.hasher.hash_one(key)
    }

    /// Buffer a Cache-hit global index for Daemon processing.
    ///
    /// std: fills the 64-element TLS array and ships it to `hit_tx` when full.
    /// no_std: sends directly (no TLS batch buffering available).
    #[inline(always)]
    fn record_hit(&self, global_idx: usize) {
        #[cfg(feature = "std")]
        HIT_BUF.with(|buf: &RefCell<([usize; 64], usize)>| {
            let mut state = buf.borrow_mut();
            let idx = state.1;
            state.0[idx] = global_idx;
            state.1 += 1;
            if state.1 == 64_usize {
                let _ = self.hit_tx.try_send(state.0);
                state.1 = 0;
            }
        });

        // no_std: no TLS; hit signals are not batched.
        // Daemon still processes hits via hit_rx if sent individually.
        #[cfg(not(feature = "std"))]
        {
            let mut batch = [0usize; 64];
            batch[0] = global_idx;
            let _ = self.hit_tx.try_send(batch);
        }
    }
}

impl<K, V, S> Drop for DualCacheFF<K, V, S> {
    fn drop(&mut self) {
        if Arc::strong_count(&self.cmd_tx) <= 2 {
            let _ = self.cmd_tx.try_send(Command::Shutdown);
        }
    }
}

