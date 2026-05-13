use crate::daemon::{Command, Daemon};
use crate::unsafe_core::{Cache, T1, T2, WorkerSlot};
use ahash::RandomState;
use crossbeam_channel::{Sender, bounded};
use crossbeam_utils::CachePadded;
use std::cell::RefCell;
use std::hash::{BuildHasher, Hash};
use std::sync::Arc;
use std::sync::atomic::{AtomicU32, AtomicUsize, Ordering};

pub mod daemon;
pub mod unsafe_core;

pub struct Config {
    pub capacity: usize,
    pub t1_slots: usize,
    pub t2_slots: usize,
    pub duration: u32,
    pub threads: usize,
}

impl Config {
    /// Gives general developers a "budget-based" initialization.
    /// Just tell the engine how much RAM you're willing to give, and the engine
    /// calculates the golden ratio that fits physical limits.
    pub fn with_memory_budget(ram_mb: usize, duration: u32) -> Self {
        // Assume total overhead per item is ~128 bytes
        let raw_capacity = (ram_mb * 1024 * 1024) / 128;
        let capacity = raw_capacity.next_power_of_two();

        Self {
            capacity,
            // T1 sticks to L1 Cache physical limit: max 2048 pointers (16KB)
            t1_slots: 2048,
            // T2 responsible for intercepting warm data, set to 20% of total capacity (80/20 rule)
            t2_slots: (capacity / 5).next_power_of_two().max(4096),
            duration,
            // Default to a reasonable number of threads to avoid TLS bloat.
            threads: std::thread::available_parallelism()
                .map(|p| p.get())
                .unwrap_or(16),
        }
    }

    /// Gives hardcore players a "form-based" initialization with physical safety mechanisms.
    pub fn new_expert(
        capacity: usize,
        t1_slots: usize,
        t2_slots: usize,
        duration: u32,
        threads: usize,
    ) -> Self {
        // Physical Law 1: Bitmask routing must be power of two
        assert!(
            capacity.is_power_of_two(),
            "Capacity MUST be a power of two"
        );
        assert!(
            t1_slots.is_power_of_two(),
            "T1 slots MUST be a power of two"
        );
        assert!(
            t2_slots.is_power_of_two(),
            "T2 slots MUST be a power of two"
        );

        // Physical Law 2: T1 is absolutely not allowed to exceed L1 Cache
        // (Assuming 32KB limit, i.e., 4096 8-byte pointers)
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
        }
    }
}

/// Global atomic counter for assigning unique thread IDs.
/// Each thread calls fetch_add(1) exactly once in its lifetime.
static NEXT_THREAD_ID: AtomicUsize = AtomicUsize::new(0);

thread_local! {
    static WORKER_ID: usize = NEXT_THREAD_ID.fetch_add(1, Ordering::Relaxed);
    static HIT_BUF: RefCell<([usize; 64], usize)> = const { RefCell::new(([0; 64], 0)) };
    static L1_FILTER: RefCell<([u8; 4096], usize)> = const { RefCell::new(([0; 4096], 0)) };
}

pub static GLOBAL_EPOCH: AtomicUsize = AtomicUsize::new(1);

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

pub struct DualCacheFF<K, V, S = RandomState> {
    pub hasher: S,
    pub t1: Arc<T1<K, V>>,
    pub t2: Arc<T2<K, V>>,
    pub cache: Arc<Cache<K, V>>,
    pub cmd_tx: Sender<Command<K, V>>,
    pub hit_tx: Sender<[usize; 64]>,
    pub epoch: Arc<AtomicU32>,
    /// QSBR registry for each worker.
    pub worker_states: Arc<[WorkerState]>,
    /// Per-worker zero-lock batch buffers, indexed by WORKER_ID.
    pub miss_buffers: Arc<[WorkerSlot<K, V>]>,
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
        }
    }
}

impl<K, V> DualCacheFF<K, V, RandomState>
where
    K: Hash + Eq + Send + Sync + Clone + 'static,
    V: Send + Sync + Clone + 'static,
{
    #[allow(clippy::too_many_arguments)]
    pub fn new(config: Config) -> Self {
        let hasher = RandomState::new();
        let t1 = Arc::new(T1::new(config.t1_slots));
        let t2 = Arc::new(T2::new(config.t2_slots));
        let cache = Arc::new(Cache::new(config.capacity));
        let (cmd_tx, cmd_rx) = bounded(8192);
        let (hit_tx, hit_rx) = bounded(1024);
        let epoch = Arc::new(AtomicU32::new(0));

        let mut buffers = Vec::with_capacity(config.threads);
        let mut states = Vec::with_capacity(config.threads);
        for _ in 0..config.threads {
            buffers.push(WorkerSlot::new());
            states.push(WorkerState::new());
        }
        let miss_buffers: Arc<[_]> = buffers.into_boxed_slice().into();
        let worker_states: Arc<[_]> = states.into_boxed_slice().into();

        let daemon = Daemon::new(
            hasher.clone(),
            config.capacity,
            t1.clone(),
            t2.clone(),
            cache.clone(),
            cmd_rx,
            hit_rx,
            epoch.clone(),
            config.duration,
            worker_states.clone(),
        );

        std::thread::spawn(move || {
            daemon.run();
        });

        Self {
            hasher,
            t1,
            t2,
            cache,
            cmd_tx,
            hit_tx,
            epoch,
            worker_states,
            miss_buffers,
        }
    }
}

