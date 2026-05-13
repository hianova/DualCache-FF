use std::sync::Arc;
use std::sync::atomic::{AtomicU16, AtomicU32, Ordering};
use crossbeam_channel::{Receiver, Sender};
use crate::unsafe_core::{T1, T2, Cache, Node, Arena};
use crate::{WorkerState, GLOBAL_EPOCH};
use std::hash::{Hash, BuildHasher};

/// Maximum rank (shield value). An item hit gets rank = MAX_RANK,
/// granting it MAX_RANK sweeps of guaranteed survival.
const MAX_RANK: u8 = 3;

pub enum Command<K, V> {
    /// Insert request from Worker. Daemon applies global Probation gate before Cache write.
    Insert(K, V, u64),
    /// Batch of (K,V) pairs from sharded buffer. Each item goes through probation.
    BatchInsert(Vec<(K, V, u64)>),
    Remove(K, u64),
    Clear(Sender<()>),
    Sync(Sender<()>),
}



pub struct Daemon<K, V, S> {
    pub hasher: S,
    pub arena: Arena,
    pub t1: Arc<T1<K, V>>,
    pub t2: Arc<T2<K, V>>,
    pub cache: Arc<Cache<K, V>>,
    pub cmd_rx: Receiver<Command<K, V>>,
    pub hit_rx: Receiver<[usize; 64]>,
    pub epoch: Arc<AtomicU32>,
    pub duration: u32,
    pub admission: Arc<AdmissionFilter>,
    // Pre-allocated accumulator for deferred-sort hit processing
    pub hit_accumulator: Vec<usize>,
    pub last_decay_epoch: u32,
    pub garbage_queue: Vec<(*mut Node<K, V>, usize)>,
    pub worker_states: Arc<[WorkerState]>,
}

unsafe impl<K: Send, V: Send, S: Send> Send for Daemon<K, V, S> {}

