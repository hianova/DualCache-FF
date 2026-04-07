use ahash::{AHashMap, RandomState};
use arc_swap::ArcSwap;
use crossbeam::channel::{Receiver, Sender};
use std::hash::{BuildHasher, Hash};
use std::sync::atomic::{AtomicU32, Ordering};
use std::sync::{Arc, Mutex};
use std::time::{SystemTime, UNIX_EPOCH};

const SHARD_SIZE: usize = 64;
const PAGE_SIZE: usize = 64;
const SHIFT: usize = 6;
const MASK: usize = 63;

#[derive(Clone)]
pub struct DualCacheFF<K, V> {
    hot_cache: Arc<ArcSwap<AHashMap<K, V>>>,
    cold_cache: Arc<ArcSwap<Cache<K, V>>>,
    action_tx: Sender<Action<K, V>>,
    epoch: Arc<AtomicU32>,
    duration: u32,
    get_buffer: Arc<Mutex<Vec<usize>>>,
}

impl<K: Hash + Eq + Clone + Send + Sync + 'static, V: Clone + Send + Sync + 'static>
    DualCacheFF<K, V>
{
    pub fn new(config: Config) -> Self {
        let capacity = (config.capacity + PAGE_SIZE - 1) & !(PAGE_SIZE - 1);
        let hot_cap = capacity / 10;

        let hot_map = AHashMap::with_capacity_and_hasher(hot_cap, RandomState::new());
        let hot_cache = Arc::new(ArcSwap::from_pointee(hot_map));

        let cold_cache = Arc::new(ArcSwap::from_pointee(Cache::new(capacity)));

        let (action_tx, action_rx) = crossbeam::channel::bounded(1024);
        let buffer_cap = std::cmp::max(1, capacity / 10);
        let epoch = Arc::new(AtomicU32::new(
            SystemTime::now()
                .duration_since(UNIX_EPOCH)
                .unwrap()
                .as_secs() as u32,
        ));

        let mut daemon = Daemon {
            hot_cache: hot_cache.clone(),
            cold_cache: cold_cache.clone(),
            action_rx,
            epoch: epoch.clone(),
            hit_counts: AHashMap::new(),
            arena: Arena::new(capacity),
            insert_queue: Vec::new(),
            remove_queue: Vec::new(),
            clear_flag: false,
            hot_capacity: hot_cap,
            duration: config.duration,
        };

        std::thread::spawn(move || daemon.start());

        Self {
            hot_cache,
            cold_cache,
            action_tx,
            epoch,
            duration: config.duration,
            get_buffer: Arc::new(Mutex::new(Vec::with_capacity(buffer_cap))),
        }
    }

    pub fn insert(&self, key: K, value: V) {
        let _ = self.action_tx.try_send(Action::Insert(key, value));
    }

    pub fn get(&self, key: &K) -> Option<V> {
        let hot = self.hot_cache.load();
        if let Some(v) = hot.get(key) {
            if let Ok(mut buf) = self.get_buffer.try_lock() {
                let cap = buf.capacity();
                buf.push(usize::MAX);
                if buf.len() >= cap {
                    let _ = self.action_tx.try_send(Action::Gets(std::mem::replace(
                        &mut buf,
                        Vec::with_capacity(cap),
                    )));
                }
            }
            return Some(v.clone());
        }

        let cold = self.cold_cache.load();
        let now = self.epoch.load(Ordering::Relaxed);

        if let Some(global_idx) = cold.get_idx(key) {
            if let Some(v) = cold.get(global_idx, now, self.duration) {
                if let Ok(mut buf) = self.get_buffer.try_lock() {
                    let cap = buf.capacity();
                    buf.push(global_idx);
                    if buf.len() >= cap {
                        let _ = self.action_tx.try_send(Action::Gets(std::mem::replace(
                            &mut buf,
                            Vec::with_capacity(cap),
                        )));
                    }
                }
                return Some(v.clone());
            } else {
                let _ = self.action_tx.try_send(Action::Remove(global_idx));
            }
        }

        None
    }

    pub fn remove(&self, key: &K) {
        let cold = self.cold_cache.load();
        if let Some(global_idx) = cold.get_idx(key) {
            let _ = self.action_tx.try_send(Action::Remove(global_idx));
        }
    }

    pub fn clear(&self) {
        let _ = self.action_tx.try_send(Action::Clear);
    }
}

