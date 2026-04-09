use ahash::{AHashMap, RandomState};
use arc_swap::ArcSwap;
use crossbeam::channel::{Receiver, Sender};
use std::sync::Arc;
use std::sync::atomic::AtomicU32;

const SHARD_SIZE: usize = 64;
const PAGE_SIZE: usize = 64;
const SHIFT: usize = 6;
const MASK: usize = 63;

// ─── Lean-style invariants (checked at runtime in debug, static in release) ───
//
// Inv₁ (capacity alignment):   capacity % PAGE_SIZE = 0
// Inv₂ (shard routing):        shard_idx = hash(key) & (SHARD_SIZE-1)
//                               ∀ k. index[shard(k)].contains(k) ↔ cold_cache contains k
// Inv₃ (global index):         global_idx = page_idx * PAGE_SIZE + offset
//                               page_idx  = global_idx >> SHIFT
//                               offset    = global_idx &  MASK
// Inv₄ (arena↔page bijection): ∀ r ∈ records. pages[r.index>>SHIFT][r.index&MASK] is valid
//                               ∀ r. ranks[rev_map[r]] = r   (round-trip)
// Inv₅ (epoch monotone):       epoch only increments, never wraps within duration window
// Inv₆ (hot⊆cold):             ∀ k ∈ hot_cache. ∃ k ∈ cold_cache
//                               hot eviction must also update cold_cache index
// Inv₇ (get_buffer ring):      buffer_point < buffer.capacity()
//                               buffer is flushed before overwrite (send before wrap)
// Inv₈ (count_sum):            count_sum = Σ records[i].count  (maintained incrementally)
// ──────────────────────────────────────────────────────────────────────────────

// # SPEC:
// `get` will check hot_cache first for L1 cache hit then check `cold_cache` if not.
// After functions called will ring buffer with `buffer_point` store `Action` to `buffer`,
// and `try_send` when `buffer` reach capacity.
pub struct DualCacheFF<K, V> {
    t1: Arc<ArcSwap<AHashMap<K, V>>>, // promote from t2 when count overflow
    t2: Arc<ArcSwap<t2<V>>>,          //promote from view when count above avg
    cache: Arc<ArcSwap<Cache<K, V>>>,
    action_tx: Sender<Action<K, V>>,
    epoch: Arc<AtomicU32>, // Daemon 寫，前端 Relaxed 讀
    duration: u32,
    get_buffer: GetBuffer,       // 私有，只装 Get(global_idx) dont use Mutex
    negative_ring: NegativeRing, // filter out negative get
}

impl<K, V> DualCacheFF<K, V> {
    /// ```
    /// use dualcache_ff::DualCacheFF;
    ///
    /// let cache = DualCacheFF::new(Config{capacity:128,duration:100});
    /// cache.insert("A",1);
    /// dbg!(cache);
    /// assert!(cache.get("A").is_some());
    /// cache.remove("A");
    /// dbg!(cache);
    /// assert!(cache.get("A").is_none());
    /// ```
    pub fn new(config: Config) -> Self {
        todo!(
            // PRE:  config.capacity > 0
            // POST: self satisfies Inv₁..Inv₈ at t=0
            //
            // 1. align capacity: capacity = (config.capacity + PAGE_SIZE-1) & !(PAGE_SIZE-1)
            //    debug_assert!(capacity % PAGE_SIZE == 0)                    -- Inv₁
            //
            // 2. build hot_cache:
            //    hot_cap = capacity / 10   (10% of total, fits L1/L2)
            //    AHashMap::with_capacity(hot_cap)
            //    Arc::new(ArcSwap::from_pointee(hot_map))
            //
            // 3. build cold_cache:
            //    Cache::new(capacity)      -- see Cache::new flow
            //    Arc::new(ArcSwap::from_pointee(cold))
            //
            // 4. build channel:
            //    crossbeam::channel::bounded(1024)   -- channel carries Action, bounded
            //    buffer capacity = capacity / 10  -- get batch buffer size
            //    buffer_point = 0
            //
            // 5. spawn Daemon:
            //    thread::spawn(move || daemon.start(config))
            //
            // 6. return Self { hot_cache, cold_cache, action_tx, epoch, duration, get_buffer, buffer_point:0 }
        )
    }
    /// This function may block thread if occur back pressure
    pub fn insert(&self, key: K, value: V) {
        todo!(
            // PRE:  (none — insert is always valid, eviction handles capacity)
            // POST: Action::Insert(key,value) queued; Daemon will apply to cold_cache
            //       and possibly promote to hot_cache if count qualifies
            //
            // 1. 直接 try_send(Action::Insert(key, value))，丟掉就丟掉，快取語義允許
        )
    }

