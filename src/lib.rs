use ahash::{AHashMap, RandomState};
use arc_swap::ArcSwap;
use crossbeam::channel::{self, Receiver, Sender};
use std::hash::Hash;
use std::sync::Arc;
use std::sync::atomic::{AtomicU32, Ordering};
use std::time::{SystemTime, UNIX_EPOCH};

const SHARD_SIZE: usize = 64;
const PAGE_SIZE: usize = 64;
const SHIFT: usize = 6;
const MASK: usize = 63;
const PROMOTE_THRESHOLD: u32 = 2;
const HOT_SENTINEL: usize = usize::MAX;

// ─── Lean-style invariants ────────────────────────────────────────────────────
//
// Inv₁ (capacity alignment):   capacity % PAGE_SIZE = 0
// Inv₂ (shard routing):        shard_idx = hash(key) & (SHARD_SIZE-1)
//                               ∀ k. index[shard(k)].contains(k) ↔ cache contains k
// Inv₃ (global index):         global_idx = page_idx * PAGE_SIZE + offset
//                               page_idx  = global_idx >> SHIFT
//                               offset    = global_idx &  MASK
// Inv₄ (arena↔page bijection): ∀ r ∈ records. pages[r.index>>SHIFT][r.index&MASK] is valid
//                               ∀ r. ranks[rev_map[r.index]] = r.index  (round-trip)
// Inv₅ (epoch monotone):       epoch only increments, never wraps within duration window
// Inv₆ (t1⊆cache):             ∀ k ∈ t1. ∃ k ∈ cache
//                               t1 eviction must also be consistent with cache index
// Inv₇ (get_buffer):           ArrayQueue bounded; push may fail silently (acceptable)
// Inv₈ (count_sum):            count_sum = Σ records[i].count  (maintained incrementally)
// Inv₉ (version ABA):          t2.data[idx] = Some((version, v))
//                               valid iff version == cache.pages[p][o].version
// ─────────────────────────────────────────────────────────────────────────────

pub struct DualCacheFF<K, V> {
    t1: Arc<ArcSwap<AHashMap<K, V>>>,
    t2: Arc<ArcSwap<T2<V>>>,
    cache: Arc<ArcSwap<Cache<K, V>>>,
    action_tx: Sender<Action<K, V>>,
    epoch: Arc<AtomicU32>,
    duration: u32,
    get_buffer: Arc<GetBuffer>,
}

impl<K, V> Clone for DualCacheFF<K, V> {
    fn clone(&self) -> Self {
        Self {
            t1: self.t1.clone(),
            t2: self.t2.clone(),
            cache: self.cache.clone(),
            action_tx: self.action_tx.clone(),
            epoch: self.epoch.clone(),
            duration: self.duration,
            get_buffer: self.get_buffer.clone(),
        }
    }
}

impl<K, V> std::fmt::Debug for DualCacheFF<K, V> {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("DualCacheFF")
            .field("duration", &self.duration)
            .finish()
    }
}

