mod ai; 

use std::collections::HashMap;
use std::fmt::Debug;
use std::hash::Hash;
use std::mem::MaybeUninit;
use std::sync::{Arc, Mutex};

use arc_swap::ArcSwap;
use crossbeam::channel::{bounded, Sender}; 
use tracing::instrument;

const PAGE_SIZE: usize = 1024;
const _SHIFT: usize = 10;
const _MASK: usize = 1023; 

#[doc = r#"
# Example

```
use dual_cache_ff::DualCacheFF;

let cache = DualCacheFF::new();

cache.put("A", 100);
cache.put("B", 200);

let value = cache.get(&"A").unwrap();
assert_eq!(value, 100);

let result = cache.get(&"C");
assert!(result.is_none());
```

# Fn `from` customize capacity
custom capacity will round to 1024 multiple

```
use dual_cache_ff::{DualCacheFF, Config};

let config = Config {
    capacity: 100,
};
let cache = DualCacheFF::from(config);

for i in 0..1024 {
    cache.put(i, format!("value_{}", i));
}

assert!(cache.get(&0).is_none());
assert!(cache.get(&1023).is_some());
```"#]
#[repr(align(128))]
pub struct DualCacheFF<K, V> {
    main: Mutex<Cache<K, V>>,
    mirror: ArcSwap<Cache<K, V>>,
    lazy_tx: Sender<K>,
}

impl<K, V> DualCacheFF<K, V>
where
    K: Hash + Eq + Clone + Send + Sync + 'static + Debug,
    V: Clone + Send + Sync + 'static + Debug,
{
    pub fn new() -> Self {
        Self::default()
    }

    #[doc = r#"將鍵值對放入緩存 (透過 Mutex 或 Channel 異步處理)"#]
    #[instrument(skip(self, value), fields(key = ?key))]
    pub fn put(&self, key: K, value: V) -> Option<()> {
        AI!()
    }

    #[doc = r#"從唯讀快照中獲取緩存，並發送 Lazy Read 訊號"#]
    #[instrument(skip(self), fields(key = ?key))]
    pub fn get(&self, key: &K) -> Option<V> { 
        AI!()
    }
}

pub struct Config {
    pub capacity: usize,
}

impl<K, V> Default for DualCacheFF<K, V>
where
    K: Hash + Eq + Clone + Send + Sync + 'static + Debug,
    V: Clone + Send + Sync + 'static + Debug,
{
    fn default() -> Self {
        Config { capacity: PAGE_SIZE }.into()
    }
}

impl<K, V> From<Config> for DualCacheFF<K, V>
where
    K: Hash + Eq + Clone + Send + Sync + 'static + Debug,
    V: Clone + Send + Sync + 'static + Debug,
{
    fn from(config: Config) -> Self {
        let capacity = if config.capacity < PAGE_SIZE {
            PAGE_SIZE
        } else if config.capacity % PAGE_SIZE == 0 {
            config.capacity
        } else {
            config.capacity + (PAGE_SIZE - (config.capacity % PAGE_SIZE))
        };
        let paginated_count = capacity / PAGE_SIZE;
        let state = Cache {
            nodes: Vec::with_capacity(capacity),
            index: HashMap::with_capacity(capacity),
            arena: Paginated::from(paginated_count),
            lookup_count: 0,
            ring_pointer: 0,
        };
        let (lazy_tx, _lazy_rx) = bounded(10_000);

        Self {
            mirror: ArcSwap::from_pointee(state.clone()),
            main: Mutex::new(state),
            lazy_tx,
        }
    }
}

#[derive(Clone)]
struct Cache<K, V> {
    nodes: Vec<Node<K, V>>,
    index: HashMap<K, usize>,
    arena: Paginated,
    lookup_count: u64,
    ring_pointer: usize,
}

#[repr(align(128))]
#[derive(Clone)]
struct Node<K, V> { 
    key: K,
    value: V,
    epoch: u64,
    counter: u64,
}

#[derive(Clone)]
struct Paginated {
    pages: Vec<Page>,
    len: usize,
}

impl Paginated {
    fn new() -> Self {
        Self::from(PAGE_SIZE)
    }
}

impl From<usize> for Paginated {
    fn from(value: usize) -> Self {
        Self {
            pages: Vec::with_capacity(value),
            len: value,
        }
    }
}

struct Page {
    data: [usize; PAGE_SIZE],
}

impl Clone for Page {
    fn clone(&self) -> Self {
        let mut new_page: MaybeUninit<Page> = MaybeUninit::uninit();
        unsafe {
            std::ptr::copy_nonoverlapping(
                &self.data as *const usize,
                new_page.as_mut_ptr() as *mut usize,
                PAGE_SIZE,
            );
            new_page.assume_init()
        }
    }
}