    pub fn get(&self, key: &K) -> Option<V> {
        todo!(
            // PRE:  (none)
            // POST: returns Some(v) iff key exists and epoch not expired
            //       Action::Gets(buffer) queued for Daemon count update
            //
            // FAST PATH — hot_cache (L1/L2 hit):
            // 1. guard = hot_cache.load()              -- wait-free ArcSwap load
            // 2. if let Some(v) = guard.get(key):
            //        push HOT_SENTINEL to get_buffer   -- signal hot hit
            //        flush get_buffer if full          -- try_send(Action::Gets), then clear
            //        return Some(v.clone())
            //
            // SLOW PATH — cold_cache (L3):
            // 3. cold_guard = cold_cache.load()        -- wait-free ArcSwap load
            // 4. shard_idx = cold_guard.hasher.hash(key) & (SHARD_SIZE-1)   -- Inv₂
            // 5. global_idx = cold_guard.index[shard_idx].get(key)?
            // 6. page_idx = global_idx >> SHIFT                              -- Inv₃
            // 7. offset   = global_idx &  MASK                               -- Inv₃
            // 8. node = cold_guard.pages[page_idx].nodes.get(offset)?
            // 9. epoch check:
            //        now = self.epoch.load(Relaxed)
            //        if now - node.epoch > self.duration:                    -- Inv₅
            //            try_send(Action::Remove(global_idx))
            //            return None
            // 10. push global_idx to get_buffer
            // 11. flush get_buffer if full             -- Inv₇:try_send(Action::Gets), then clear
            // 12. return Some(node.value.clone())
        )
    }

    /// This function will block thread
    pub fn remove(&self, key: &K) {
        todo!(
            // PRE:  (none — remove on missing key is a no-op at Daemon side)
            // POST: Action::Remove queued; Daemon will delete from cold and hot
            //
            // 1. cold_guard = cold_cache.load()
            // 2. shard_idx  = cold_guard.hasher.hash(key) & (SHARD_SIZE-1)
            // 3. global_idx = cold_guard.index[shard_idx].get(key)?  -- None → return
            // 4. send(Action::Remove(global_idx))
        )
    }

    /// This function will block thread
    pub fn clear(&self) {
        todo!(
            // POST: Action::Clear queued; Daemon will clear both hot and cold
            //
            // 1. send(Action::Clear)
        )
    }
}

// # SPEC:
// `hot_cache` is promoted from `cold_cache` for `record.count` over `Arena` count average,
// `action_rx` will recieve batch `Action` need to compress_action than `apply_batch` to cold_cache
// `epoch` update periodly which stamp `record.epoch` and `DualCacheFF.get` expire check
// `buffer` holds `Action` for `compress_action` and `apply_batch`
// `arena` decide evict data for new insert and promotion to `hot_cache`
struct Daemon<K, V> {
    t1: Arc<ArcSwap<AHashMap<K, V>>>,
    t2: Arc<ArcSwap<t2<V>>>,
    cache: Arc<ArcSwap<Cache<K, V>>>,
    action_rx: Receiver<Action<K, V>>,
    epoch: Arc<AtomicU32>,
    hit_counts: AHashMap<usize, u32>, // batch 間複用，減少重複分配
    arena: Arena,
}

impl<K, V> Daemon<K, V> {
    fn start(&mut self, config: Config) {
        todo!(
            // LOOP invariant: Inv₁..Inv₈ hold at start of every iteration
            //
            // loop:
            //   1. recv_timeout(10ms):
            //        Ok(action)   → collect action, then try_recv remaining into batch
            //        Err(timeout) → if hit_counts non-empty, still apply (step 4-6)
            //                       else continue
            //
            //   2. epoch tick:
            //        now = SystemTime seconds since CACHE_START (u32, Inv₅)
            //        self.epoch.store(now, Relaxed)
            //   TODO: make GET independent apply from others avoid Arc::make_mut
            //   3. compress_action(batch)   -- populate hit_counts, collect Insert/Remove
            //
            //   4. apply_batch()            -- mutate cold_cache, arena, hot_cache
            //
            //   5. hit_counts.clear()
            //
            //   6. ArcSwap::store on cold_cache and hot_cache if modified
            //      debug_assert!(Inv₄)     -- arena↔page bijection still holds
        )
    }