impl<K, V, S> DualCacheFF<K, V, S>
where
    K: Hash + Eq + Send + Sync + Clone + 'static,
    V: Send + Sync + Clone + 'static,
    S: BuildHasher + Clone + Send + 'static,
{
    pub fn sync(&self) {
        // 1. Flush this thread's hit buffer
        HIT_BUF.with(|buf| {
            let mut state = buf.borrow_mut();
            if state.1 > 0 {
                let _ = self.hit_tx.try_send(state.0);
                state.1 = 0;
            }
        });

        // 2. Flush all worker slots (best effort for others, strictly correct for self)
        for slot in self.miss_buffers.iter() {
            let buf = unsafe { slot.get_mut_unchecked() };
            if buf.len() > 0 {
                let batch = buf.drain_to_vec();
                // Use blocking send here if we really want to ensure sync
                let _ = self.cmd_tx.send(Command::BatchInsert(batch));
            }
        }

        let (tx, rx) = bounded(1);
        if self.cmd_tx.send(Command::Sync(tx)).is_ok() {
            let _ = rx.recv();
        }
    }

    pub fn get(&self, key: &K) -> Option<V> {
        let hash = self.hash(key);
        let current_epoch_cache = self.epoch.load(Ordering::Relaxed);

        // QSBR Check-in
        let global_epoch = GLOBAL_EPOCH.load(Ordering::Relaxed);
        WORKER_ID.with(|&id| {
            if id < self.worker_states.len() {
                self.worker_states[id]
                    .local_epoch
                    .store(global_epoch, Ordering::Relaxed);
            }
        });

        let mut res = None;
        let mut hit_g_idx = None;

        // T1 check
        let ptr_t1 = self.t1.load_slot(hash);
        if !ptr_t1.is_null() {
            let node = unsafe { &*ptr_t1 };
            if node.key == *key && (node.expire_at == 0 || node.expire_at >= current_epoch_cache) {
                res = Some(node.value.clone());
                hit_g_idx = Some(node.g_idx);
            }
        }

        // T2 check
        if res.is_none() {
            let ptr_t2 = self.t2.load_slot(hash);
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

        // Cache Check
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

        // QSBR Check-out
        WORKER_ID.with(|&id| {
            if id < self.worker_states.len() {
                self.worker_states[id]
                    .local_epoch
                    .store(0, Ordering::Relaxed);
            }
        });

        if let Some(g_idx) = hit_g_idx {
            self.record_hit(g_idx as usize);
        }

        res
    }

    pub fn insert(&self, key: K, value: V) {
        let hash = self.hash(&key);

        // TLS L1 Filter: drop single-hit items but allow >= 2
        let pass = L1_FILTER.with(|f| {
            let mut state = f.borrow_mut();
            let idx = (hash as usize) & 4095;
            let val = state.0[idx];

            state.1 += 1;
            if state.1 >= 4096 {
                for x in state.0.iter_mut() {
                    *x >>= 1;
                }
                state.1 = 0;
            }

            if val < 1 {
                state.0[idx] = 1;
                false
            } else {
                if val < 2 {
                    state.0[idx] = 2;
                }
                true
            }
        });

        if !pass {
            return;
        }

        // Thread-ID mapped wait-free batching:
        // Each Worker has a unique WORKER_ID → exclusive UnsafeCell slot.
        // 0 Mutex, 0 Atomic, pure memory write. Flush every 32 items.
        WORKER_ID.with(|&id| {
            if id >= self.miss_buffers.len() {
                // Overflow protection: drop silently (lossy)
                return;
            }

            // Safety: id is unique per thread → exclusive access to this slot
            let buf = unsafe { self.miss_buffers[id].get_mut_unchecked() };

            if buf.push((key, value, hash)) {
                let batch = buf.drain_to_vec();
                let _ = self.cmd_tx.try_send(Command::BatchInsert(batch));
            }
        });
    }

    pub fn remove(&self, key: &K) {
        let hash = self.hash(key);
        // Flush this thread's buffer first for causal ordering
        WORKER_ID.with(|&id| {
            if id < self.miss_buffers.len() {
                let buf = unsafe { self.miss_buffers[id].get_mut_unchecked() };
                if buf.len() > 0 {
                    let batch = buf.drain_to_vec();
                    let _ = self.cmd_tx.try_send(Command::BatchInsert(batch));
                }
            }
        });

        let _ = self.cmd_tx.try_send(Command::Remove(key.clone(), hash));
    }

    pub fn clear(&self) {
        let (tx, rx) = bounded(1);
        if self.cmd_tx.send(Command::Clear(tx)).is_ok() {
            let _ = rx.recv();
        }
    }

    fn hash(&self, key: &K) -> u64 {
        self.hasher.hash_one(key)
    }

    fn record_hit(&self, global_idx: usize) {
        HIT_BUF.with(|buf| {
            let mut state = buf.borrow_mut();
            let idx = state.1;
            state.0[idx] = global_idx;
            state.1 += 1;
            if state.1 == 64 {
                let _ = self.hit_tx.try_send(state.0);
                state.1 = 0;
            }
        });
    }
}
