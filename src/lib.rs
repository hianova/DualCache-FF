use std::collections::HashMap;
use std::sync::Arc;

use arc_swap::ArcSwap;

pub struct DualCacheFF<K, V> {
    nodes: Vec<Arc<Node<K, V>>>,
    index: HashMap<K, usize>,
    areana: Paginated,
    mirror: ArcSwap<Paginated>,
    counter: u64,
}
impl<K, V> DualCacheFF<K, V> {
    pub fn new() -> Self {
        let config = Config { capacity: 10 ^ 7 };
        Self::from(config)
    }
    pub fn put(&mut self, key: K, value: V) {}
    pub fn get(&mut self, key: K) {}
}

struct Config {
    capacity: usize,
}
impl<K, V> From<Config> for DualCacheFF<K, V> {
    fn from(config: Config) -> Self {
        Self {
            nodes: Vec::with_capacity(config.capacity),
            index: HashMap::with_capacity(config.capacity),
            areana: Paginated::new(),
            mirror: ArcSwap::from_pointee(Paginated::new()),
            counter: 0,
        }
    }
}

struct Node<K, V> {
    key: K,
    value: V,
    time_stamp: u64,
}
struct Paginated {
    pages: Vec<Page>,
}
impl Paginated {
    fn new() -> Self {
        Self { pages: Vec::new() }
    }
}

struct Page {}