    fn compress_action(&mut self, batch: Vec<Action<K, V>>) {
        todo!(
            // PRE:  batch is the raw Vec<Action> received from channel
            // POST: self.hit_counts[idx] = Σ weights of Gets(idx) in batch
            //       structural actions (Insert/Remove/Clear) preserved in order
            //
            // 1. for action in batch:
            //      Action::Gets(idxs)     → for idx in idxs: hit_counts.entry(idx).or_default() += 1
            //      Action::Insert(k,v)    → push to insert_queue (local Vec)
            //      Action::Remove(idx)    → push to remove_queue (local Vec)
            //      Action::Clear          → clear both queues, hit_counts.clear(), mark clear=true
            //
            // NOTE: if clear=true all prior actions in this batch are void -- Inv₆
            // NOTE: consecutive Insert(k,_) for same k → keep only last (CoW idempotency)
        )
    }

    fn apply_batch(&mut self) {
        todo!(
            // PRE:  hit_counts populated, insert/remove queues ready
            // POST: cold_cache view updated, hot_cache view updated, arena consistent
            //       Inv₄ holds, Inv₆ holds, Inv₈ holds
            //
            // PHASE 1 — apply hit counts to arena:
            // 1. for (global_idx, weight) in hit_counts:
            //        record = &mut arena.records[global_idx]
            //        record.count = record.count.saturating_add(weight as u8)
            //        arena.count_sum += weight                               -- Inv₈
            //        avg = arena.count_sum >> arena.shift_amt as u32
            //        if record.count as u32 > avg * PROMOTE_THRESHOLD:
            //            mark global_idx for promotion
            //
            // PHASE 2 — climb (batch swap):
            // 2. collect all (global_idx, count) that need climb, sort by count desc
            // 3. for each, swap ranks[rev_map[idx]] with ranks[rev_map[idx]-1]
            //    update rev_map for both swapped entries                     -- Inv₄
            //
            // PHASE 3 — apply removes:
            // 4. for global_idx in remove_queue:
            //        shard = cold_cache.index shard containing global_idx
            //        Arc::make_mut(shard).remove(key)                       -- COW shard only
            //        arena.remove(global_idx)                               -- Inv₄
            //        arena.count_sum -= record.count                        -- Inv₈
            //        if key in hot_cache: Arc::make_mut(hot_cache).remove(key) -- Inv₆
            //
            // PHASE 4 — apply inserts:
            // 5. for (key, value) in insert_queue:
            //        if cold_cache.len < capacity:
            //            global_idx = next free slot
            //        else:
            //            global_idx = arena.evict()    -- find victim via pendulum
            //            evicted_key = pages[victim].key
            //            Arc::make_mut(index[shard(evicted_key)]).remove(evicted_key)
            //            if evicted_key in hot_cache: remove from hot   -- Inv₆
            //        page_idx = global_idx >> SHIFT                        -- Inv₃
            //        offset   = global_idx &  MASK
            //        Arc::make_mut(pages[page_idx])[offset] = Node{key,value,epoch}  -- COW page
            //        Arc::make_mut(index[shard(key)]).insert(key, global_idx)        -- COW shard
            //        arena.insert(global_idx, epoch)                       -- Inv₄
            //
            // PHASE 5 — promote to hot_cache:
            // 6. for global_idx in promote_set:
            //        node = pages[page_idx][offset]
            //        Arc::make_mut(hot_cache).insert(node.key, node.value) -- Inv₆
            //        if hot_cache.len > hot_capacity:
            //            evict lowest-count key from hot (check arena.records)
            //
            // PHASE 6 — publish:
            // 7. cold_cache ArcSwap::store(Arc::new(updated_cache))
            // 8. hot_cache  ArcSwap::store(Arc::new(updated_hot))
        )
    }
}

// # SPEC:
// `hasher` hash key route to `index`, which stores `pages` pagenated fixed address.
// `get` will check `epoch` for expired
struct Cache<K, V> {
    hasher: RandomState,
    index: [Arc<AHashMap<K, usize>>; SHARD_SIZE],
    pages: Vec<Arc<Page<K, V>>>,
}

