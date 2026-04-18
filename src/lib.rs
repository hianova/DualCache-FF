use ahash::{AHashMap, RandomState};
use arc_swap::ArcSwap;
use crossbeam::channel::{Receiver, Sender};
use std::sync::Arc;
use std::sync::atomic::AtomicU32;

const SHARD_SIZE: usize = 64;
const PAGE_SIZE: usize = 64;
const SHIFT: usize = 6;
const MASK: usize = 63;
const PROMOTE_THRESHOLD: u32 = 2;

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
// Inv₆ (hot⊆cold):             ∀ k ∈ T1/T2. ∃ k ∈ cache
//                               hot eviction must also update cache index
// Inv₈ (count_sum):            count_sum = Σ records[i].count  (maintained incrementally)
// ─────────────────────────────────────────────────────────────────────────────

// # SPEC:
// `get` checks T1 → T2 → cache.
#[derive(Clone)]
pub struct DualCacheFF<K, V> {
    t1: Arc<ArcSwap<T1<V>>>, // direct-mapped, L1-resident
    t2: Arc<ArcSwap<T2<V>>>, // flat vec, promoted from cache
    cache: Arc<ArcSwap<Cache<K, V>>>,
    hasher: RandomState, // shared hasher for T1/T2 slot routing
    action_tx: Sender<Action<K, V>>,
    epoch: Arc<AtomicU32>,
    duration: u32, // TTL秒數，get路徑需要
}

impl<K, V> DualCacheFF<K, V>
where
    K: std::hash::Hash + Eq + Clone,
    V: Clone,
{
    pub fn build(config: Config) -> (Self, Daemon<K, V>) {
        let capacity = (config.capacity + PAGE_SIZE - 1) & !(PAGE_SIZE - 1);
        let hasher = RandomState::new();
        let (action_tx, action_rx) = crossbeam::channel::bounded(1024);
        let epoch = Arc::new(AtomicU32::new(std::time::SystemTime::now().duration_since(std::time::UNIX_EPOCH).unwrap_or_default().as_secs() as u32));
        
        let t1 = Arc::new(ArcSwap::from_pointee(T1::new()));
        let t2_size = if capacity < 5 { 1 } else { (capacity / 5).next_power_of_two() };
        let t2 = Arc::new(ArcSwap::from_pointee(T2::new(t2_size)));
        let cache = Arc::new(ArcSwap::from_pointee(Cache::new(capacity, hasher.clone())));
        
        let daemon = Daemon {
            t1: t1.clone(),
            t2: t2.clone(),
            cache: cache.clone(),
            hasher: hasher.clone(),
            action_rx,
            epoch: epoch.clone(),
            config: Config { capacity, duration: config.duration },
            hit_counts: AHashMap::new(),
            wait_list: Vec::new(),
            arena: Arena::new(capacity),
        };
        
        let cache_ff = DualCacheFF {
            t1, t2, cache, hasher, action_tx, epoch, duration: config.duration,
        };
        
        (cache_ff, daemon)
    }

    pub fn insert(&self, key: K, value: V) {
        let _ = self.action_tx.try_send(Action::Insert(key, value));
    }

    pub fn get(&self, key: &K) -> Option<V>
    where
        K: std::hash::Hash + Eq,
        V: Clone,
    {
        // FAST PATH — T1 (direct-mapped):
        if let Some(v) = self.t1.load().get(key, &self.hasher) {
            let _ = self.action_tx.try_send(Action::Gets(usize::MAX));
            return Some(v.clone());
        }

        // SLOW PATH — cache map lookup
        let guard = self.cache.load();
        let shard_idx = (self.hasher.hash_one(key) as usize) & (SHARD_SIZE - 1);
        let packed = *guard.index[shard_idx].get(key)?;
        let global_idx = packed & 0xFFFFFFFF;
        let expected_version = (packed >> 32) as u16;

        // FAST PATH — T2 (flat vec, version-gated):
        let t2_guard = self.t2.load();
        let slot_idx = (self.hasher.hash_one(key) as usize) & (t2_guard.data.len() - 1); // We still use hash to route to T2 slot
        if let Some(v) = t2_guard.get(slot_idx, expected_version) {
            let _ = self.action_tx.try_send(Action::Gets(global_idx));
            return Some(v.clone());
        }

        // read data page
        let page_idx = global_idx >> SHIFT;
        let offset = global_idx & MASK;
        let node = guard.pages.get(page_idx)?.nodes.get(offset)?;

        let now = self.epoch.load(std::sync::atomic::Ordering::Relaxed);
        if now.saturating_sub(node.epoch) > self.duration {
            let _ = self.action_tx.try_send(Action::Remove(global_idx));
            return None;
        }

        let _ = self.action_tx.try_send(Action::Gets(global_idx));
        Some(node.value.clone())
    }

    pub fn remove(&self, key: &K) {
        let guard = self.cache.load();
        let shard_idx = (self.hasher.hash_one(key) as usize) & (SHARD_SIZE - 1);
        if let Some(packed) = guard.index[shard_idx].get(key) {
             let global_idx = packed & 0xFFFFFFFF;
             let _ = self.action_tx.try_send(Action::Remove(global_idx));
        }
    }

    pub fn clear(&self) {
        let _ = self.action_tx.try_send(Action::Clear);
    }
}

