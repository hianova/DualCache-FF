use ahash::{AHashMap, RandomState};
use arc_swap::ArcSwap;
use crossbeam::channel::{Receiver, Sender};
use std::borrow::Borrow;
use std::sync::Arc;
use std::sync::atomic::AtomicU32;

const SHARD_SIZE: usize = 64;
const PAGE_SIZE: usize = 64;
const SHIFT: usize = 6;
const MASK: usize = 63;

/// # SPEC: Cache config for `DualCacheFF` & `Daemon`
pub struct Config {
    pub capacity: usize, // will align 64 multipul at start
    pub duration: u32,
}
/// # SPEC: Cache mirror for `.get` & modify by push `Action` to channel
#[derive(Clone)]
pub struct DualCacheFF<K, V> {
    view: Arc<ArcSwap<Cache<K, V>>>,
    action_tx: Sender<Action<K, V>>,
    epoch: Arc<AtomicU32>,
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
            // Cache::new(config.capacity)
            // channel::bound(config.capacity)
            // thread::spawn(Daemon.start(config))
        )
    }
    pub fn get(&self, index: usize) -> Option<V> {
        todo!(
        // self.view.get(key) self.action_tx.try_send(Action::Get(key))
        )
    }
    pub fn insert(&self, key: K, value: V) {
        todo!(
        // self.action_tx.try_send(Action::Insert(key, value))
        )
    }
    pub fn remove(&self, index: usize) {
        todo!(
        // self.action_tx.try_send(Action::Remove(key))
        )
    }
    pub fn clear() {
        todo!(
            // self.action_tx.send(Action::Clear)
        )
    }
}
/// # SPEC: Sync cache mirror & recieve `Action` than modify cache
struct Daemon<K, V> {
    view: Arc<ArcSwap<Cache<K, V>>>,
    action_rx: Receiver<Action<K, V>>,
    epoch: Arc<AtomicU32>,
    buffer: AHashMap<Action<K, V>, u32>,
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
/// # SPEC: Search K in index for `nodes` paginated index than high-low bitwise for V
struct Cache<K, V> {
    hasher: RandomState,
    index: [Arc<AHashMap<K, usize>>; SHARD_SIZE],
    pages: Vec<Arc<Page<K, V>>>,
}
impl<K, V> Cache<K, V> {
    fn new(capacity: usize) -> Self {
        todo!(
        // let pages_capacity=if capacity%PAGE_SIZE==0 {(capacity/PAGE_SIZE)+1}else{capacity/PAGE_SIZE};
        // RandomState::new
        // index.with_capacity(SHARD_SIZE)
        // pages.with_capacity(pages_capacity)
        // unsafe { nodes.set_len(PAGE_SIZE); }
        )
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
/// # SPEC: Arena feature count avg and epoch evict standard
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
/// # SPEC: Channel action
#[derive(Clone)]
enum Action<K, V> {
    Get(usize),
    Insert(K, V),
    Remove(usize),
    Clear,
}
/// # SPEC: Page structure
struct Page<K, V> {
    nodes: Vec<Node<K, V>>,
}
/// # SPEC: Node structure
#[derive(Clone)]
struct Node<K, V> {
    key: K,
    value: V,
    epoch: u32,
}
/// # SPEC: Record structure
struct Record {
    index: usize,
    rank: usize,
    epoch: u32,
    count: u8, //overflow extend epoch
}