impl<K, V> Cache<K, V> {
    fn new(capacity: usize) -> Self {
        todo!(
            // PRE:  capacity % PAGE_SIZE == 0                               -- Inv₁
            // POST: index has SHARD_SIZE empty shards
            //       pages has capacity/PAGE_SIZE empty pages
            //
            // 1. debug_assert!(capacity % PAGE_SIZE == 0)
            // 2. hasher = RandomState::new()
            // 3. index = array_init(|| Arc::new(AHashMap::with_capacity(capacity/SHARD_SIZE)))
            // 4. pages_cap = capacity / PAGE_SIZE
            //    pages = (0..pages_cap).map(|_| Arc::new(Page { nodes: Vec::with_capacity(PAGE_SIZE) }))
            //    -- 讓 Daemon 在 insert 時 push，page 未滿的 slot 根本不存在
        )
    }

    fn insert(&mut self, key: K, value: V, global_idx: usize) {
        todo!(
            // PRE:  global_idx < capacity                                   -- Inv₃
            //       called only from Daemon::apply_batch                    -- single writer
            // POST: index[shard(key)] maps key → global_idx
            //       pages[page_idx][offset] = Node{key,value,epoch}
            //
            // 1. shard_idx = hasher.hash(key) & (SHARD_SIZE-1)             -- Inv₂
            // 2. Arc::make_mut(&mut index[shard_idx]).insert(key, global_idx)  -- COW shard
            // 3. page_idx = global_idx >> SHIFT                             -- Inv₃
            //    offset   = global_idx &  MASK
            // 4. let nodes = &mut Arc::make_mut(&mut pages[page_idx]).nodes
            //    if offset == nodes.len() {
            //        nodes.push(Node { key, value, epoch: current_epoch })
            //    } else {
            //        nodes[offset] = Node { key, value, epoch: current_epoch }
            //    }
        )
    }

    fn get(&self, global_idx: usize, now: u32, duration: u32) -> Option<&V> {
        todo!(
            // PRE:  global_idx < capacity
            // POST: None if epoch expired (Inv₅), Some(&v) otherwise
            //
            // 1. page_idx = global_idx >> SHIFT
            //    offset   = global_idx &  MASK
            // 2. node = &pages[page_idx].nodes[offset]
            // 3. if now.saturating_sub(node.epoch) > duration: return None  -- Inv₅
            // 4. return Some(&node.value)
        )
    }

    fn remove(&mut self, global_idx: usize, key: &K) {
        todo!(
            // PRE:  global_idx valid, key matches node at global_idx        -- Inv₄
            //       called only from Daemon                                  -- single writer
            // POST: index[shard(key)] no longer contains key                -- Inv₂
            //       page slot epoch set to 0 (tombstone)
            //
            // 1. shard_idx = hasher.hash(key) & (SHARD_SIZE-1)
            // 2. Arc::make_mut(&mut index[shard_idx]).remove(key)           -- COW shard
            // 3. page_idx = global_idx >> SHIFT
            //    offset   = global_idx &  MASK
            // 4. Arc::make_mut(&mut pages[page_idx]).nodes[offset].epoch = 0  -- tombstone
            //    NOTE: no need to zero key/value; Arena will overwrite on next insert
        )
    }

    fn clear(&mut self) {
        todo!(
            // POST: all shards empty, all page epochs = 0
            //       Inv₁ preserved (capacity unchanged)
            //
            // 1. for shard in index.iter_mut():
            //        Arc::make_mut(shard).clear()                           -- COW each shard
            // 2. for page in pages.iter_mut():
            //        Arc::make_mut(page).nodes.iter_mut()
            //            .for_each(|n| n.epoch = 0)                        -- tombstone all
        )
    }
}

// # SPEC:
// `records` route `cold_cache.pages` fixed address and `ranks` dynamic address,
// also hold epoch and count for `evict_point` to decide evict.
// `direction` will decide evict direction, `count_sum` will syncronize add up while lookup
struct Arena {
    records: Vec<Record>, // physical_idx → Record (fixed address, never moves)
    ranks: Vec<usize>,    // rank → physical_idx   (sorted by frequency, mutated by climb)
    evict_point: usize,   // current pendulum position in ranks
    direction: isize,     // +1 forward / -1 backward
    count_sum: u32,
    shift_amt: u32, // avg divide with 2 multiple approximation capacity
}

