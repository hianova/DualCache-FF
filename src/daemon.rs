use std::sync::Arc;
use std::sync::atomic::{AtomicU32, Ordering};
use crossbeam_channel::{Receiver, Sender};
use crossbeam_epoch::{Owned, Shared};
use crate::unsafe_core::{T1, T2, L3, Node};
use std::hash::{Hash, Hasher, BuildHasher};

pub enum Command<K, V> {
    Insert(K, V),
    Remove(K),
    Clear(Sender<()>),
    Sync(Sender<()>),
}

pub struct Arena {
    pub capacity: usize,
    pub count_sum: u64,
    pub cursor: usize,
    pub rank: Vec<u8>,
    pub hashes: Vec<u64>,
    pub free_list: Vec<usize>,
}

impl Arena {
    pub fn new(capacity: usize) -> Self {
        Self {
            capacity,
            count_sum: 0,
            cursor: 0,
            rank: vec![0; capacity],
            hashes: vec![0; capacity],
            free_list: (0..capacity).collect(),
        }
    }
}

pub struct Daemon<K, V, S> {
    pub hasher: S,
    pub arena: Arena,
    pub t1: Arc<T1<K, V>>,
    pub t2: Arc<T2<K, V>>,
    pub l3: Arc<L3<K, V>>,
    pub cmd_rx: Receiver<Command<K, V>>,
    pub hit_rx: Receiver<usize>,
    pub epoch: Arc<AtomicU32>,
    pub duration: u32,
}

