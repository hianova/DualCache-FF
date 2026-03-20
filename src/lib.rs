use std::{collections::VecDeque, sync::Arc};

use ahash::AHashMap;
use anyhow::Result;
use arc_swap::ArcSwap;
use crossbeam::channel::{Receiver, Sender};

pub struct DualCacheFF<K, V> {
    view: ArcSwap<Cache<K, V>>,
    action_tx: Sender<Action<K, V>>,
}

struct Daemon<K, V> {
    pool: VecDeque<Arc<Cache<K, V>>>,
    action_rx: Receiver<Action<K, V>>,
}

impl<K, V> DualCacheFF<K, V>
where
    K: std::hash::Hash + Eq + Clone + Send + Sync + 'static,
    V: Clone + Send + Sync + 'static,
{
    pub fn new(config: Config) -> Self {
        let caches: [Arc<Cache<K, V>>; 5] =
            std::array::from_fn(|_| Arc::new(Cache::new(config.capacity.clone())));
        let view = ArcSwap::new(caches[0].clone());
        let pool = VecDeque::from(caches);
        let (action_tx, action_rx) = crossbeam::channel::bounded(config.capacity.clone());
        let mut daemon = Daemon { pool, action_rx };

        std::thread::spawn(move || {
            daemon.run(config);
        });
        Self { view, action_tx }
    }

    pub fn put(&self, key: K, value: V) -> Result<()> {
        self.action_tx.try_send(Action::Put(key, value))?;
        Ok(())
    }

    pub fn get(&self, key: K) -> Option<V> {
        let view = self.view.load();
        if let Some(&index) = view.index.get(&key) {
            if let Some(&node_idx) = view.arena.get(index) {
                self.action_tx.try_send(Action::Get(key)).ok()?;
                return Some(view.nodes[node_idx].value.clone());
            }
        }
        None
    }

    pub fn evict(&self, key: K) -> Result<()> {
        self.action_tx.try_send(Action::Evict(key))?;
        Ok(())
    }

    pub fn clear(&self) -> Result<()> {
        self.action_tx.send(Action::Clear)?;
        Ok(())
    }
}

impl<K, V> Daemon<K, V>
where
    K: std::hash::Hash + Eq + Clone + Send + Sync + 'static,
    V: Clone + Send + Sync + 'static,
{
    pub fn run(&mut self, config: Config) {}
}

struct Cache<K, V> {
    index: AHashMap<K, usize>,
    arena: Vec<usize>,
    nodes: Vec<Node<K, V>>,
}

impl<K, V> Cache<K, V>
where
    K: std::hash::Hash + Eq + Clone,
    V: Clone,
{
    fn new(capacity: usize) -> Self {
        Self {
            index: AHashMap::with_capacity(capacity),
            arena: Vec::with_capacity(capacity),
            nodes: Vec::with_capacity(capacity),
        }
    }
}

enum Action<K, V> {
    Put(K, V),
    Get(K),
    Evict(K),
    Epoch(u64),
    Clear,
}

struct Node<K, V> {
    key: K,
    value: V,
    epoch: u64,
    count: u64,
}

pub struct Config {
    pub capacity: usize,
    pub duration: u64,
}