struct Daemon<K, V> {
    hot_cache: Arc<ArcSwap<AHashMap<K, V>>>,
    cold_cache: Arc<ArcSwap<Cache<K, V>>>,
    action_rx: Receiver<Action<K, V>>,
    epoch: Arc<AtomicU32>,
    hit_counts: AHashMap<usize, u32>,
    arena: Arena,
    insert_queue: Vec<(K, V)>,
    remove_queue: Vec<usize>,
    clear_flag: bool,
    hot_capacity: usize,
    duration: u32,
}

impl<K: Hash + Eq + Clone, V: Clone> Daemon<K, V> {
    fn start(&mut self) {
        loop {
            let mut batch = Vec::new();
            match self
                .action_rx
                .recv_timeout(std::time::Duration::from_millis(10))
            {
                Ok(action) => {
                    batch.push(action);
                    while let Ok(act) = self.action_rx.try_recv() {
                        batch.push(act);
                    }
                }
                Err(_) => {
                    if self.hit_counts.is_empty()
                        && self.insert_queue.is_empty()
                        && self.remove_queue.is_empty()
                        && !self.clear_flag
                    {
                        continue;
                    }
                }
            }

            let now = SystemTime::now()
                .duration_since(UNIX_EPOCH)
                .unwrap()
                .as_secs() as u32;
            self.epoch.store(now, Ordering::Relaxed);

            self.compress_action(batch);
            self.apply_batch(now);
            self.hit_counts.clear();
        }
    }

    fn compress_action(&mut self, batch: Vec<Action<K, V>>) {
        for action in batch {
            match action {
                Action::Gets(idxs) => {
                    if !self.clear_flag {
                        for idx in idxs {
                            if idx != usize::MAX {
                                *self.hit_counts.entry(idx).or_default() += 1;
                            }
                        }
                    }
                }
                Action::Insert(k, v) => self.insert_queue.push((k, v)),
                Action::Remove(idx) => self.remove_queue.push(idx),
                Action::Clear => {
                    self.insert_queue.clear();
                    self.remove_queue.clear();
                    self.hit_counts.clear();
                    self.clear_flag = true;
                }
            }
        }
    }

    fn apply_batch(&mut self, now: u32) {
        let mut cold = self.cold_cache.load().as_ref().clone();
        let mut hot = self.hot_cache.load().as_ref().clone();
        let mut cold_changed = false;
        let mut hot_changed = false;

        if self.clear_flag {
            cold.clear();
            self.arena.clear();
            hot.clear();
            self.clear_flag = false;
            cold_changed = true;
            hot_changed = true;
        }

        let mut promote_set = Vec::new();
        let avg = if self.arena.records.is_empty() {
            0
        } else {
            self.arena.count_sum >> self.arena.shift_amt
        };

        let mut climbs = Vec::new();

        for (&idx, &weight) in &self.hit_counts {
            if idx < self.arena.records.len() {
                let rec = &mut self.arena.records[idx];
                if rec.epoch == 0 {
                    continue;
                }
                let w = std::cmp::min(weight, 255) as u8;
                let old_count = rec.count;
                rec.count = rec.count.saturating_add(w);
                self.arena.count_sum += (rec.count - old_count) as u32;

                if rec.count as u32 > avg * 2 {
                    promote_set.push(idx);
                }
                climbs.push((idx, rec.count));
            }
        }

        climbs.sort_by_key(|&(_, c)| std::cmp::Reverse(c));
        for (idx, _) in climbs {
            if idx >= self.arena.rev_map.len() {
                continue;
            }
            let mut curr_rank = self.arena.rev_map[idx];
            while curr_rank > 0 {
                let prev_idx = self.arena.ranks[curr_rank - 1];
                if self.arena.records[idx].count > self.arena.records[prev_idx].count {
                    self.arena.ranks.swap(curr_rank, curr_rank - 1);
                    self.arena.rev_map.swap(idx, prev_idx);
                    curr_rank -= 1;
                } else {
                    break;
                }
            }
        }

        for idx in self.remove_queue.drain(..) {
            let page_idx = idx >> SHIFT;
            let offset = idx & MASK;
            if page_idx < cold.pages.len() && offset < cold.pages[page_idx].nodes.len() {
                let key = cold.pages[page_idx].nodes[offset].key.clone();
                cold.remove(idx, &key);
                self.arena.remove(idx);
                if hot.remove(&key).is_some() {
                    hot_changed = true;
                }
                cold_changed = true;
            }
        }

        for (k, v) in self.insert_queue.drain(..) {
            let global_idx = if self.arena.records.len() < self.arena.capacity {
                let idx = self.arena.records.len();
                self.arena.insert(idx, now);
                idx
            } else {
                let victim_idx = self.arena.evict(now, self.duration);
                let p_idx = victim_idx >> SHIFT;
                let off = victim_idx & MASK;
                let victim_key = cold.pages[p_idx].nodes[off].key.clone();
                cold.remove_shard_only(&victim_key);
                if hot.remove(&victim_key).is_some() {
                    hot_changed = true;
                }
                self.arena.records[victim_idx].epoch = now;
                self.arena.records[victim_idx].count = 0;
                victim_idx
            };

            cold.insert(k, v, global_idx, now);
            cold_changed = true;
        }

        for idx in promote_set {
            let page_idx = idx >> SHIFT;
            let offset = idx & MASK;
            if page_idx < cold.pages.len() && offset < cold.pages[page_idx].nodes.len() {
                let node = &cold.pages[page_idx].nodes[offset];
                if node.epoch > 0 {
                    hot.insert(node.key.clone(), node.value.clone());
                    hot_changed = true;
                }
            }
        }

        if hot.len() > self.hot_capacity {
            let mut min_k = None;
            let mut min_count = u8::MAX;
            for k in hot.keys() {
                if let Some(idx) = cold.get_idx(k) {
                    if idx < self.arena.records.len() {
                        let c = self.arena.records[idx].count;
                        if c <= min_count {
                            min_count = c;
                            min_k = Some(k.clone());
                        }
                    }
                }
            }
            if let Some(k) = min_k {
                hot.remove(&k);
                hot_changed = true;
            }
        }

        if cold_changed {
            self.cold_cache.store(Arc::new(cold));
        }
        if hot_changed {
            self.hot_cache.store(Arc::new(hot));
        }
    }
}

