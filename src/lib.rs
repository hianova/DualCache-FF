use ahash::AHashMap;
use arc_swap::ArcSwap;
use crossbeam::channel::{Receiver, Sender};
use std::borrow::Borrow;
use std::sync::Arc;
use std::sync::atomic::AtomicU32;

const PAGE_SIZE: usize = 128;
const SHIFT: usize = 7;
const MASK: usize = 127;

/// # SPEC: Cache config for `DualCacheFF` & `Daemon`
pub struct Config {
    pub capacity: usize, // will align 128 multipul at start
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
    pub fn new(config: Config) -> Self {
        todo!(
            "Cache::new(config.capacity) channel::bound(config.capacity) thread::spawn(Daemon.start(config))"
        )
    }
    pub fn get(&self, index: usize) -> Option<V> {
        todo!("self.view.get(key) self.action_tx.try_send(Action::Get(key))")
    }
    pub fn insert(&self, key: K, value: V) {
        todo!("self.action_tx.try_send(Action::Insert(key, value))")
    }
    pub fn remove(&self, index: usize) {
        todo!("self.action_tx.try_send(Action::Remove(key))")
    }
    pub fn clear() {
        todo!("self.action_tx.send(Action::Clear)")
    }
}
/// # SPEC: Sync cache mirror & recieve `Action` than modify cache
struct Daemon<K, V> {
    view: Arc<ArcSwap<Cache<K, V>>>,
    action_rx: Receiver<Action<K, V>>,
    epoch: Arc<AtomicU32>,
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
    index: AHashMap<K, usize>,
    pages: Vec<Page<K, V>>,
}
impl<K, V> Cache<K, V> {
    fn get(&self, index: usize) -> Option<V> {
        todo!()
    }
    fn put(&self, key: K, value: V, target: usize) -> usize {
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
    ranks: Vec<Record>,
    rev_map: Vec<usize>,
    count_sum: u32,
    evict_point: usize,
    direction: isize,
}
impl Arena {
    fn get(&self) -> Option<usize> {
        todo!()
    }
    fn put(&self) -> usize {
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
enum Action<K, V> {
    Get(usize),
    Insert(K, V),
    Remove(usize),
    Clear,
}
/// # SPEC: Node structure
#[derive(Clone)]
struct Node<K, V> {
    key: K,
    value: V,
    epoch: u32,
}
/// # SPEC: Page structure
struct Page<K, V> {
    nodes: Vec<Node<K, V>>,
}
/// # SPEC: Record structure
struct Record {
    index: usize,
    count: u8,
    epoch: u32,
}
