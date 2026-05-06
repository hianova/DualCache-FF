use crate::daemon::{Command, Daemon};
use crate::unsafe_core::{L3, Node, T1, T2};
use ahash::RandomState;
use crossbeam_channel::Sender;
use std::cell::RefCell;
use std::hash::{BuildHasher, Hash, Hasher};
use std::sync::Arc;
use std::sync::atomic::{AtomicU32, AtomicU16, Ordering};

pub mod daemon;
pub mod unsafe_core;

pub struct Config {
    pub capacity: usize,
    pub t1_slots: usize,
    pub t2_capacity: usize,
    pub duration: u32,
}

impl Config {
    pub fn adaptive_config<K, V>() -> Self {
        let node_size = std::mem::size_of::<Node<K, V>>();
        assert!(node_size > 0);

        let t1_slots = 2048;
        let total_budget = 512 * 1024 * 1024;
        let capacity = (total_budget / node_size).next_power_of_two();
        let t2_capacity = (capacity / 5).max(4096).next_power_of_two();

        Config {
            capacity,
            t1_slots,
            t2_capacity,
            duration: 60,
        }
    }
}

pub struct DualCacheFF<K, V, S = RandomState> {
    pub hasher: S,
    pub t1: Arc<T1>,
    pub t2: Arc<T2>,
    pub l3: Arc<L3<K, V>>,
    pub cmd_tx: Sender<Command<K, V>>,
    pub hit_tx: Sender<[usize; 64]>,
    pub epoch: Arc<AtomicU32>,
    pub ghost_set: Arc<[AtomicU16]>,
    pub ghost_mask: usize,
}

impl<K, V, S: Clone> Clone for DualCacheFF<K, V, S> {
    fn clone(&self) -> Self {
        Self {
            hasher: self.hasher.clone(),
            t1: self.t1.clone(),
            t2: self.t2.clone(),
            l3: self.l3.clone(),
            cmd_tx: self.cmd_tx.clone(),
            hit_tx: self.hit_tx.clone(),
            epoch: self.epoch.clone(),
            ghost_set: self.ghost_set.clone(),
            ghost_mask: self.ghost_mask,
        }
    }
}

thread_local! {
    static HIT_BUF: RefCell<([usize; 64], usize)> = RefCell::new(([0; 64], 0));
}

impl<K, V> DualCacheFF<K, V, RandomState>
where
    K: Hash + Eq + Send + Sync + Clone + 'static,
    V: Send + Sync + Clone + 'static,
{
    pub fn new(config: Config) -> Self {
        let hasher = RandomState::new();
        let t1 = Arc::new(T1::new(config.t1_slots));
        let t2 = Arc::new(T2::new(config.t2_capacity));
        let l3 = Arc::new(L3::new(config.capacity));
        let (cmd_tx, cmd_rx) = crossbeam_channel::bounded(1024);
        let (hit_tx, hit_rx) = crossbeam_channel::bounded(1024);
        let epoch = Arc::new(AtomicU32::new(0));

        let ghost_size = (config.capacity * 2).next_power_of_two();
        let mut ghost_vec = Vec::with_capacity(ghost_size);
        for _ in 0..ghost_size {
            ghost_vec.push(AtomicU16::new(0));
        }
        let ghost_set: Arc<[AtomicU16]> = ghost_vec.into_boxed_slice().into();
        let ghost_mask = ghost_size - 1;

        let daemon = Daemon::new(
            hasher.clone(),
            config.capacity,
            t1.clone(),
            t2.clone(),
            l3.clone(),
            cmd_rx,
            hit_rx,
            epoch.clone(),
            config.duration,
            ghost_set.clone(),
            ghost_mask,
        );

        std::thread::spawn(move || {
            daemon.run();
        });

        Self {
            hasher,
            t1,
            t2,
            l3,
            cmd_tx,
            hit_tx,
            epoch,
            ghost_set,
            ghost_mask,
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
        let (tx, rx) = crossbeam_channel::bounded(1);
        if self.cmd_tx.try_send(Command::Sync(tx)).is_ok() {
            let _ = rx.recv();
        }
    }

    pub fn get(&self, key: &K) -> Option<V> {
        let hash = self.hash(key);
        let current_epoch = self.epoch.load(Ordering::Relaxed);

        // T1 check
        let t1_idx = hash as usize & self.t1.mask;
        let g_idx_t1 = self.t1.slots[t1_idx].load(Ordering::Acquire);
        if g_idx_t1 != usize::MAX {
            if let Some(node) = &*self.l3.nodes[g_idx_t1].read() {
                if &node.key == key {
                    if node.expire_at > 0 && node.expire_at < current_epoch {
                        return None;
                    }
                    self.record_hit(g_idx_t1);
                    return Some(node.value.clone());
                }
            }
        }

        // T2 check
        let t2_idx = hash as usize & self.t2.mask;
        let g_idx_t2 = self.t2.slots[t2_idx].load(Ordering::Acquire);
        if g_idx_t2 != usize::MAX {
            if let Some(node) = &*self.l3.nodes[g_idx_t2].read() {
                if &node.key == key {
                    if node.expire_at > 0 && node.expire_at < current_epoch {
                        return None;
                    }
                    self.record_hit(g_idx_t2);
                    return Some(node.value.clone());
                }
            }
        }

        // L3 check
        let tag = (hash >> 48) as u16;
        let mut idx = hash as usize & self.l3.index_mask;
        for _ in 0..16 {
            let entry = self.l3.index[idx].load(Ordering::Acquire);
            if entry == 0 {
                break;
            }

            let entry_tag = (entry >> 48) as u16;
            if entry_tag == tag {
                let global_idx = (entry & 0x0000_FFFF_FFFF_FFFF) as usize;

                if let Some(node) = &*self.l3.nodes[global_idx].read() {
                    if &node.key == key {
                        if node.expire_at > 0 && node.expire_at < current_epoch {
                            return None;
                        }
                        self.record_hit(global_idx);
                        return Some(node.value.clone());
                    }
                }
            }
            idx = (idx + 1) & self.l3.index_mask;
        }

        None
    }

    pub fn insert(&self, key: K, value: V) {
        let hash = self.hash(&key);
        let ghost_idx = (hash as usize) & self.ghost_mask;
        let fp = (hash >> 48) as u16;

        let prev = self.ghost_set[ghost_idx].load(Ordering::Relaxed);
        if prev != fp {
            self.ghost_set[ghost_idx].store(fp, Ordering::Relaxed);
            return;
        }

        let _ = self.cmd_tx.try_send(Command::Insert(key, value));
    }

    pub fn remove(&self, key: &K) {
        let _ = self.cmd_tx.try_send(Command::Remove(key.clone()));
    }

    pub fn clear(&self) {
        let (tx, rx) = crossbeam_channel::bounded(1);
        if self.cmd_tx.send(Command::Clear(tx)).is_ok() {
            let _ = rx.recv();
        }
    }

    fn hash(&self, key: &K) -> u64 {
        let mut s = self.hasher.build_hasher();
        key.hash(&mut s);
        s.finish()
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