impl Arena {
    fn insert(&mut self, global_idx: usize, epoch: u32) -> usize {
        todo!(
            // PRE:  global_idx is a free slot (either new or evicted)
            // POST: records[global_idx] initialised
            //       ranks tail updated, rev_map updated                     -- Inv₄
            //       returns global_idx (caller already knows it, for chaining)
            //
            // 1. records[global_idx] = Record { index: global_idx, rank: ranks.len(),
            //                                   epoch, count: 0 }
            //    NOTE: rank starts at tail — new data gets a chance before eviction
            // 2. ranks.push(global_idx)
            // 3. rev_map.push(ranks.len()-1)                               -- Inv₄ round-trip
        )
    }

    fn evict(&mut self, now: u32, duration: u32) -> usize {
        todo!(
            // PRE:  ranks.len() == capacity  (called only when full)
            // POST: returns physical_idx of victim
            //       victim's count subtracted from count_sum                -- Inv₈
            //       evict_point advanced by direction, direction flipped if wall hit
            //
            // LOOP (pendulum scan):
            // 1. physical_idx = ranks[evict_point]
            //    record = &mut records[physical_idx]
            // 2. if now.saturating_sub(record.epoch) > duration:           -- expired
            //        advance evict_point; return physical_idx
            // 3. avg = count_sum >> shift_amt as u32
            //    if record.count <= avg:                                    -- cold enough
            //        count_sum -= record.count as u32                      -- Inv₈
            //        record.count = 0
            //        advance evict_point; return physical_idx
            // 4. else (hot, spare):
            //        record.count = record.count.saturating_sub(avg as u8) -- age down
            //        count_sum    = count_sum.saturating_sub(avg)          -- Inv₈
            //        flip direction; advance evict_point; continue loop
            //
            // advance evict_point:
            //   next = evict_point as isize + direction
            //   if next < 0          → next = 1; direction = 1
            //   if next >= capacity  → next = capacity-2; direction = -1
            //   evict_point = next as usize
        )
    }

    fn remove(&mut self, physical_idx: usize) {
        todo!(
            // PRE:  physical_idx < records.len()
            // POST: record zeroed (count=0, epoch=0)
            //       ranks entry teleported to evict_point region so next
            //       insert can reuse the slot without a scan               -- Inv₄
            //
            // 1. rank_of_deleted = records[physical_idx].rank  (via rev_map)
            // 2. if rank_of_deleted != evict_point:
            //        swap ranks[rank_of_deleted] with ranks[evict_point]
            //        update rev_map for both                               -- Inv₄
            // 3. count_sum -= records[physical_idx].count as u32          -- Inv₈
            // 4. records[physical_idx].count = 0
            //    records[physical_idx].epoch = 0
        )
    }

    fn clear(&mut self) {
        todo!(
            // POST: records all zeroed, ranks cleared, evict_point=0,
            //       direction=1, count_sum=0                               -- Inv₈
            //
            // 1. records.iter_mut().for_each(|r| { r.count=0; r.epoch=0; })
            // 2. ranks.clear()
            // 3. evict_point=0; direction=1; count_sum=0
        )
    }
}
#[derive(Clone)]
enum Action<K, V> {
    Insert(K, V),
    Gets(Vec<usize>), // batch gets 降低 channel 壓力
    Remove(usize),
    Clear,
}
struct t2<V> {
    data: Vec<Option<(u32, V)>>,
}
struct Page<K, V> {
    nodes: Vec<Node<K, V>>,
}
#[derive(Clone)]
struct Node<K, V> {
    key: K,
    value: V,
    epoch: u32,   // 只管 TTL，epoch extend 隨便動
    vertion: u16, // 只管 ABA，每次 evict 覆寫 +1，晉升不動
}
//1. TTL 判斷：now - node.epoch > duration → 過期
//2. ABA 防護：L2[idx].epoch != L3[idx].epoch → 髒讀
#[repr(align(64))]
struct Record {
    index: usize, // → global_idx in pages (fixed)
    rank: usize,  // current rank (mirrored in rev_map, updated by climb)
    epoch: u32,
    count: u8, // saturating; overflow extends via epoch comparison
}
#[repr(align(64))]
pub struct Config {
    pub capacity: usize,
    pub duration: u32,
}

struct GetBuffer {
    buffer: crossbeam::queue::ArrayQueue<usize>,
    point: usize,
}
struct NegativeRing {
    ring: [AtomicU32; 1024],
    point: usize,
}