impl<K, V, S> Daemon<K, V, S>
where K: Hash + Eq + Send + Sync + Clone + 'static,
      V: Send + Sync + Clone + 'static,
      S: BuildHasher + Clone + Send + 'static
{
    #[allow(clippy::too_many_arguments)]
    pub fn new(
        hasher: S,
        capacity: usize,
        t1: Arc<T1<K, V>>,
        t2: Arc<T2<K, V>>,
        cache: Arc<Cache<K, V>>,
        cmd_rx: Receiver<Command<K, V>>,
        hit_rx: Receiver<[usize; 64]>,
        epoch: Arc<AtomicU32>,
        duration: u32,
        worker_states: Arc<[WorkerState]>,
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
            duration,
            admission: Arc::new(AdmissionFilter::new(capacity)),
            hit_accumulator: Vec::with_capacity(8192),
            last_decay_epoch: 0,
            garbage_queue: Vec::new(),
            worker_states,
        }
    }

    pub fn run(mut self) {
        let mut last_tick = std::time::Instant::now();
        loop {
            let mut processed = 0;

            match self.cmd_rx.recv_timeout(std::time::Duration::from_millis(5)) {
                Ok(cmd) => {
                    self.process_cmd(cmd);
                    processed += 1;

                    while processed < 8192 {
                        match self.cmd_rx.try_recv() {
                            Ok(cmd) => {
                                self.process_cmd(cmd);
                                processed += 1;
                            }
                            Err(_) => break,
                        }
                    }
                }
                Err(crossbeam_channel::RecvTimeoutError::Timeout) => {}
                Err(crossbeam_channel::RecvTimeoutError::Disconnected) => break,
            }

            if last_tick.elapsed() >= std::time::Duration::from_millis(100) {
                self.epoch.fetch_add(1, Ordering::Relaxed);
                last_tick = std::time::Instant::now();
            }

            self.maintenance();
        }
    }

    #[inline(always)]
    fn process_cmd(&mut self, cmd: Command<K, V>) {
        match cmd {
            Command::Insert(k, v, hash) => self.handle_admission_insert(k, v, hash),
            Command::BatchInsert(batch) => {
                for (k, v, hash) in batch {
                    self.handle_admission_insert(k, v, hash);
                }
            }
            Command::Remove(k, hash) => self.handle_remove(k, hash),
            Command::Clear(tx) => {
                self.handle_clear();
                let _ = tx.send(());
            }
            Command::Sync(tx) => {
                self.maintenance();
                let _ = tx.send(());
            }
        }
    }

    /// Binary Valve Admission: 
    /// 1. Cold Start Mode (free slots > 5%): accept all.
    /// 2. Steady State Mode: only accept if in Ghost Set.
    fn handle_admission_insert(&mut self, k: K, v: V, hash: u64) {
        let cold_start = self.arena.free_list_len() > self.arena.capacity / 20;
        if cold_start || self.admission.check_ghost(hash) {
            self.handle_insert_with_hash(k, v, hash);
        }
    }

    fn handle_insert_with_hash(&mut self, k: K, v: V, hash: u64) {
        let tag = (hash >> 48) as u16;
        
        // 1. Check if it's an update
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
                return; // Still no slots
            }
        };

        let entry = (tag as u64) << 48 | (global_idx as u64 & 0x0000_FFFF_FFFF_FFFF);
        
        let node_ptr = Box::into_raw(Box::new(Node {
            key: k,
            value: v,
            expire_at: self.epoch.load(Ordering::Relaxed) + self.duration,
            g_idx: global_idx as u32,
        }));

        let old_ptr = self.cache.nodes[global_idx].swap(node_ptr, Ordering::Release);
        if !old_ptr.is_null() {
            let epoch = GLOBAL_EPOCH.load(Ordering::Relaxed);
            self.garbage_queue.push((old_ptr, epoch));
        }

        // Linear probing for Cache index (will overwrite if same tag/idx exists)
        self.cache.index_store(hash, tag, entry);
        
        self.arena.set_hash(global_idx, hash);
        // Revolution Shield: new items get MAX_RANK shield
        self.arena.set_rank(global_idx, MAX_RANK);
    }

    fn handle_remove(&mut self, _k: K, hash: u64) {
        let tag = (hash >> 48) as u16;
        if let Some(g_idx) = self.cache.index_probe(hash, tag) {
            let old_ptr = self.cache.nodes[g_idx].swap(std::ptr::null_mut(), Ordering::Release);
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
    }

    fn maintenance(&mut self) {
        // --- Phase 0: QSBR Garbage Collection ---
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
                unsafe { drop(Box::from_raw(ptr)); }
                false
            } else {
                true
            }
        });

        // --- Phase 1: Collect hit indices into accumulator ---
        while let Ok(batch) = self.hit_rx.try_recv() {
            for &g_idx in batch.iter() {
                if g_idx < self.arena.capacity {
                    self.hit_accumulator.push(g_idx);
                }
            }
            if self.hit_accumulator.len() >= 8192 {
                break;
            }
        }

        // --- Phase 2: Sort + Revolution Shield hit processing ---
        if !self.hit_accumulator.is_empty() {
            self.hit_accumulator.sort_unstable();

            for &g_idx in &self.hit_accumulator {
                // Revolution Shield: refill to MAX_RANK on every hit
                self.arena.set_rank(g_idx, MAX_RANK);

                let hash = self.arena.get_hash(g_idx);

                // Promotion: items go to T1. Since we hit, node is in Cache.
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
    }

    /// Avg-based eviction: scan cursor, compare rank with avg.
    /// Guaranteed O(1) find candidates.
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
                
                let old_ptr = self.cache.nodes[idx].swap(std::ptr::null_mut(), Ordering::Release);
                if !old_ptr.is_null() {
                    let epoch = crate::GLOBAL_EPOCH.load(Ordering::Relaxed);
                    self.garbage_queue.push((old_ptr, epoch));
                    self.t1.clear_if_matches(hash, old_ptr);
                    self.t2.clear_if_matches(hash, old_ptr);
                }

                self.cache.index_remove(hash, tag, idx);

                self.admission.record_death(hash);
                self.arena.push_free_slot(idx);
                self.arena.set_rank(idx, 0); // Correctly update count_sum
            } else {
                // Decay
                self.arena.decrement_rank(idx);
            }
            self.arena.advance_cursor();
        }
    }
}

/// Ghost Set: direct-mapped fingerprint array.
/// Records the 16-bit fingerprint of evicted items so that
/// previously-hot items can be resurrected immediately on re-insert,
/// bypassing TLS probation.
pub struct AdmissionFilter {
    pub ghost_mask: usize,
    pub ghost_set: Arc<[AtomicU16]>,
}

impl AdmissionFilter {
    pub fn new(capacity: usize) -> Self {
        let ghost_size = capacity.next_power_of_two();

        let mut ghost_vec = Vec::with_capacity(ghost_size);
        for _ in 0..ghost_size {
            ghost_vec.push(AtomicU16::new(0));
        }

        Self {
            ghost_mask: ghost_size - 1,
            ghost_set: ghost_vec.into_boxed_slice().into(),
        }
    }

    /// Called by Daemon on eviction: record this item's fingerprint.
    #[inline(always)]
    pub fn record_death(&self, hash: u64) {
        let fp = (hash >> 48) as u16;
        let idx = (hash as usize) & self.ghost_mask;
        self.ghost_set[idx].store(fp, Ordering::Relaxed);
    }

    /// Called by Frontend Worker on insert: true if this item was previously evicted.
    /// Fast-path: skips TLS probation and sends directly to Daemon.
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