#[derive(Clone)]
struct Cache<K, V> {
    hasher: RandomState,
    index: [Arc<AHashMap<K, usize>>; SHARD_SIZE],
    pages: Vec<Arc<Page<K, V>>>,
}

impl<K: Hash + Eq + Clone, V: Clone> Cache<K, V> {
    fn new(capacity: usize) -> Self {
        let hasher = RandomState::new();
        let index = std::array::from_fn(|_| {
            Arc::new(AHashMap::with_capacity_and_hasher(
                capacity / SHARD_SIZE,
                hasher.clone(),
            ))
        });
        let pages = (0..(capacity / PAGE_SIZE))
            .map(|_| {
                Arc::new(Page {
                    nodes: Vec::with_capacity(PAGE_SIZE),
                })
            })
            .collect();

        Self {
            hasher,
            index,
            pages,
        }
    }

    fn get_idx(&self, key: &K) -> Option<usize> {
        let shard_idx = (self.hasher.hash_one(key) as usize) & MASK;
        self.index[shard_idx].get(key).copied()
    }

    fn insert(&mut self, key: K, value: V, global_idx: usize, epoch: u32) {
        let shard_idx = (self.hasher.hash_one(&key) as usize) & MASK;
        Arc::make_mut(&mut self.index[shard_idx]).insert(key.clone(), global_idx);

        let page_idx = global_idx >> SHIFT;
        let offset = global_idx & MASK;
        let page = Arc::make_mut(&mut self.pages[page_idx]);

        if offset == page.nodes.len() {
            page.nodes.push(Node { key, value, epoch });
        } else {
            page.nodes[offset] = Node { key, value, epoch };
        }
    }

    fn get(&self, global_idx: usize, now: u32, duration: u32) -> Option<&V> {
        let page_idx = global_idx >> SHIFT;
        let offset = global_idx & MASK;
        let node = self.pages.get(page_idx)?.nodes.get(offset)?;

        if node.epoch == 0 || now.saturating_sub(node.epoch) > duration {
            return None;
        }
        Some(&node.value)
    }

    fn remove(&mut self, global_idx: usize, key: &K) {
        self.remove_shard_only(key);
        let page_idx = global_idx >> SHIFT;
        let offset = global_idx & MASK;
        if page_idx < self.pages.len() && offset < self.pages[page_idx].nodes.len() {
            Arc::make_mut(&mut self.pages[page_idx]).nodes[offset].epoch = 0;
        }
    }

    fn remove_shard_only(&mut self, key: &K) {
        let shard_idx = (self.hasher.hash_one(key) as usize) & MASK;
        Arc::make_mut(&mut self.index[shard_idx]).remove(key);
    }

