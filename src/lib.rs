use ahash::{AHashMap, RandomState};
use arc_swap::ArcSwap;
use crossbeam::channel::{Receiver, Sender};
use std::sync::Arc;
use std::sync::atomic::AtomicU32;

const SHARD_SIZE: usize = 64;
const PAGE_SIZE: usize = 64;
const SHIFT: usize = 6;
const MASK: usize = 63;

// # SPEC:
// `get` will check hot_cache first for L1 cache hit then check `cold_cache` if not.
// After functions called will ring buffer with `buffer_point` store `Action` to `buffer`,
// and `try_send` when `buffer` reach capacity.
#[derive(Clone)]
pub struct DualCacheFF<K, V> {
    hot_cache: Arc<ArcSwap<AHashMap<K, V>>>,
    cold_cache: Arc<ArcSwap<Cache<K, V>>>,
    action_tx: Sender<Vec<Action<K, V>>>,
    buffer: Vec<Action<K, V>>,
    buffer_point: usize,
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
        todo!()
    }
    pub fn insert(&self, key: K, value: V) {
        todo!()
    }
    pub fn get(&self, index: usize) -> Option<V> {
        todo!()
    }
    pub fn remove(&self, index: usize) {
        todo!()
    }
    pub fn clear() {
        todo!()
    }
}
// # SPEC:
// `hot_cache` is promoted from `cold_cache` for `record.count` over `Arena` count average,
// `action_rx` will recieve batch `Action` need to compress_action than `apply_batch` to cold_cache
// `epoch` update periodly which stamp `record.epoch` and `DualCacheFF.get` expire check
// `buffer` holds `Action` for `compress_action` and `apply_batch`
// `arena` decide evict data for new insert and promotion to `hot_cache`
struct Daemon<K, V> {
    hot_cache: Arc<ArcSwap<AHashMap<K, V>>>,
    cold_cache: Arc<ArcSwap<Cache<K, V>>>,
    action_rx: Receiver<Vec<Action<K, V>>>,
    epoch: Arc<ArcSwap<AtomicU32>>,
    buffer: AHashMap<usize, u32>,
    arena: Arena,
}
impl<K, V> Daemon<K, V> {
    fn start(&self, config: Config) {
        todo!()
    }
    fn compress_action(&self) {
        todo!()
    }
    fn apply_batch(&self) {
        todo!()
    }
}
// # SPEC:
// `hasher` hash key route to `index`, which stores `pages` pagenated fixed adderess.
// `get` will check `epoch` for expired
struct Cache<K, V> {
    hasher: RandomState,
    index: [Arc<AHashMap<K, usize>>; SHARD_SIZE],
    pages: Vec<Arc<Page<K, V>>>,
    epoch: Arc<ArcSwap<AtomicU32>>,
}
impl<K, V> Cache<K, V> {
    fn new(capacity: usize) -> Self {
        todo!()
    }
    fn insert(&self, key: K, value: V, target: usize) -> usize {
        todo!()
    }
    fn get(&self, index: usize) -> Option<V> {
        todo!()
    }
    fn remove(&self, index: usize) {
        todo!()
    }
    fn clear(&self) {
        todo!()
    }
}
// # SPEC:
// `records` route `cold_cache.pages` fixed address and `ranks` dynamic address,
// also hold epoch and count for `evict_point` to decide evict .
// `direction` will decide evict direction, `count_sum` will syncronize add up while lookup
struct Arena {
    records: Vec<Record>,
    ranks: Vec<usize>,
    evict_point: usize,
    direction: isize,
    count_sum: u32,
}
impl Arena {
    fn insert(&self) -> usize {
        todo!()
    }
    fn get(&self) -> Option<usize> {
        todo!()
    }
    fn remove(&self) {
        todo!()
    }
    fn clear(&self) {
        todo!()
    }
}
#[derive(Clone)]
enum Action<K, V> {
    Insert(K, V),
    Get(usize),
    Remove(usize),
    Clear,
}
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