impl<K, V> DualCacheFF<K, V>
where
    K: std::hash::Hash + Eq + Clone + Send + Sync + 'static,
    V: Clone + Send + Sync + 'static,
{
    pub fn new(config: Config) -> Self {
        let (cache, mut daemon) = Self::build(config);
        std::thread::spawn(move || daemon.start());
        cache
    }
}

// # SPEC:
// 單線程 writer。接收 Action batch，更新 cache/T1/T2/arena，
// 批次完成後 ArcSwap::store 發布新版本。
pub struct Daemon<K, V> {
    t1: Arc<ArcSwap<T1<V>>>,
    t2: Arc<ArcSwap<T2<V>>>,
    cache: Arc<ArcSwap<Cache<K, V>>>,
    hasher: RandomState,
    action_rx: Receiver<Action<K, V>>,
    epoch: Arc<AtomicU32>,
    config: Config,
    hit_counts: AHashMap<usize, u32>,
    // 板凳區：insert 先進這裡，滿了或 batch 結束才寫 cache
    // 用 Vec 而非 fixed array：K/V 不保證 Copy/Default
    wait_list: Vec<(K, V)>,
    arena: Arena,
}

impl<K, V> Daemon<K, V>
where
    K: std::hash::Hash + Eq + Clone,
    V: Clone,
{
    pub fn start(&mut self) {
        let mut batch = Vec::with_capacity(64);
        loop {
            let now = std::time::SystemTime::now().duration_since(std::time::UNIX_EPOCH).unwrap_or_default().as_secs() as u32;
            self.epoch.store(now, std::sync::atomic::Ordering::Relaxed);

            batch.clear();
            match self.action_rx.recv_timeout(std::time::Duration::from_millis(10)) {
                Ok(action) => {
                    batch.push(action);
                    while let Ok(act) = self.action_rx.try_recv() {
                        batch.push(act);
                        if batch.len() >= 64 { break; }
                    }
                }
                Err(crossbeam::channel::RecvTimeoutError::Timeout) => {
                    if self.wait_list.is_empty() && self.hit_counts.is_empty() { continue; }
                }
                Err(crossbeam::channel::RecvTimeoutError::Disconnected) => break,
            }

            let run_batch = std::mem::take(&mut batch);
            let (removes, clear_cache) = self.compress_action(run_batch);
            self.apply_batch(now, removes, clear_cache);
            self.hit_counts.clear();
        }
    }

    fn compress_action(&mut self, batch: Vec<Action<K, V>>) -> (Vec<usize>, bool) {
        let mut removes = Vec::new();
        let mut clear_cache = false;
        for action in batch {
            match action {
                Action::Gets(idx) => {
                    if idx != usize::MAX {
                        *self.hit_counts.entry(idx).or_default() += 1;
                    }
                }
                Action::Insert(k, v) => {
                    if let Some(pos) = self.wait_list.iter_mut().find(|(existing_k, _)| *existing_k == k) {
                        pos.1 = v;
                    } else {
                        self.wait_list.push((k, v));
                    }
                }
                Action::Remove(idx) => removes.push(idx),
                Action::Clear => clear_cache = true,
            }
        }
        (removes, clear_cache)
    }

    fn apply_batch(&mut self, now: u32, removes: Vec<usize>, clear_cache: bool) {
        if clear_cache {
            self.hit_counts.clear();
            self.wait_list.clear();
            self.arena = Arena::new(self.config.capacity);
            self.t1.store(Arc::new(T1::new()));
            self.t2.store(Arc::new(T2::new(if self.config.capacity < 5 { 1 } else { (self.config.capacity / 5).next_power_of_two() })));
            self.cache.store(Arc::new(Cache::new(self.config.capacity, self.hasher.clone())));
            return;
        }

        // PHASE 0
        let insert_queue = std::mem::take(&mut self.wait_list);
        let mut new_cache = (**self.cache.load()).clone();

        // PHASE 1
        for (&idx, &count) in &self.hit_counts {
            if let Some(rec) = self.arena.records.get_mut(idx) {
                rec.count = rec.count.saturating_add(count as u8);
                self.arena.count_sum = self.arena.count_sum.saturating_add(count);
            }
        }

        // PHASE 3 (Phase 2 Climb is implicit in Age-Down behavior of Evict)
        for idx in removes {
            new_cache.remove(idx);
            if let Some(rec) = self.arena.records.get_mut(idx) {
                self.arena.count_sum = self.arena.count_sum.saturating_sub(rec.count as u32);
                rec.count = 0;
                rec.epoch = 0;
            }
        }

        // PHASE 4
        for (k, v) in insert_queue {
            let global_idx = if self.arena.records.len() < self.config.capacity {
                let idx = self.arena.records.len();
                self.arena.insert(idx, now);
                idx
            } else {
                self.arena.evict(now, self.config.duration)
            };
            new_cache.insert(k, v, global_idx, now);
        }

        // PHASE 5
        let mut new_t1 = (**self.t1.load()).clone();
        let mut new_t2 = (**self.t2.load()).clone();
        let t2_size = new_t2.data.len();

        for (&idx, &count) in &self.hit_counts {
            let page_idx = idx >> SHIFT;
            let offset = idx & MASK;
            if let Some(page) = new_cache.pages.get(page_idx) {
                if let Some(node) = page.nodes.get(offset) {
                    let h = self.hasher.hash_one(&node.key);
                    
                    let t2_slot = (h as usize) & (t2_size - 1);
                    if t2_size > 0 {
                        new_t2.data[t2_slot] = Some((node.version, node.value.clone()));
                    }
                    
                    if count >= PROMOTE_THRESHOLD {
                        let t1_slot = (h as usize) & (PAGE_SIZE - 1);
                        let fp = (h >> 48) as u16;
                        new_t1.slots[t1_slot] = Some((fp, node.value.clone()));
                    }
                }
            }
        }

        // PHASE 6
        self.t1.store(Arc::new(new_t1));
        self.t2.store(Arc::new(new_t2));
        self.cache.store(Arc::new(new_cache));
    }
}