impl<K: Hash + Eq + Clone + Send + Sync + 'static, V: Clone + Send + Sync + 'static>
    DualCacheFF<K, V>
{
    // PRE:  config.capacity > 0
    // POST: self satisfies Inv₁..Inv₉ at t=0
    pub fn new(config: Config) -> Self {
        // Inv₁: align capacity to PAGE_SIZE boundary
        let capacity = (config.capacity + PAGE_SIZE - 1) & !(PAGE_SIZE - 1); //TODO: make sure capacity will round up to multiple of PAGE_SIZE and 0 will throw error
        debug_assert!(capacity % PAGE_SIZE == 0);

        let hot_cap = capacity / 10;

        let t1 = Arc::new(ArcSwap::from_pointee(AHashMap::with_capacity_and_hasher(
            hot_cap,
            RandomState::new(),
        )));

        let t2_cap = capacity / 5;
        let t2 = Arc::new(ArcSwap::from_pointee(T2::new(t2_cap)));

        let cache = Arc::new(ArcSwap::from_pointee(Cache::new(capacity)));

        let (action_tx, action_rx) = channel::bounded(1024);

        let epoch = Arc::new(AtomicU32::new(
            SystemTime::now()
                .duration_since(UNIX_EPOCH)
                .unwrap()
                .as_secs() as u32,
        ));

        let get_buffer = Arc::new(GetBuffer::new(capacity / 10));

        let mut daemon = Daemon {
            t1: t1.clone(),
            t2: t2.clone(),
            cache: cache.clone(),
            action_rx,
            epoch: epoch.clone(),
            hit_counts: AHashMap::new(),
            arena: Arena::new(capacity),
            insert_queue: Vec::new(),
            remove_queue: Vec::new(),
            clear_flag: false,
            hot_capacity: hot_cap,
        };

        std::thread::spawn(move || daemon.start(config.duration));

        Self {
            t1,
            t2,
            cache,
            action_tx,
            epoch,
            duration: config.duration,
            get_buffer,
        }
    }

    // PRE:  (none)
    // POST: Action::Insert queued; cache-aside semantics allow silent drop on full channel
    pub fn insert(&self, key: K, value: V) {
        let _ = self.action_tx.try_send(Action::Insert(key, value));
    }

    // PRE:  (none)
    // POST: returns Some(v) iff key exists and epoch not expired
    //       get_buffer updated for Daemon count tracking
    pub fn get(&self, key: &K) -> Option<V> {
        // T1 — L1 hit
        {
            let t1_guard = self.t1.load();
            if let Some(v) = t1_guard.get(key) {
                let _ = self.get_buffer.buffer.push(HOT_SENTINEL);
                self.try_flush_buffer();
                return Some(v.clone());
            }
        }

        let cache_guard = self.cache.load();
        let now = self.epoch.load(Ordering::Relaxed);

        let shard_idx = (cache_guard.hasher.hash_one(key) as usize) & MASK;
        let global_idx = match cache_guard.index[shard_idx].get(key).copied() {
            Some(idx) => idx,
            None => {
                return None;
            }
        };

        // T2 — L2 hit (version-gated, Inv₉)
        {
            let t2_guard = self.t2.load();
            if let Some((ver, v)) = t2_guard.get(global_idx) {
                let page_idx = global_idx >> SHIFT;
                let offset = global_idx & MASK;
                let node_ver = cache_guard
                    .pages
                    .get(page_idx)
                    .and_then(|p| p.nodes.get(offset))
                    .map(|n| n.version)
                    .unwrap_or(0);
                if ver == node_ver {
                    let _ = self.get_buffer.buffer.push(global_idx);
                    self.try_flush_buffer();
                    return Some(v.clone());
                }
                // version mismatch → fallthrough to cache
            }
        }

        // Cache — L3 hit
        match cache_guard.get(global_idx, now, self.duration) {
            Some(v) => {
                let _ = self.get_buffer.buffer.push(global_idx);
                self.try_flush_buffer();
                Some(v.clone())
            }
            None => {
                let _ = self.action_tx.try_send(Action::Remove(global_idx));
                None
            }
        }
    }

    pub fn remove(&self, key: &K) {
        let cache_guard = self.cache.load();
        let shard_idx = (cache_guard.hasher.hash_one(key) as usize) & MASK;
        if let Some(&global_idx) = cache_guard.index[shard_idx].get(key) {
            // blocking send: remove must be reliable
            let _ = self.action_tx.send(Action::Remove(global_idx));
        }
    }

    pub fn clear(&self) {
        let _ = self.action_tx.send(Action::Clear);
    }

    #[inline]
    fn try_flush_buffer(&self) {
        let cap = self.get_buffer.buffer.capacity();
        if self.get_buffer.buffer.len() >= cap {
            let mut batch = Vec::with_capacity(cap);
            while let Some(idx) = self.get_buffer.buffer.pop() {
                batch.push(idx);
            }
            if !batch.is_empty() {
                let _ = self.action_tx.try_send(Action::Gets(batch));
            }
        }
    }
}

// ─── Daemon ──────────────────────────────────────────────────────────────────

