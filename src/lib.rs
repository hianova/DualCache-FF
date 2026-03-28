use ahash::AHashMap;
use arc_swap::ArcSwap;
use crossbeam::channel::{Receiver, Sender};
use crossbeam::epoch::Atomic;
use dashmap::DashMap;
use std::borrow::Borrow;
use std::hash::Hash;
use std::sync::Arc;
use std::sync::atomic::AtomicI32;

const PAGE_SIZE: usize = 1024;
const SHIFT: usize = 10;
const MASK: usize = 1023;

/// # SPEC: Cache config for `DualCacheFF` & `Daemon`
pub struct Config {
    pub capacity: usize,
    pub duration: u64,
}
/// # SPEC: Cache mirror for `.get` & modify by push `Action` to channel
#[derive(Clone)]
pub struct DualCacheFF<K, V> {
    view: Arc<ArcSwap<Cache<K, V>>>,
    action_tx: Sender<Action<K, V>>,
    epoch: Arc<AtomicI32>,
}
impl<K, V> DualCacheFF<K, V> {
    pub fn new(config: Config) -> Self {
        todo!(
            "Cache::new(config.capacity) channel::bound(config.capacity) thread::spawn(Daemon.start(config))"
        )
    }
    pub fn get<Q>(&self, key: &Q) -> Option<V>
    where
        K: Borrow<Q>,
        Q: std::hash::Hash + Eq + ?Sized + std::fmt::Debug,
    {
        todo!("self.view.get(key) self.action_tx.try_send(Action::Get(key))")
    }
    pub fn insert(&self, key: K, value: V) {
        todo!("self.action_tx.try_send(Action::Insert(key, value))")
    }
    pub fn remove<Q>(&self, key: &Q)
    where
        K: Borrow<Q>,
        Q: std::hash::Hash + Eq + ?Sized + std::fmt::Debug,
    {
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
    epoch: Arc<AtomicI32>,
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
    index: Arc<AHashMap<K, usize>>,
    nodes: Arc<Vec<Arc<Page<K, V>>>>,
}
impl<K, V> Cache<K, V> {
    fn get<Q>(&self, key: &Q) -> Option<V>
    where
        K: Borrow<Q>,
        Q: std::hash::Hash + Eq + ?Sized + std::fmt::Debug,
    {
        todo!()
    }
    fn put(&self, key: K, value: V) -> usize {
        todo!()
    }
}
/// # SPEC: Arena feature count avg and epoch evict standard
struct Arena {
    records: Vec<usize>,
    rev_map: Vec<usize>,
    counts: Vec<u32>,
    evict_point: usize,
    direction: isize,
    count_sum: u32,
    epoch: Arc<AtomicI32>,
}
impl Arena {
    fn evict_next() -> usize {
        todo!()
    }
    fn hit_swap() {
        todo!()
    }
}
/// # SPEC: Channel action
enum Action<K, V> {
    Get(K),
    Insert(K, V),
    Remove(K),
    Clear,
}
/// # SPEC: Node structure
#[derive(Clone)]
struct Node<K, V> {
    key: K,
    value: V,
    epoch: Arc<AtomicI32>,
}
/// # SPEC: Page structure
struct Page<K, V> {
    nodes: Vec<Node<K, V>>,
}