impl<K, V, S> Daemon<K, V, S>
where K: Hash + Eq + Send + Sync + Clone + 'static,
      V: Send + Sync + Clone + 'static,
      S: BuildHasher + Clone + Send + 'static
{
    pub fn new(
        hasher: S,
        capacity: usize,
        t1: Arc<T1<K, V>>,
        t2: Arc<T2<K, V>>,
        l3: Arc<L3<K, V>>,
        cmd_rx: Receiver<Command<K, V>>,
        hit_rx: Receiver<usize>,
        epoch: Arc<AtomicU32>,
        duration: u32,
    ) -> Self {
        Self {
            hasher,
            arena: Arena::new(capacity),
            t1,
            t2,
            l3,
            cmd_rx,
            hit_rx,
            epoch,
            duration,
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

            if last_tick.elapsed() >= std::time::Duration::from_secs(1) {
                self.epoch.fetch_add(1, Ordering::Relaxed);
                last_tick = std::time::Instant::now();
            }

            self.maintenance();
        }
    }

    #[inline(always)]
    fn process_cmd(&mut self, cmd: Command<K, V>) {
        match cmd {
            Command::Insert(k, v) => self.handle_insert(k, v),
            Command::Remove(k) => self.handle_remove(k),
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

    fn handle_insert(&mut self, k: K, v: V) {
        let hash = self.hash(&k);

        if self.arena.free_list.is_empty() {
            self.evict_batch();
        }

        if let Some(global_idx) = self.arena.free_list.pop() {
            let new_node = Owned::new(Node {
                key: k.clone(),
                value: v,
                expire_at: self.epoch.load(Ordering::Relaxed) + self.duration,
            });

            // L3 indexing
            let tag = (hash >> 48) as u16;
            let entry = (tag as u64) << 48 | (global_idx as u64 & 0x0000_FFFF_FFFF_FFFF);
            let mut idx = hash as usize & self.l3.index_mask;
            
            // Store physical node
            let guard = crossbeam_epoch::pin();
            let old_ptr = self.l3.nodes[global_idx].swap(new_node, Ordering::Release, &guard);
            if !old_ptr.is_null() {
                unsafe { guard.defer_destroy(old_ptr); }
            }

            // Linear probing for L3 index
            for i in 0..16 {
                let prev = self.l3.index[idx].load(Ordering::Acquire);
                if prev == 0 || (prev >> 48) == (tag as u64) {
                     self.l3.index[idx].store(entry, Ordering::Release);
                     break;
                }
                if i == 15 {
                     self.l3.index[hash as usize & self.l3.index_mask].store(entry, Ordering::Release);
                }
                idx = (idx + 1) & self.l3.index_mask;
            }
            
            self.arena.hashes[global_idx] = hash;
            self.arena.rank[global_idx] = 10;
            self.arena.count_sum += 10;
        }
    }

    fn handle_remove(&mut self, k: K) {
        let hash = self.hash(&k);
        let tag = (hash >> 48) as u16;
        let mut idx = hash as usize & self.l3.index_mask;
        for _ in 0..16 {
            let entry = self.l3.index[idx].load(Ordering::Acquire);
            if entry == 0 { break; }
            if (entry >> 48) as u16 == tag {
                self.l3.index[idx].store(0, Ordering::Release);
            }
            idx = (idx + 1) & self.l3.index_mask;
        }
    }

    fn handle_clear(&mut self) {
        let guard = crossbeam_epoch::pin();
        for i in 0..self.l3.index.len() {
            self.l3.index[i].store(0, Ordering::Relaxed);
        }
        for i in 0..self.l3.nodes.len() {
            let ptr = self.l3.nodes[i].swap(Shared::null(), Ordering::Relaxed, &guard);
            if !ptr.is_null() {
                unsafe { guard.defer_destroy(ptr); }
            }
        }
        self.arena.free_list = (0..self.arena.capacity).collect();
        self.arena.rank.fill(0);
        self.arena.count_sum = 0;
    }

    fn maintenance(&mut self) {
        // Collect hits
        let mut hits = Vec::new();
        while let Ok(g_idx) = self.hit_rx.try_recv() {
            hits.push(g_idx);
        }
        
        let avg = if self.arena.capacity > 0 { self.arena.count_sum / self.arena.capacity as u64 } else { 0 };
        let guard = crossbeam_epoch::pin();

        for g_idx in hits {
            if g_idx < self.arena.capacity {
                let add_val = (avg * 2).max(1) as u8;
                let old_rank = self.arena.rank[g_idx];
                self.arena.rank[g_idx] = old_rank.saturating_add(add_val);
                self.arena.count_sum += (self.arena.rank[g_idx] - old_rank) as u64;

                let r = self.arena.rank[g_idx];
                let hash = self.arena.hashes[g_idx];
                
                // Promotion
                if r > 50 { // T1_THRESHOLD
                    let ptr = self.l3.nodes[g_idx].load(Ordering::Relaxed, &guard);
                    if !ptr.is_null() {
                        self.t1.slots[hash as usize & self.t1.mask].store(ptr, Ordering::Release);
                    }
                } else if r > 20 { // T2_THRESHOLD
                    let ptr = self.l3.nodes[g_idx].load(Ordering::Relaxed, &guard);
                    if !ptr.is_null() {
                        self.t2.slots[hash as usize & self.t2.mask].store(ptr, Ordering::Release);
                    }
                }
            }
        }
        
        if self.arena.free_list.len() < self.arena.capacity / 10 {
            self.evict_batch();
        }
    }

    fn evict_batch(&mut self) {
        let avg = if self.arena.capacity > 0 { self.arena.count_sum / self.arena.capacity as u64 } else { 0 };
        let count = 128; // Max iterations
        let guard = crossbeam_epoch::pin();

        for _ in 0..count {
            if self.arena.free_list.len() > self.arena.capacity / 10 {
                break;
            }

            let idx = self.arena.cursor;
            let r = self.arena.rank[idx];
            
            if r <= (avg as u8).max(1) {
                self.arena.rank[idx] = 0;
                self.arena.count_sum = self.arena.count_sum.saturating_sub(r as u64);
                
                // L3 index O(1) clear
                let hash = self.arena.hashes[idx];
                let tag = (hash >> 48) as u16;
                let mut scan_idx = hash as usize & self.l3.index_mask;
                for _ in 0..16 {
                    let entry = self.l3.index[scan_idx].load(Ordering::Acquire);
                    if entry == 0 { break; }
                    if (entry >> 48) as u16 == tag && (entry & 0x0000_FFFF_FFFF_FFFF) == (idx as u64) {
                        self.l3.index[scan_idx].store(0, Ordering::Release);
                        break;
                    }
                    scan_idx = (scan_idx + 1) & self.l3.index_mask;
                }

                let old_ptr = self.l3.nodes[idx].swap(Shared::null(), Ordering::Release, &guard);
                if !old_ptr.is_null() {
                    unsafe { guard.defer_destroy(old_ptr); }
                }

                self.arena.free_list.push(idx);
            } else {
                let sub = (avg as u8).max(1);
                self.arena.rank[idx] -= sub;
                self.arena.count_sum = self.arena.count_sum.saturating_sub(sub as u64);
            }
            self.arena.cursor = (self.arena.cursor + 1) % self.arena.capacity;
        }
    }

    fn hash(&self, key: &K) -> u64 {
        let mut s = self.hasher.build_hasher();
        key.hash(&mut s);
        s.finish()
    }
}
