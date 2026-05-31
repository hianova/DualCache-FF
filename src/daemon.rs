#[cfg(not(feature = "std"))]
use alloc::{boxed::Box, vec::Vec};

use crate::sync::{Arc, ArcSlice, new_arc_slice};
use crate::sync::atomic::{AtomicBool, AtomicU16, AtomicU32, Ordering};
use crate::sync::index_types::AtomicTick;
use core::hash::{Hash, BuildHasher};

use crate::arena::Arena;
use crate::storage::{Cache, Node};
use crate::filters::{T1, T2};
use crate::lossy_queue::{LossyQueue, OneshotAck};
use crate::cache::{WorkerState, GLOBAL_EPOCH};

/// Maximum rank (Revolution Shield value).
/// A newly inserted or hit item gets rank = MAX_RANK, granting it
/// MAX_RANK Pendulum sweeps of guaranteed survival.
const MAX_RANK: u8 = 3;

// ── Command ───────────────────────────────────────────────────────────────

pub enum Command<K, V> {
    /// Single insert from Worker (goes through probation gate).
    Insert(K, V, u64, bool),
    /// Batch of (K, V, hash) from sharded worker buffers.
    BatchInsert(Vec<(K, V, u64, bool)>),
    /// Insert directly as a top priority item bypassing probation, giving it max survival rank.
    InsertT1(K, V, u64),
    /// Remove by key+hash.
    Remove(K, u64),
    /// Blocking clear — caller spins on `OneshotAck::wait()`.
    Clear(Arc<OneshotAck>),
    /// Blocking maintenance flush — caller spins on `OneshotAck::wait()`.
    Sync(Arc<OneshotAck>),
    /// Signal Daemon to exit its run loop.
    Shutdown,
}

// ── Daemon ────────────────────────────────────────────────────────────────

pub struct Daemon<K, V, S> {
    pub hasher: S,
    pub arena: Arena,
    pub t1: Arc<T1<K, V>>,
    pub t2: Arc<T2<K, V>>,
    pub cache: Arc<Cache<K, V>>,
    pub cmd_rx: Arc<LossyQueue<Command<K, V>>>,
    pub hit_rx: Arc<LossyQueue<[usize; 64]>>,
    pub epoch: Arc<AtomicU32>,
    /// Configurable poll interval in microseconds (1 000–10 000 µs).
    /// Controls the trade-off between CPU idle cost and hit-signal latency.
    pub poll_us: u64,
    pub admission: Arc<AdmissionFilter>,
    /// Pre-allocated accumulator for deferred-sort hit processing.
    pub hit_accumulator: Vec<usize>,
    pub last_decay_epoch: u32,
    pub garbage_queue: Vec<(*mut Node<K, V>, usize)>,
    pub worker_states: ArcSlice<WorkerState>,
    /// Monotonically increasing tick counter — incremented on every poll loop.
    /// Workers read this (Relaxed) to decide whether to time-flush their TLS
    /// buffers without needing a hardware clock in no_std mode.
    pub daemon_tick: Arc<AtomicTick>,
    /// Cold-start flag shared with DualCacheFF
    pub is_cold_start: Arc<AtomicBool>,
    /// Configured TTL duration
    pub duration: u32,
}

unsafe impl<K: Send, V: Send, S: Send> Send for Daemon<K, V, S> {}