// ─── Cache ────────────────────────────────────────────────────────────────────

struct Cache<K, V> {
    hasher: RandomState, // 放在 Cache 內，保持 shard 路由自洽
    index: [Arc<AHashMap<K, usize>>; SHARD_SIZE],
    pages: Vec<Arc<Page<K, V>>>,
}

impl<K, V> Cache<K, V>
where
    K: std::hash::Hash + Eq + Clone,
    V: Clone,
{
    fn new(capacity: usize, hasher: RandomState) -> Self {
        let pages_count = capacity / PAGE_SIZE;
        let pages = (0..pages_count).map(|_| Arc::new(Page { nodes: Vec::with_capacity(PAGE_SIZE) })).collect();
        let index = core::array::from_fn(|_| Arc::new(AHashMap::new()));
        Self { hasher, index, pages }
    }

    fn insert(&mut self, key: K, value: V, global_idx: usize, epoch: u32) {
        let page_idx = global_idx >> SHIFT;
        let offset = global_idx & MASK;
        let page = Arc::make_mut(&mut self.pages[page_idx]);
        
        if page.nodes.len() == offset {
            let version = 1;
            let shard_idx = (self.hasher.hash_one(&key) as usize) & (SHARD_SIZE - 1);
            let shard_map = Arc::make_mut(&mut self.index[shard_idx]);
            shard_map.insert(key.clone(), global_idx | ((version as usize) << 32));
            page.nodes.push(Node { key, value, epoch, version });
        } else {
            let old_key = &page.nodes[offset].key;
            let old_shard_idx = (self.hasher.hash_one(old_key) as usize) & (SHARD_SIZE - 1);
            let old_shard_map = Arc::make_mut(&mut self.index[old_shard_idx]);
            old_shard_map.remove(old_key);
            
            let version = page.nodes[offset].version.wrapping_add(1);
            let shard_idx = (self.hasher.hash_one(&key) as usize) & (SHARD_SIZE - 1);
            let shard_map = Arc::make_mut(&mut self.index[shard_idx]);
            shard_map.insert(key.clone(), global_idx | ((version as usize) << 32));
            
            page.nodes[offset] = Node { key, value, epoch, version };
        }
    }

    fn get(&self, global_idx: usize, now: u32, duration: u32) -> Option<&V> {
        let page_idx = global_idx >> SHIFT;
        let offset = global_idx & MASK;
        let node = &self.pages.get(page_idx)?.nodes.get(offset)?;
        if now.saturating_sub(node.epoch) > duration { return None; }
        Some(&node.value)
    }

    fn remove(&mut self, global_idx: usize) {
        let page_idx = global_idx >> SHIFT;
        let offset = global_idx & MASK;
        if page_idx < self.pages.len() {
             let page = Arc::make_mut(&mut self.pages[page_idx]);
             if page.nodes.len() > offset {
                  let old_key = &page.nodes[offset].key;
                  let shard = (self.hasher.hash_one(old_key) as usize) & (SHARD_SIZE - 1);
                  let shard_map = Arc::make_mut(&mut self.index[shard]);
                  shard_map.remove(old_key);
                  page.nodes[offset].epoch = 0;
             }
        }
    }
}

