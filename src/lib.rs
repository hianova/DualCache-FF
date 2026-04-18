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
pub struct DualCacheFF<K, V> {
    t1: Arc<ArcSwap<T1<V>>>, // direct-mapped, L1-resident
    t2: Arc<ArcSwap<T2<V>>>, // flat vec, promoted from cache
    cache: Arc<ArcSwap<Cache<K, V>>>,
    hasher: RandomState, // shared hasher for T1/T2 slot routing
    action_tx: Sender<Action<K, V>>,
    epoch: Arc<AtomicU32>,
    duration: u32, // TTL秒數，get路徑需要
}

impl<K, V> DualCacheFF<K, V> {
    pub fn build(config: Config) -> (Self, Daemon<K, V>) {
        todo!(
            // PRE:  config.capacity > 0
            // POST: self satisfies Inv₁..Inv₈ at t=0
            //
            // 1. align capacity: capacity = (config.capacity + PAGE_SIZE-1) & !(PAGE_SIZE-1)
            //    debug_assert!(capacity % PAGE_SIZE == 0)                    -- Inv₁
            //
            // 2. build T1/T2:
            //    T1::new()   -- PAGE_SIZE slots fixed array
            //    T2::new(capacity / 5)  -- flat vec, 20% of total
            //
            // 3. build cache:
            //    Cache::new(capacity, hasher.clone())
            //
            // 4. build channel:
            //    crossbeam::channel::bounded(1024)
            //
            // 5. return (DualCacheFF, Daemon)
        )
    }

    pub fn insert(&self, key: K, value: V) {
        todo!(
            // POST: Action::Insert queued; Daemon will apply
            // try_send: drop on backpressure (cache-aside semantics)
        )
    }

    pub fn get(&self, key: &K) -> Option<V>
    where
        K: std::hash::Hash + Eq,
        V: Clone,
    {
        todo!(
            // FAST PATH — T1 (direct-mapped):
            // 1. slot_idx = hasher.hash(key) & (PAGE_SIZE - 1)
            // 2. if t1.load()[slot_idx] matches key → return Some(v.clone())
            //    push HOT_SENTINEL to action_tx
            //
            // FAST PATH — T2 (flat vec, version-gated):
            // 3. slot_idx = hasher.hash(key) & (T2_SIZE - 1)
            // 4. if t2.load()[slot_idx] matches key → return Some(v.clone())
            //
            // SLOW PATH — cache:
            // 5. guard = cache.load()
            // 6. shard_idx = hasher.hash(key) & (SHARD_SIZE - 1)           -- Inv₂
            // 7. global_idx = guard.index[shard_idx].get(key)?
            // 8. page_idx = global_idx >> SHIFT                             -- Inv₃
            //    offset   = global_idx &  MASK
            // 9. node = guard.pages[page_idx].nodes.get(offset)?
            // 10. TTL: now = epoch.load(Relaxed)
            //     if now.saturating_sub(node.epoch) > duration:             -- Inv₅
            //         try_send(Action::Remove(global_idx))
            //         return None
            // 11. try_send(Action::Gets(global_idx))
            // 12. return Some(node.value.clone())
        )
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
        todo!(
            // LOOP invariant: Inv₁..Inv₈ hold at start of every iteration
            //
            // let mut batch = Vec::with_capacity(64);  // 移到 loop 外，重用
            // loop:
            //   batch.clear();
            //   1. recv_timeout(10ms):
            //        Ok(action)   → batch.push; drain try_recv into batch
            //        Err(Timeout) → if queues empty: continue
            //        Err(Disconnect) → break
            //
            //   2. epoch tick:
            //        now = SystemTime seconds (u32)
            //        self.epoch.store(now, Relaxed)                         -- Inv₅
            //
            //   3. compress_action(batch)
            //
            //   4. apply_batch(now)
            //
            //   5. hit_counts.clear()
        )
    }

    fn compress_action(&mut self, batch: Vec<Action<K, V>>) {
        todo!(
            // PRE:  batch is raw Vec<Action>
            // POST: hit_counts accumulated; wait_list populated
            //
            // for action in batch:
            //   Action::Gets(idx) → hit_counts.entry(idx).or_default() += 1
            //   Action::Insert(k,v) →
            //     if wait_list already has same key: replace (keep last)   -- CoW idempotency
            //     else: wait_list.push((k, v))
            //   Action::Remove(idx) → remove_queue.push(idx)
        )
    }

    fn apply_batch(&mut self, now: u32) {
        todo!(
            // 與前版邏輯相同，補充 wait_list → insert_queue drain
            //
            // PHASE 0 — drain wait_list into cache inserts
            // PHASE 1 — hit counts + promotion marks
            // PHASE 2 — climb
            // PHASE 3 — removes
            // PHASE 4 — inserts (from wait_list)
            // PHASE 5 — promote to T2，再從 T2 promote 高頻到 T1
            // PHASE 6 — publish via ArcSwap::store
        )
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
        todo!(
            // debug_assert!(capacity % PAGE_SIZE == 0)
            // index: SHARD_SIZE 個空 AHashMap
            // pages: capacity/PAGE_SIZE 個空 Page
        )
    }

    fn insert(&mut self, key: K, value: V, global_idx: usize, epoch: u32) {
        todo!()
    }

    fn get(&self, global_idx: usize, now: u32, duration: u32) -> Option<&V> {
        todo!(
            // page_idx = global_idx >> SHIFT
            // offset   = global_idx & MASK
            // node = pages[page_idx].nodes[offset]
            // if now.saturating_sub(node.epoch) > duration → None           -- Inv₅
            // Some(&node.value)
        )
    }
}

// ─── T1：direct-mapped fixed array，L1 常駐 ───────────────────────────────────
//
// KEY POINT：
//   slot_idx = hash(key) & (PAGE_SIZE - 1)
//   silent eviction 是設計取捨（命中率 vs 延遲）
//   整個 T1 大小 = PAGE_SIZE * sizeof(Option<(K,V)>)
//   目標塞進 L1d（32-64 KB）→ K+V 合計不應超過 ~256 bytes

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
        todo!(
            // records[global_idx] = Record { epoch, count: 0 }
            // ranks.push(global_idx); rev_map.push(rank)                   -- Inv₄
        )
    }

    fn evict(&mut self, now: u32, duration: u32) -> usize {
        todo!(
            // 鐘擺掃描：expired 或 count <= avg 即驅逐
            // hot 項目 age-down 並繼續掃
        )
    }
}

// ─── Supporting types ─────────────────────────────────────────────────────────

#[derive(Clone)]
enum Action<K, V> {
    Insert(K, V),
    Gets(usize), // single global_idx，由 DualCacheFF 端 buffer 批次
    Remove(usize),
}

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