impl<K, V, S> Daemon<K, V, S>
where
    K: Hash + Eq + Send + Sync + Clone + 'static,
    V: Send + Sync + Clone + 'static,
    S: BuildHasher + Clone + Send + 'static,
{
    #[allow(clippy::too_many_arguments)]
    pub fn new(
        hasher: S,
        capacity: usize,
        t1: Arc<T1<K, V>>,
        t2: Arc<T2<K, V>>,
        cache: Arc<Cache<K, V>>,
        cmd_rx: Arc<LossyQueue<Command<K, V>>>,
        hit_rx: Arc<LossyQueue<[usize; 64]>>,
        epoch: Arc<AtomicU32>,
        duration: u32,
        poll_us: u64,
        worker_states: ArcSlice<WorkerState>,
        daemon_tick: Arc<AtomicTick>,
        is_cold_start: Arc<AtomicBool>,
    ) -> Self {
        Self {
            hasher,
            arena: Arena::new(capacity),
            t1,
            t2,
            cache,
            cmd_rx,
            hit_rx,
            epoch,
            poll_us,
            admission: Arc::new(AdmissionFilter::new(capacity)),
            hit_accumulator: Vec::with_capacity(8192),
            last_decay_epoch: 0,
            garbage_queue: Vec::new(),
            worker_states,
            daemon_tick,
            is_cold_start,
            duration,
        }
    }

    /// Main Daemon event loop.
    ///
    /// # std mode
    /// Called from a dedicated `std::thread::spawn` inside `DualCacheFF::new`.
    /// Sleeps `poll_us` microseconds when the command queue is empty.
    ///
    /// # no_std mode
    /// The caller (e.g. RTOS task) must invoke `daemon.run()` on a dedicated
    /// task. The loop uses `core::hint::spin_loop()` between iterations;
    /// the RTOS scheduler handles preemption and CPU sharing.
    pub fn run(mut self) {
        #[cfg(feature = "std")]
        let mut last_epoch_tick = std::time::Instant::now();

        loop {
            // ── Drain command queue (up to 8192 commands per poll) ────────
            let mut processed = 0u32;
            loop {
                match self.cmd_rx.try_recv() {
                    Some(Command::Shutdown) => return,
                    Some(cmd) => {
                        self.process_cmd(cmd);
                        processed += 1;
                        if processed >= 8192 {
                            break;
                        }
                    }
                    None => break,
                }
            }

            // ── Epoch tick ────────────────────────────────────────────────
            // In std mode: wall-clock driven, every ~100 ms.
            // In no_std mode: daemon_tick driven, every 100 poll iterations.
            #[cfg(feature = "std")]
            {
                let now = std::time::Instant::now();
                if now.duration_since(last_epoch_tick)
                    >= std::time::Duration::from_millis(100)
                {
                    self.epoch.fetch_add(1, Ordering::Relaxed);
                    last_epoch_tick = now;
                }
            }
            #[cfg(not(feature = "std"))]
            {
                let tick = self.daemon_tick.load(Ordering::Relaxed);
                if tick % 100 == 0 {
                    self.epoch.fetch_add(1, Ordering::Relaxed);
                }
            }

            // ── Maintenance (GC + hit processing + eviction) ──────────────
            self.maintenance();

            // ── Advance daemon_tick ───────────────────────────────────────
            #[cfg(any(feature = "loom", loom))]
            {
                if processed > 0 {
                    self.daemon_tick.fetch_add(1, Ordering::Relaxed);
                }
            }
            #[cfg(not(any(feature = "loom", loom)))]
            {
                self.daemon_tick.fetch_add(1, Ordering::Relaxed);
            }

            // ── Idle sleep / spin ─────────────────────────────────────────
            if processed == 0 {
                #[cfg(any(feature = "loom", loom))]
                loom::thread::yield_now();
                #[cfg(all(feature = "std", not(any(feature = "loom", loom))))]
                std::thread::sleep(std::time::Duration::from_micros(self.poll_us));
                #[cfg(not(feature = "std"))]
                core::hint::spin_loop();
            }
        }
    }

    #[inline(always)]
    fn process_cmd(&mut self, cmd: Command<K, V>) -> bool {
        match cmd {
            Command::Insert(k, v, hash, is_t1) => {
                self.handle_admission_insert(k, v, hash, is_t1);
                true
            }
            Command::BatchInsert(batch) => {
                for (k, v, hash, is_t1) in batch {
                    self.handle_admission_insert(k, v, hash, is_t1);
                }
                true
            }
            Command::InsertT1(k, v, hash) => {
                self.handle_insert_t1(k, v, hash);
                true
            }
            Command::Remove(k, hash) => {
                self.handle_remove(k, hash);
                true
            }
            Command::Clear(ack) => {
                self.handle_clear();
                ack.signal();
                true
            }
            Command::Sync(ack) => {
                self.maintenance();
                ack.signal();
                true
            }
            Command::Shutdown => unreachable!("handled in run()"),
        }
    }

    /// Binary Valve Admission:
    /// 1. Cold Start Mode (free slots > 5%): accept all.
    /// 2. Steady State Mode: only accept if Ghost Set recognises the item.
    fn handle_admission_insert(&mut self, k: K, v: V, hash: u64, is_t1: bool) {
        if is_t1 {
            self.handle_insert_t1(k, v, hash);
            return;
        }
        let cold_start = self.arena.free_list_len() > self.arena.capacity / 20;
        self.is_cold_start.store(cold_start, Ordering::Relaxed);
        if cold_start || self.admission.check_ghost(hash) {
            self.handle_insert_with_hash(k, v, hash);
        }
    }

    fn handle_insert_with_hash(&mut self, k: K, v: V, hash: u64) {
        let tag = (hash >> 48) as u16;

        // 1. Check if it's an update of an existing entry
        let global_idx = if let Some(existing_idx) = self.cache.index_probe(hash, tag) {
            existing_idx
        } else {
            // 2. New insert: need a free slot
            if self.arena.free_list_empty() {
                self.evict_batch();
            }
            if let Some(new_idx) = self.arena.pop_free_slot() {
                new_idx
            } else {
                return; // Still no slots after eviction — drop
            }
        };

        let entry = (tag as u64) << 48 | (global_idx as u64 & 0x0000_FFFF_FFFF_FFFF);

        let node_ptr = Box::into_raw(Box::new(Node {
            key: k,
            value: v,
            expire_at: self.epoch.load(Ordering::Relaxed) + self.get_duration(),
            g_idx: global_idx as u32,
        }));

        let old_ptr = self.cache.nodes[global_idx].swap(node_ptr, Ordering::Release);
        if !old_ptr.is_null() {
            let epoch = GLOBAL_EPOCH.load(Ordering::Relaxed);
            self.garbage_queue.push((old_ptr, epoch));
        }

        self.cache.index_store(hash, tag, entry);
        self.arena.set_hash(global_idx, hash);
        // Revolution Shield: new items start with MAX_RANK protection
        self.arena.set_rank(global_idx, MAX_RANK);
    }

    fn handle_insert_t1(&mut self, k: K, v: V, hash: u64) {
        let tag = (hash >> 48) as u16;

        let global_idx = if let Some(existing_idx) = self.cache.index_probe(hash, tag) {
            existing_idx
        } else {
            if self.arena.free_list_empty() {
                self.evict_batch();
            }
            if let Some(new_idx) = self.arena.pop_free_slot() {
                new_idx
            } else {
                return;
            }
        };

        let entry = (tag as u64) << 48 | (global_idx as u64 & 0x0000_FFFF_FFFF_FFFF);

        let node_ptr = Box::into_raw(Box::new(Node {
            key: k,
            value: v,
            expire_at: self.epoch.load(Ordering::Relaxed) + self.get_duration(),
            g_idx: global_idx as u32,
        }));

        let old_ptr = self.cache.nodes[global_idx].swap(node_ptr, Ordering::Release);
        if !old_ptr.is_null() {
            let epoch = GLOBAL_EPOCH.load(Ordering::Relaxed);
            self.garbage_queue.push((old_ptr, epoch));
        }

        self.cache.index_store(hash, tag, entry);
        self.arena.set_hash(global_idx, hash);
        self.arena.set_rank(global_idx, 255); // high initial rank (God mode)

        // Promotion: hot items migrate to T1 immediately
        self.t1.store_slot(hash, node_ptr);
    }

    fn get_duration(&self) -> u32 {
        self.duration
    }

    fn handle_remove(&mut self, _k: K, hash: u64) {
        let tag = (hash >> 48) as u16;
        if let Some(g_idx) = self.cache.index_probe(hash, tag) {
            let old_ptr =
                self.cache.nodes[g_idx].swap(core::ptr::null_mut(), Ordering::Release);
            if !old_ptr.is_null() {
                let epoch = GLOBAL_EPOCH.load(Ordering::Relaxed);
                self.garbage_queue.push((old_ptr, epoch));
                self.t1.clear_if_matches(hash, old_ptr);
                self.t2.clear_if_matches(hash, old_ptr);
            }
            self.cache.index_remove(hash, tag, g_idx);
            self.arena.set_rank(g_idx, 0); // Fast eviction next cycle
        }
    }

    fn handle_clear(&mut self) {
        self.cache.clear();
        for i in 0..self.t1.len() {
            self.t1.clear_at(i);
        }
        for i in 0..self.t2.len() {
            self.t2.clear_at(i);
        }
        self.admission.clear();
        self.arena.clear();
        self.is_cold_start.store(true, Ordering::Relaxed);
    }

    fn maintenance(&mut self) {
        // ── Phase 0: QSBR Garbage Collection ─────────────────────────────
        if !self.garbage_queue.is_empty() {
            let current_global = GLOBAL_EPOCH.load(Ordering::Relaxed);
            GLOBAL_EPOCH.store(current_global + 1, Ordering::Release);

            let mut min_active_epoch = current_global + 1;
            for state in self.worker_states.iter() {
                let local = state.local_epoch.load(Ordering::Acquire);
                if local != 0 && local < min_active_epoch {
                    min_active_epoch = local;
                }
            }

            self.garbage_queue.retain(|&(ptr, epoch)| {
                if epoch < min_active_epoch {
                    unsafe { drop(Box::from_raw(ptr)) };
                    false
                } else {
                    true
                }
            });
        }

        // ── Phase 1: Collect hit indices into accumulator ─────────────────
        while let Some(batch) = self.hit_rx.try_recv() {
            for &g_idx in batch.iter() {
                if g_idx < self.arena.capacity && g_idx != usize::MAX {
                    self.hit_accumulator.push(g_idx);
                }
            }
            if self.hit_accumulator.len() >= 8192 {
                break;
            }
        }

        // ── Phase 2: Sort + Revolution Shield hit processing ──────────────
        if !self.hit_accumulator.is_empty() {
            self.hit_accumulator.sort_unstable();

            for &g_idx in &self.hit_accumulator {
                // Revolution Shield: refill to MAX_RANK on every hit
                self.arena.set_rank(g_idx, MAX_RANK);

                let hash = self.arena.get_hash(g_idx);

                // Promotion: hot items migrate to T1
                let ptr = self.cache.nodes[g_idx].load(Ordering::Acquire);
                if !ptr.is_null() && self.t1.load_slot(hash) != ptr {
                    self.t1.store_slot(hash, ptr);
                }
            }

            self.hit_accumulator.clear();
        }

        if self.arena.free_list_len() < self.arena.capacity / 10 {
            self.evict_batch();
        }

        let cold_start = self.arena.free_list_len() > self.arena.capacity / 20;
        if self.is_cold_start.load(Ordering::Relaxed) != cold_start {
            self.is_cold_start.store(cold_start, Ordering::Relaxed);
        }
    }

    /// Avg-rank eviction: scan the Pendulum cursor, compare each slot's rank
    /// with the running average. Guaranteed O(1) amortised candidate search.
    fn evict_batch(&mut self) {
        let count = 128;
        let avg = (self.arena.count_sum() / self.arena.capacity as u64) as u8;
        let threshold = avg.max(1);

        for _ in 0..count {
            if self.arena.free_list_len() > self.arena.capacity / 10 {
                break;
            }

            let idx = self.arena.cursor();
            let r = self.arena.get_rank(idx);

            if r <= threshold {
                // Evict
                let hash = self.arena.get_hash(idx);
                let tag = (hash >> 48) as u16;

                let old_ptr =
                    self.cache.nodes[idx].swap(core::ptr::null_mut(), Ordering::Release);
                if !old_ptr.is_null() {
                    let epoch = GLOBAL_EPOCH.load(Ordering::Relaxed);
                    self.garbage_queue.push((old_ptr, epoch));
                    self.t1.clear_if_matches(hash, old_ptr);
                    self.t2.clear_if_matches(hash, old_ptr);
                }

                self.cache.index_remove(hash, tag, idx);

                // Task 5 — Ghost Set dynamically scaled to capacity:
                // record_death writes to ghost_set[hash & ghost_mask],
                // where ghost_mask = capacity - 1 (already aligned).
                self.admission.record_death(hash);
                self.arena.push_free_slot(idx);
                self.arena.set_rank(idx, 0);
            } else {
                // Decay — decrement rank by 1
                self.arena.decrement_rank(idx);
            }
            self.arena.advance_cursor();
        }
    }
}