struct Daemon<K, V> {
    t1: Arc<ArcSwap<AHashMap<K, V>>>,
    t2: Arc<ArcSwap<T2<V>>>,
    cache: Arc<ArcSwap<Cache<K, V>>>,
    action_rx: Receiver<Action<K, V>>,
    epoch: Arc<AtomicU32>,
    hit_counts: AHashMap<usize, u32>,
    arena: Arena,
    insert_queue: Vec<(K, V)>,
    remove_queue: Vec<usize>,
    clear_flag: bool,
    hot_capacity: usize,
    // t2_capacity: usize,
}
// TODO: Daemon impl Drop trait, capa
impl<K: Hash + Eq + Clone, V: Clone> Daemon<K, V> {
    // LOOP invariant: Inv₁..Inv₉ hold at start of every iteration
    fn start(&mut self, duration: u32) {
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
            self.epoch.store(now, Ordering::Relaxed); // Inv₅

            self.compress_action(batch);
            self.apply_batch(now, duration);
            self.hit_counts.clear();
        }
    }

    // PRE:  batch is raw Vec<Action>
    // POST: hit_counts accumulated; insert/remove queues populated in order
    //       if clear seen: prior queues voided, clear_flag=true            -- Inv₆
    fn compress_action(&mut self, batch: Vec<Action<K, V>>) {
        for action in batch {
            match action {
                Action::Gets(idxs) => {
                    if !self.clear_flag {
                        for idx in idxs {
                            if idx != HOT_SENTINEL {
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

    // PRE:  hit_counts populated, queues ready
    // POST: cache/t1/t2 views updated; Inv₁..Inv₉ hold
    fn apply_batch(&mut self, now: u32, duration: u32) {
        let mut cache = self.cache.load().as_ref().clone();
        let mut t1 = self.t1.load().as_ref().clone();
        let mut t2 = self.t2.load().as_ref().clone();
        let mut cache_changed = false;
        let mut t1_changed = false;
        let mut t2_changed = false;

        // PHASE 0 — clear
        if self.clear_flag {
            cache.clear();
            self.arena.clear();
            t1.clear();
            t2.clear();
            self.clear_flag = false;
            cache_changed = true;
            t1_changed = true;
            t2_changed = true;
        }

        let avg = self.arena.avg();

        // PHASE 1 — apply hit counts, mark promotions
        let mut promote_t2: Vec<usize> = Vec::new();
        let mut promote_t1: Vec<usize> = Vec::new();

        for (&idx, &weight) in &self.hit_counts {
            if idx >= self.arena.records.len() {
                continue;
            }
            let rec = &mut self.arena.records[idx];
            if rec.epoch == 0 {
                continue;
            }
            let w = weight.min(255) as u8;
            let old = rec.count;
            rec.count = rec.count.saturating_add(w);
            self.arena.count_sum += (rec.count - old) as u32; // Inv₈

            let c = rec.count as u32;
            if c > avg * PROMOTE_THRESHOLD * 2 {
                promote_t1.push(idx);
            } else if c > avg * PROMOTE_THRESHOLD {
                promote_t2.push(idx);
            }
        }

        // PHASE 2 — climb
        let mut climbs: Vec<(usize, u8)> = self
            .hit_counts
            .keys()
            .filter_map(|&idx| {
                self.arena
                    .records
                    .get(idx)
                    .filter(|r| r.epoch != 0)
                    .map(|r| (idx, r.count))
            })
            .collect();
        climbs.sort_unstable_by(|a, b| b.1.cmp(&a.1));

        for (idx, _) in climbs {
            if idx >= self.arena.rev_map.len() {
                continue;
            }
            let mut curr_rank = self.arena.rev_map[idx];
            while curr_rank > 0 {
                let prev_phys = self.arena.ranks[curr_rank - 1];
                if self.arena.records[idx].count > self.arena.records[prev_phys].count {
                    self.arena.ranks.swap(curr_rank, curr_rank - 1);
                    self.arena.rev_map.swap(idx, prev_phys);
                    curr_rank -= 1;
                } else {
                    break;
                }
            }
        }

        // PHASE 3 — removes
        for idx in self.remove_queue.drain(..) {
            let page_idx = idx >> SHIFT;
            let offset = idx & MASK;
            if page_idx >= cache.pages.len() {
                continue;
            }
            if offset >= cache.pages[page_idx].nodes.len() {
                continue;
            }
            let key = cache.pages[page_idx].nodes[offset].key.clone();
            cache.remove(idx, &key);
            self.arena.remove(idx);
            if t1.remove(&key).is_some() {
                t1_changed = true;
            }
            // t2 lazily invalidated via version mismatch — no COW needed here (Inv₉)
            cache_changed = true;
        }

        // PHASE 4 — inserts
        for (k, v) in self.insert_queue.drain(..) {
            let global_idx = if self.arena.records.len() < self.arena.capacity {
                let idx = self.arena.records.len();
                self.arena.insert(idx, now); // Inv₄
                idx
            } else {
                let victim = self.arena.evict(now, duration);
                let p = victim >> SHIFT;
                let o = victim & MASK;
                if p < cache.pages.len() && o < cache.pages[p].nodes.len() {
                    let vkey = cache.pages[p].nodes[o].key.clone();
                    cache.remove_shard_only(&vkey);
                    if t1.remove(&vkey).is_some() {
                        t1_changed = true;
                    }
                    // version bump handled inside cache.insert below
                }
                // bump version for ABA protection (Inv₉)
                let p2 = victim >> SHIFT;
                let o2 = victim & MASK;
                if p2 < cache.pages.len() && o2 < cache.pages[p2].nodes.len() {
                    Arc::make_mut(&mut cache.pages[p2]).nodes[o2].version =
                        cache.pages[p2].nodes[o2].version.wrapping_add(1);
                }
                self.arena.records[victim].epoch = now;
                self.arena.records[victim].count = 0;
                victim
            };

            cache.insert(k, v, global_idx, now);
            cache_changed = true;
        }

        // PHASE 5 — promote to t2 (Inv₉)
        for idx in promote_t2 {
            let page_idx = idx >> SHIFT;
            let offset = idx & MASK;
            if page_idx >= cache.pages.len() || offset >= cache.pages[page_idx].nodes.len() {
                continue;
            }
            let node = &cache.pages[page_idx].nodes[offset];
            if node.epoch == 0 {
                continue;
            }
            if idx < t2.data.len() {
                t2.data[idx] = Some((node.version, node.value.clone()));
                t2_changed = true;
            }
        }

        // PHASE 6 — promote to t1 (Inv₆)
        for idx in promote_t1 {
            let page_idx = idx >> SHIFT;
            let offset = idx & MASK;
            if page_idx >= cache.pages.len() || offset >= cache.pages[page_idx].nodes.len() {
                continue;
            }
            let node = &cache.pages[page_idx].nodes[offset];
            if node.epoch == 0 {
                continue;
            }
            t1.insert(node.key.clone(), node.value.clone());
            t1_changed = true;
        }

        // t1 capacity enforcement — evict lowest count key
        if t1.len() > self.hot_capacity {
            let mut min_k: Option<K> = None;
            let mut min_c = u8::MAX;
            for k in t1.keys() {
                let shard = (cache.hasher.hash_one(k) as usize) & MASK;
                if let Some(&idx) = cache.index[shard].get(k) {
                    if idx < self.arena.records.len() {
                        let c = self.arena.records[idx].count;
                        if c <= min_c {
                            min_c = c;
                            min_k = Some(k.clone());
                        }
                    }
                }
            }
            if let Some(k) = min_k {
                t1.remove(&k);
                t1_changed = true;
            }
        }

        // PHASE 7 — publish (Inv₆, Inv₉)
        if cache_changed {
            self.cache.store(Arc::new(cache));
        }
        if t1_changed {
            self.t1.store(Arc::new(t1));
        }
        if t2_changed {
            self.t2.store(Arc::new(t2));
        }
    }
}

// ─── Cache ───────────────────────────────────────────────────────────────────

#[derive(Clone)]
struct Cache<K, V> {
    hasher: RandomState,
    index: [Arc<AHashMap<K, usize>>; SHARD_SIZE],
    pages: Vec<Arc<Page<K, V>>>,
}

impl<K: Hash + Eq + Clone, V: Clone> Cache<K, V> {
    // PRE:  capacity % PAGE_SIZE == 0                                       -- Inv₁
    // POST: index has SHARD_SIZE empty shards, pages has capacity/PAGE_SIZE empty pages
    fn new(capacity: usize) -> Self {
        debug_assert!(capacity % PAGE_SIZE == 0);
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

    // POST: index[shard(key)] maps key → global_idx; pages[page_idx][offset] = Node -- Inv₂,Inv₃
    fn insert(&mut self, key: K, value: V, global_idx: usize, epoch: u32) {
        let shard_idx = (self.hasher.hash_one(&key) as usize) & MASK; // Inv₂
        Arc::make_mut(&mut self.index[shard_idx]).insert(key.clone(), global_idx);

        let page_idx = global_idx >> SHIFT; // Inv₃
        let offset = global_idx & MASK;
        let page = Arc::make_mut(&mut self.pages[page_idx]);

        let node = Node {
            key,
            value,
            epoch,
            version: 0,
        };
        if offset == page.nodes.len() {
            page.nodes.push(node);
        } else {
            // preserve version bump done by evict phase
            let ver = page.nodes[offset].version;
            page.nodes[offset] = node;
            page.nodes[offset].version = ver;
        }
    }

    // POST: None if epoch expired (Inv₅), Some(&v) otherwise
    fn get(&self, global_idx: usize, now: u32, duration: u32) -> Option<&V> {
        let page_idx = global_idx >> SHIFT;
        let offset = global_idx & MASK;
        let node = self.pages.get(page_idx)?.nodes.get(offset)?;
        if node.epoch == 0 || now.saturating_sub(node.epoch) > duration {
            return None;
        }
        Some(&node.value)
    }

    // POST: index[shard(key)] removed; page slot epoch=0 (tombstone)       -- Inv₂
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

    // POST: all shards empty, all page epochs=0; Inv₁ preserved
    fn clear(&mut self) {
        for shard in self.index.iter_mut() {
            Arc::make_mut(shard).clear();
        }
        for page in self.pages.iter_mut() {
            for node in Arc::make_mut(page).nodes.iter_mut() {
                node.epoch = 0;
            }
        }
    }
}

// ─── T2 (L2 flat vec, version-gated) ─────────────────────────────────────────

#[derive(Clone)]
struct T2<V> {
    data: Vec<Option<(u16, V)>>, // (version, value) — Inv₉
}

impl<V: Clone> T2<V> {
    fn new(capacity: usize) -> Self {
        Self {
            data: vec![None; capacity],
        }
    }

    // POST: Some((version, &v)) if slot populated, None otherwise
    fn get(&self, global_idx: usize) -> Option<(u16, V)> {
        self.data
            .get(global_idx)?
            .as_ref()
            .map(|(ver, v)| (*ver, v.clone()))
    }

    fn clear(&mut self) {
        for slot in self.data.iter_mut() {
            *slot = None;
        }
    }
}

// ─── Arena ───────────────────────────────────────────────────────────────────

struct Arena {
    records: Vec<Record>, // physical_idx → Record (fixed address)
    ranks: Vec<usize>,    // rank → physical_idx  (sorted by frequency)
    rev_map: Vec<usize>,  // physical_idx → rank  (Inv₄ round-trip)
    evict_point: usize,
    direction: isize,
    count_sum: u32,
    capacity: usize,
    shift_amt: u32,
}

impl Arena {
    fn new(capacity: usize) -> Self {
        // shift_amt must use a power-of-two; force align
        let aligned = capacity.next_power_of_two();
        Self {
            records: Vec::with_capacity(capacity),
            ranks: Vec::with_capacity(capacity),
            rev_map: Vec::with_capacity(capacity),
            evict_point: 0,
            direction: 1,
            count_sum: 0,
            capacity,
            shift_amt: aligned.trailing_zeros(),
        }
    }

    #[inline]
    fn avg(&self) -> u32 {
        if self.capacity == 0 {
            0
        } else {
            self.count_sum >> self.shift_amt
        }
    }

    // PRE:  global_idx is a free slot
    // POST: records[global_idx] initialised; ranks/rev_map updated         -- Inv₄
    fn insert(&mut self, global_idx: usize, epoch: u32) {
        let rank = self.ranks.len();
        if global_idx == self.records.len() {
            self.records.push(Record {
                rank,
                epoch,
                count: 0,
            });
            self.ranks.push(global_idx);
            self.rev_map.push(rank);
        } else {
            self.records[global_idx].epoch = epoch;
            self.records[global_idx].count = 0;
            self.records[global_idx].rank = rank;
        }
    }

    // PRE:  ranks.len() == capacity
    // POST: returns physical_idx of victim; count_sum updated               -- Inv₈
    fn evict(&mut self, now: u32, duration: u32) -> usize {
        loop {
            let phys = self.ranks[self.evict_point];
            let rec = &mut self.records[phys];
            let avg = if self.capacity == 0 {
                0
            } else {
                self.count_sum >> self.shift_amt
            };

            if rec.epoch == 0 || now.saturating_sub(rec.epoch) > duration {
                self.count_sum = self.count_sum.saturating_sub(rec.count as u32); // Inv₈
                rec.count = 0;
                self.advance();
                return phys;
            }

            if (rec.count as u32) <= avg {
                self.count_sum = self.count_sum.saturating_sub(rec.count as u32); // Inv₈
                rec.count = 0;
                self.advance();
                return phys;
            } else {
                // hot: age down and keep scanning
                let decay = avg.min(rec.count as u32);
                rec.count = rec.count.saturating_sub(decay as u8);
                self.count_sum = self.count_sum.saturating_sub(decay); // Inv₈
                self.direction = -self.direction;
                self.advance();
            }
        }
    }

    // POST: record zeroed; ranks entry swapped to evict_point region        -- Inv₄
    fn remove(&mut self, physical_idx: usize) {
        if physical_idx >= self.records.len() {
            return;
        }
        let rank_of_del = self.rev_map[physical_idx];
        if rank_of_del != self.evict_point && self.evict_point < self.ranks.len() {
            let evict_phys = self.ranks[self.evict_point];
            self.ranks.swap(rank_of_del, self.evict_point);
            self.rev_map.swap(physical_idx, evict_phys);
            self.records[physical_idx].rank = self.evict_point;
            self.records[evict_phys].rank = rank_of_del;
        }
        self.count_sum = self
            .count_sum
            .saturating_sub(self.records[physical_idx].count as u32); // Inv₈
        self.records[physical_idx].count = 0;
        self.records[physical_idx].epoch = 0;
    }

    // POST: all records zeroed; ranks/rev_map cleared; evict_point=0; count_sum=0
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

    #[inline]
    fn advance(&mut self) {
        if self.capacity < 2 {
            self.evict_point = 0;
            return;
        }
        let next = self.evict_point as isize + self.direction;
        if next < 0 {
            self.evict_point = 1;
            self.direction = 1;
        } else if next >= self.capacity as isize {
            self.evict_point = self.capacity - 2;
            self.direction = -1;
        } else {
            self.evict_point = next as usize;
        }
    }
}

// ─── GetBuffer ───────────────────────────────────────────────────────────────

struct GetBuffer {
    buffer: crossbeam::queue::ArrayQueue<usize>,
}

impl GetBuffer {
    fn new(cap: usize) -> Self {
        Self {
            buffer: crossbeam::queue::ArrayQueue::new(cap.max(1)),
        }
    }
}

// ─── Supporting types ─────────────────────────────────────────────────────────

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
    epoch: u32,   // TTL only (Inv₅)
    version: u16, // ABA guard (Inv₉), incremented on evict overwrite
}

#[repr(align(64))]
struct Record {
    rank: usize,
    epoch: u32,
    count: u8,
}

pub struct Config {
    pub capacity: usize,
    pub duration: u32,
}