impl<K: Clone, V: Clone> Clone for Cache<K, V> {
    fn clone(&self) -> Self {
        let index = core::array::from_fn(|i| self.index[i].clone());
        Self {
            hasher: self.hasher.clone(),
            index,
            pages: self.pages.clone(),
        }
    }
}

// ─── T1：direct-mapped fixed array，L1 常駐 ───────────────────────────────────
//
// KEY POINT：
//   slot_idx = hash(key) & (PAGE_SIZE - 1)
//   silent eviction 是設計取捨（命中率 vs 延遲）
//   整個 T1 大小 = PAGE_SIZE * sizeof(Option<(K,V)>)
//   目標塞進 L1d（32-64 KB）→ K+V 合計不應超過 ~256 bytes

#[derive(Clone)]
struct T1<V> {
    // 不存 K，只存 V + hash fingerprint 用於防誤命中
    // fingerprint 取 hash 高 16 bits，比對快且省空間
    slots: Vec<Option<(u16, V)>>, // (fingerprint, value)，capacity = PAGE_SIZE
}

impl<V: Clone> T1<V> {
    fn new() -> Self {
        Self {
            slots: vec![None; PAGE_SIZE],
        }
    }

    fn get<K: std::hash::Hash>(&self, key: &K, hasher: &RandomState) -> Option<&V> {
        let h = hasher.hash_one(key);
        let slot = (h as usize) & (PAGE_SIZE - 1);
        let fp = (h >> 48) as u16;
        match &self.slots[slot] {
            Some((stored_fp, v)) if *stored_fp == fp => Some(v),
            _ => None,
        }
    }

