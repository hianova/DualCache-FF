mod ai;

use std::borrow::Borrow;
use std::collections::HashMap;
use std::fmt::Debug;
use std::hash::Hash;
use std::sync::Arc;
use std::sync::Mutex;
use std::time::SystemTime;
use std::time::UNIX_EPOCH;

use arc_swap::ArcSwap;
use crossbeam::channel::Receiver;
use crossbeam::channel::Sender;
use crossbeam::channel::bounded;
use tracing::instrument;

#[derive(Clone)]
pub struct Config {
    pub capacity: usize,
    pub duration: u64,
}

#[doc = r#"
# Example

```
use dual_cache_ff::DualCacheFF;

let cache = DualCacheFF::new();

cache.put("A", 100);
cache.put("B", 200);

assert_eq!(cache.get("A"), Some(100);
assert!(cache.get("C").is_none());
```

## Fn `build` customize capacity

```
use dual_cache_ff::{DualCacheFF, Config};

let config = Config {
    capacity: 100, duration: 5000,
};
let (cache,rx) = DualCacheFF::build(config);
thread::spawn(|| {
   cache.daemon(rx);
 });
for i in 0..100 {
    cache.put(i, format!("value_{}", i));
}

assert!(cache.get(0).is_some());
assert!(cache.get(99).is_some());
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
    pub fn new() -> Arc<Self> {
        let config = Config {
            capacity: 100,
            duration: 5, // second
        };
        let (cache, rx) = DualCacheFF::build(config);
        let cache_clone = cache.clone();
        std::thread::spawn(move || {
            cache_clone.daemon(rx);
        });
        cache    
    }

    fn build(config: Config) -> (Arc<Self>, Receiver<K>) {
        let capacity = config.capacity;
        let state = Cache {
            nodes: Vec::with_capacity(capacity),
            index: HashMap::with_capacity(capacity),
            arena: Vec::with_capacity(capacity),
            evict_point: 0,
            lookup_count: 0,
            ring_pointer: 0,
            config,
        };
        let (lazy_tx, rx) = bounded(10_000);

        (
            Arc::new(Self {
                mirror: ArcSwap::from_pointee(state.clone()),
                main: Mutex::new(state),
                lazy_tx,
            }),
            rx,
        )
    }

    #[doc = r#"
    # Feature
    - **First in first out** 
    - **Arena evict probation** 
    - **Count evict probation**

    # Example
    ## First in first out
    struct `cache` field `ring_pointer` loop throw `nodes` to push and overwrite
    ```
    use dual_cache_ff::DualCacheFF;

    ```

    ## Arena evict probation
    struct `cache` field `evict_ponit` index above 
    ```
    use dual_cache_ff::DualCacheFF;

    ```

    ## Count evict probation
    struct `node` field `count` greater than (struct `cache` field `lookup_count`) / (struct `cache` field `capacity`)
    ```
    use dual_cache_ff::DualCacheFF;

    ```
    "#]
    #[instrument(skip(self, value), fields(key = ?key))]
    pub fn put(&self, key: K, value: V) {
        AI!()
    }

    #[doc = r#"
    # Feature
    - **Outdated check** 
    - **Count progress**
    - **Arena progress** 
    - **Count rest**  

    # Example 
    ## Outdated check
    check (`SystemTime::now()` - `node.epoch`) < `cache.epoch_duration`
    ```
    use dual_cache_ff::DualCacheFF;

    ```
    ## Count progress
    `node.count` +1 every call
    ```
    use dual_cache_ff::DualCacheFF;

    ```
    ## Arena progress
    `pagenated.page` move `node` index forward every call
    ```
    use dual_cache_ff::DualCacheFF;

    ```
    ## Count rest
    beyond (cache.lookup_count/cache.capacity) *10  node count will freeze   
    ```
    use dual_cache_ff::DualCacheFF;

    ```  
    "#]
    #[instrument(skip(self), fields(key = ?key))]
    pub fn get<Q>(&self, key: &Q) -> Option<V>
    where
        K: Borrow<Q>,
        Q: Hash + Eq + ?Sized + Debug,
    {
        AI!()
    }

    pub fn daemon(&self, rx: Receiver<K>) {
        // let mut batch_size: u64 = 1024;
        // let mut sma: VecDeque<u64> = VecDeque::with_capacity(5);

        // while let Ok(first_key) = rx.recv() {
        //     let mut state = self.main.lock().unwrap();
        //     let mut processed_count = 0;
        //     let start_epoch = SystemTime::now();

        //     // 將 K 轉換為 usize index 才能 climb
        //     if let Some(&idx) = state.index.get(&first_key) {
        //         state.climb(idx);
        //     }
        //     processed_count += 1;

        //     while processed_count < batch_size {
        //         match rx.try_recv() {
        //             Ok(key) => {
        //                 if let Some(&idx) = state.index.get(&key) {
        //                     state.climb(idx);
        //                 }
        //                 processed_count += 1;
        //             }
        //             Err(_) => break,
        //         }
        //     }

        //     state.lookup_count = state.lookup_count.saturating_add(processed_count as u64);

        //     if state.lookup_count > u64::MAX / 2 {
        //         state.refresh();
        //     }
        //     state.calibrate();

        //     let new_snapshot = Arc::new(state.clone());
        //     self.mirror.store(new_snapshot);

        //     if sma.len() == 5 {
        //         sma.pop_front();
        //     }

        //     // 避免除以 0 的情況
        //     let elapsed_ms = start_epoch.elapsed().unwrap_or_default().as_secs().max(1);
        //     sma.push_back(batch_size / elapsed_ms);

        //     todo!("adjust BATCH_SIZE with SMA if intense batch bigger vise versa")
        // }
    }
}

#[derive(Clone)]
struct Cache<K, V> {
    nodes: Vec<Node<K, V>>,
    index: HashMap<K, usize>,
    arena: Vec<usize>,
    evict_point: usize,
    lookup_count: u64,
    ring_pointer: usize,
    config: Config,
}

impl<K, V> Cache<K, V> {
    fn climb(&mut self, index: usize) {
        self.arena.swap(index, index - 1);
    }

    fn refresh(&mut self) {
        self.lookup_count = 0;
        let epoch = SystemTime::now()
            .duration_since(UNIX_EPOCH)
            .expect("somewhat went wrong")
            .as_secs();

        for nxt in self.nodes.iter_mut() {
            nxt.count = 0;
            nxt.epoch = epoch;
        }
    }

    fn calibrate(&mut self) {
        let prev_idx = self.evict_point.saturating_sub(1);
        let latter_idx = self.evict_point.saturating_add(1);
        let prev_node = self.nodes.get(prev_idx);
        let latter_node = self.nodes.get(latter_idx);
        let capacity = self.config.capacity as u64;

        if let Some(prev) = prev_node {
            if let Some(latter) = latter_node {
                if (self.lookup_count /capacity) < prev.count {
                    self.evict_point = self.evict_point.saturating_sub(1);
                } else if (self.lookup_count / capacity) < latter.count {
                    self.evict_point = self.evict_point.saturating_add(1);
                }
            }
        }
    }

    fn next(&mut self)->usize{
        self.ring_pointer = (self.ring_pointer + 1) % self.config.capacity;
        self.ring_pointer
    }
    fn apply(&mut self,keys: impl IntoIterator<Item = K>){}
}

#[repr(align(128))]
#[derive(Clone)]
struct Node<K, V> {
    key: K,
    value: V,
    epoch: u64,
    count: u64,
}