impl<K, V, S> Drop for Daemon<K, V, S> {
    fn drop(&mut self) {
        for &(ptr, _) in self.garbage_queue.iter() {
            if !ptr.is_null() {
                unsafe {
                    let _ = Box::from_raw(ptr);
                }
            }
        }
    }
}

// ── AdmissionFilter (Ghost Set) ───────────────────────────────────────────

/// Ghost Set — direct-mapped fingerprint array.
///
/// Records the 16-bit fingerprint of evicted items so that previously-hot
/// items bypass TLS probation on re-insertion.
///
/// # Task 5 — Capacity Align
/// Ghost Set size is always equal to the Arena's `capacity` (already a power
/// of two). When the user sets a small capacity (e.g. 2000 items rounded to
/// 2048), the Ghost Set is also 2048 × 2 bytes = 4 KB — not the previous
/// bloated `capacity.next_power_of_two()` of a larger default.
pub struct AdmissionFilter {
    pub ghost_mask: usize,
    pub ghost_set: ArcSlice<AtomicU16>,
}

impl AdmissionFilter {
    /// `capacity` must be a power of two (enforced by `Config`).
    /// Ghost Set is exactly `capacity` entries (2 bytes each).
    pub fn new(capacity: usize) -> Self {
        // Capacity is already power-of-two — no extra `.next_power_of_two()`.
        // Minimum 256 entries to keep the false-positive rate reasonable.
        let ghost_size = capacity.max(256);

        let mut ghost_vec = Vec::with_capacity(ghost_size);
        for _ in 0..ghost_size {
            ghost_vec.push(AtomicU16::new(0));
        }

        Self {
            ghost_mask: ghost_size - 1,
            ghost_set: new_arc_slice(ghost_vec),
        }
    }

    /// Called by Daemon on eviction: record this item's 16-bit fingerprint.
    #[inline(always)]
    pub fn record_death(&self, hash: u64) {
        let fp = (hash >> 48) as u16;
        let idx = (hash as usize) & self.ghost_mask;
        self.ghost_set[idx].store(fp, Ordering::Relaxed);
    }

    /// Called by Worker on insert: `true` if the fingerprint matches a
    /// previously evicted item → bypass TLS probation.
    #[inline(always)]
    pub fn check_ghost(&self, hash: u64) -> bool {
        let fp = (hash >> 48) as u16;
        let ghost_idx = (hash as usize) & self.ghost_mask;
        self.ghost_set[ghost_idx].load(Ordering::Relaxed) == fp
    }

    pub fn clear(&self) {
        for val in self.ghost_set.iter() {
            val.store(0, Ordering::Relaxed);
        }
    }
}