    fn clear(&mut self) {
        for shard in self.index.iter_mut() {
            Arc::make_mut(shard).clear();
        }
        for page in self.pages.iter_mut() {
            let p = Arc::make_mut(page);
            for node in p.nodes.iter_mut() {
                node.epoch = 0;
            }
        }
    }
}

struct Arena {
    records: Vec<Record>,
    ranks: Vec<usize>,
    rev_map: Vec<usize>,
    evict_point: usize,
    direction: isize,
    count_sum: u32,
    capacity: usize,
    shift_amt: u32,
}

impl Arena {
    fn new(capacity: usize) -> Self {
        Self {
            records: Vec::with_capacity(capacity),
            ranks: Vec::with_capacity(capacity),
            rev_map: Vec::with_capacity(capacity),
            evict_point: 0,
            direction: 1,
            count_sum: 0,
            capacity,
            shift_amt: capacity.trailing_zeros(),
        }
    }

    fn insert(&mut self, global_idx: usize, epoch: u32) -> usize {
        if global_idx == self.records.len() {
            self.records.push(Record {
                index: global_idx,
                rank: self.ranks.len(),
                epoch,
                count: 0,
            });
            self.ranks.push(global_idx);
            self.rev_map.push(self.ranks.len() - 1);
        } else {
            self.records[global_idx].epoch = epoch;
            self.records[global_idx].count = 0;
        }
        global_idx
    }

    fn advance_evict(&mut self) {
        if self.capacity < 2 {
            self.evict_point = 0;
            return;
        }
        let mut next = self.evict_point as isize + self.direction;
        if next < 0 {
            next = 1;
            self.direction = 1;
        } else if next >= self.capacity as isize {
            next = (self.capacity as isize) - 2;
            self.direction = -1;
        }
        self.evict_point = next as usize;
    }

    fn evict(&mut self, now: u32, duration: u32) -> usize {
        let avg = if self.capacity == 0 {
            0
        } else {
            self.count_sum >> self.shift_amt
        };

        loop {
            let physical_idx = self.ranks[self.evict_point];
            let rec = &mut self.records[physical_idx];

            if rec.epoch == 0 || now.saturating_sub(rec.epoch) > duration {
                self.count_sum = self.count_sum.saturating_sub(rec.count as u32);
                rec.count = 0;
                self.advance_evict();
                return physical_idx;
            }

            if (rec.count as u32) <= avg {
                self.count_sum = self.count_sum.saturating_sub(rec.count as u32);
                rec.count = 0;
                self.advance_evict();
                return physical_idx;
            } else {
                rec.count = rec.count.saturating_sub(avg as u8);
                self.count_sum = self.count_sum.saturating_sub(avg);
                self.direction = -self.direction;
                self.advance_evict();
            }
        }
    }

    fn remove(&mut self, physical_idx: usize) {
        if physical_idx >= self.records.len() {
            return;
        }
        let rank_of_del = self.rev_map[physical_idx];
        if rank_of_del != self.evict_point && self.evict_point < self.ranks.len() {
            let evict_idx = self.ranks[self.evict_point];
            self.ranks.swap(rank_of_del, self.evict_point);
            self.rev_map.swap(physical_idx, evict_idx);
            self.records[physical_idx].rank = self.evict_point;
            self.records[evict_idx].rank = rank_of_del;
        }

        self.count_sum = self
            .count_sum
            .saturating_sub(self.records[physical_idx].count as u32);
        self.records[physical_idx].count = 0;
        self.records[physical_idx].epoch = 0;
    }

    fn clear(&mut self) {
        for r in self.records.iter_mut() {
            r.count = 0;
            r.epoch = 0;
        }
        self.ranks.clear();
        self.rev_map.clear();
        self.records.clear();
        self.evict_point = 0;
        self.direction = 1;
        self.count_sum = 0;
    }
}

#[derive(Clone)]
enum Action<K, V> {
    Insert(K, V),
    Gets(Vec<usize>),
    Remove(usize),
    Clear,
}

#[derive(Clone)]
struct Page<K, V> {
    nodes: Vec<Node<K, V>>,
}

#[derive(Clone)]
struct Node<K, V> {
    key: K,
    value: V,
    epoch: u32,
}

struct Record {
    index: usize,
    rank: usize,
    epoch: u32,
    count: u8,
}

pub struct Config {
    pub capacity: usize,
    pub duration: u32,
}