    fn insert<K: std::hash::Hash>(&mut self, key: &K, value: V, hasher: &RandomState) {
        let h = hasher.hash_one(key);
        let slot = (h as usize) & (PAGE_SIZE - 1);
        let fp = (h >> 48) as u16;
        self.slots[slot] = Some((fp, value)); // silent eviction
    }
}

// ─── T2：flat vec，version-gated，隨機存取 ────────────────────────────────────
//
// KEY POINT：
//   global_idx 直接作為 index → O(1) 無間接
//   version 內嵌，不需回查 cache.pages                （修正前版雙重讀問題）
//   大小 capacity/5，working set 集中時局部性好

#[derive(Clone)]
struct T2<V> {
    data: Vec<Option<(u16, V)>>, // (version, value)
}

impl<V: Clone> T2<V> {
    fn new(size: usize) -> Self {
        Self {
            data: vec![None; size],
        }
    }

    fn get(&self, global_idx: usize, expected_version: u16) -> Option<&V> {
        match self.data.get(global_idx)?.as_ref() {
            Some((ver, v)) if *ver == expected_version => Some(v),
            _ => None,
        }
    }
}

// ─── Arena ────────────────────────────────────────────────────────────────────

struct Arena {
    records: Vec<Record>,
    ranks: Vec<usize>,   // rank → global_idx
    rev_map: Vec<usize>, // global_idx → rank               -- Inv₄
    evict_point: usize,
    direction: isize,
    count_sum: u32,
    shift_amt: u32,
    capacity: usize,
}

impl Arena {
    fn new(capacity: usize) -> Self {
        let aligned = capacity.next_power_of_two();
        Self {
            records: Vec::with_capacity(capacity),
            ranks: Vec::with_capacity(capacity),
            rev_map: Vec::with_capacity(capacity),
            evict_point: 0,
            direction: 1,
            count_sum: 0,
            shift_amt: aligned.trailing_zeros(),
            capacity,
        }
    }

    fn avg(&self) -> u32 {
        if self.capacity == 0 {
            0
        } else {
            self.count_sum >> self.shift_amt
        }
    }

    fn insert(&mut self, global_idx: usize, epoch: u32) {
        if self.records.len() <= global_idx {
            self.records.resize_with(global_idx + 1, || Record { epoch: 0, count: 0 });
            self.rev_map.resize(global_idx + 1, 0);
        }
        self.records[global_idx] = Record { epoch, count: 0 };
        self.ranks.push(global_idx);
        self.rev_map[global_idx] = self.ranks.len() - 1;
    }

    fn evict(&mut self, now: u32, duration: u32) -> usize {
        let avg = self.avg();
        loop {
            let rank = self.evict_point;
            self.evict_point = (self.evict_point + 1) % self.capacity;
            let global_idx = self.ranks[rank];
            let rec = &mut self.records[global_idx];
            
            if now.saturating_sub(rec.epoch) > duration || rec.count <= (avg as u8) {
                self.count_sum = self.count_sum.saturating_sub(rec.count as u32);
                rec.count = 0;
                rec.epoch = now;
                return global_idx;
            } else {
                rec.count = rec.count.saturating_sub(1);
                self.count_sum = self.count_sum.saturating_sub(1);
            }
        }
    }
}

// ─── Supporting types ─────────────────────────────────────────────────────────

#[derive(Clone)]
enum Action<K, V> {
    Insert(K, V),
    Gets(usize), // single global_idx，由 DualCacheFF 端 buffer 批次
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
    version: u16, // ABA guard，evict 覆寫時 +1
}

// TODO: bench align(64) vs packed on Arena
struct Record {
    epoch: u32,
    count: u8,
}

pub struct Config {
    pub capacity: usize,
    pub duration: u32,
}
