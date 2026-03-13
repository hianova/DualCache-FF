mod ai;

use std::borrow::Borrow;
use std::collections::HashMap;
use std::collections::VecDeque;
use std::fmt::Debug;
use std::hash::Hash;
use std::mem::MaybeUninit;
use std::sync::Arc;
use std::sync::Mutex;
use std::thread;
use std::time::UNIX_EPOCH;
use std::time::SystemTime;

use arc_swap::ArcSwap;
use crossbeam::channel::bounded;
use crossbeam::channel::Receiver;
use crossbeam::channel::Sender;
use tracing::instrument;

const PAGE_SIZE: usize = 1024;
const SHIFT: usize = 10;
const MASK: usize = 1023;

pub struct Config {
    pub capacity: usize,
    pub duration: u128,
}

#[doc = r#"
# Example

```
use dual_cache_ff::DualCacheFF;

let cache = DualCacheFF::new();

cache.put("A", 100);
cache.put("B", 200);

assert_eq!(cache.get("A").unwrap(), 100);
assert!(cache.get("C").is_none());
```

## Fn `from` customize capacity
custom capacity will round to 1024 multiple

```
use dual_cache_ff::{DualCacheFF, Config};

let config = Config {
    capacity: 100, duration: 5000,
};
let cache = DualCacheFF::from(config);
thread::spawn(|| {
   cache.daemon(cache.rx);
 });
for i in 0..1024 {
    cache.put(i, format!("value_{}", i));
}

assert!(cache.get(0).is_some());
assert!(cache.get(1023).is_some());
```"#]
#[repr(align(128))]
pub struct DualCacheFF<K, V> {
    main: Mutex<Cache<K, V>>,
    mirror: ArcSwap<Cache<K, V>>,
    lazy_tx: Sender<K>,
    rx: Receiver<K>,
}

impl<K, V> DualCacheFF<K, V>
where
    K: Hash + Eq + Clone + Send + Sync + 'static + Debug,
    V: Clone + Send + Sync + 'static + Debug,
{
    pub fn new() -> Self {
        Self::default()
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
        let mut batch_size: u128 = 1024;
        let mut sma: VecDeque<u128> = VecDeque::with_capacity(5);

        while let Ok(first_key) = rx.recv() {
            let mut state = self.main.lock().unwrap();
            let mut processed_count = 0;
            let start_epoch = SystemTime::now();

            // 將 K 轉換為 usize index 才能 climb
            if let Some(&idx) = state.index.get(&first_key) {
                state.climb(idx);
            }
            processed_count += 1;

            while processed_count < batch_size {
                match rx.try_recv() {
                    Ok(key) => {
                        if let Some(&idx) = state.index.get(&key) {
                            state.climb(idx);
                        }
                        processed_count += 1;
                    }
                    Err(_) => break,
                }
            }

            state.lookup_count = state.lookup_count.saturating_add(processed_count as u128);

            if state.lookup_count > u128::MAX / 2 {
                state.refresh();
            }
            state.relocate_evict_point();

            let new_snapshot = Arc::new(state.clone());
            self.mirror.store(new_snapshot);

            if sma.len() == 5 {
                sma.pop_front();
            }
            
            // 避免除以 0 的情況
            let elapsed_ms = start_epoch.elapsed().unwrap_or_default().as_millis().max(1);
            sma.push_back(batch_size / elapsed_ms);
            
            todo!("adjust BATCH_SIZE with SMA if intense batch bigger vise versa")
        }
    }
}

impl<K, V> Default for DualCacheFF<K, V>
where
    K: Hash + Eq + Clone + Send + Sync + 'static + Debug,
    V: Clone + Send + Sync + 'static + Debug,
{
    fn default() -> Self {
        let config = Config {
            capacity: PAGE_SIZE,
            duration: 100 * 10, // 10sec
        };
        let cache = DualCacheFF::from(config);
        
        // 這裡需要 clone rx 以便在 thread 中使用，或者改變架構
        // 為了不改功能，假設 rx 可以被 clone 或直接傳遞
        let rx_clone = cache.rx.clone();
        let cache_clone = Self {
            main: Mutex::new(cache.main.lock().unwrap().clone()),
            mirror: ArcSwap::from_pointee((**cache.mirror.load()).clone()),
            lazy_tx: cache.lazy_tx.clone(),
            rx: cache.rx.clone(),
        };

        thread::spawn(move || {
            cache_clone.daemon(rx_clone);
        });
        cache
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
            evict_point: 0,
            lookup_count: 0,
            ring_pointer: 0,
            capacity,
            duration: config.duration as u128,
        };
        let (lazy_tx, rx) = bounded(10_000);

        Self {
            mirror: ArcSwap::from_pointee(state.clone()),
            main: Mutex::new(state),
            lazy_tx,
            rx,
        }
    }
}

#[derive(Clone)]
struct Cache<K, V> {
    nodes: Vec<Node<K, V>>,
    index: HashMap<K, usize>,
    arena: Paginated,
    evict_point: usize,
    lookup_count: u128,
    ring_pointer: usize,
    duration: u128,
    capacity: usize,
}

impl<K, V> Cache<K, V> {
    fn climb(&mut self, index: usize) {
        let prev_idx = Paginated::get_forward_idx(index);
        self.arena.swap(index, prev_idx);
    }

    fn refresh(&mut self) {
        self.lookup_count = 0;
        let epoch = SystemTime::now()
            .duration_since(UNIX_EPOCH)
            .expect("somewhat went wrong")
            .as_millis();
            
        for nxt in self.nodes.iter_mut() {
            nxt.count = 0;
            nxt.epoch = epoch;
        }
    }

    fn relocate_evict_point(&mut self) {
        let prev_idx = Paginated::get_forward_idx(self.evict_point);
        let latter_idx = Paginated::get_backward_idx(self.evict_point);

        let prev_node = self.arena.get(prev_idx).and_then(|&idx| self.nodes.get(idx));
        let latter_node = self.arena.get(latter_idx).and_then(|&idx| self.nodes.get(idx));

        if let Some(prev) = prev_node {
            if let Some(latter) = latter_node {
                if (self.evict_point as u128) < prev.count {
                    self.evict_point = self.evict_point.saturating_sub(1);
                } else if (self.evict_point as u128) < latter.count {
                    self.evict_point = self.evict_point.saturating_add(1);
                }
            }
        }
    }
}

#[repr(align(128))]
#[derive(Clone)]
struct Node<K, V> {
    key: K,
    value: V,
    epoch: u128,
    count: u128,
}

#[derive(Clone)]
struct Paginated {
    dir: Vec<Page>,
}

impl Paginated {
    fn new() -> Self {
        Self::from(PAGE_SIZE)
    }

    fn get_page_idx(index: usize) -> usize {
        index & MASK
    }

    fn get_dir_idx(index: usize) -> usize {
        index >> SHIFT
    }

    // 統一回傳一維 usize 索引，以符合 swap 的需求
    fn get_forward_idx(index: usize) -> usize {
        index.saturating_sub(1)
    }

    fn get_backward_idx(index: usize) -> usize {
        index.saturating_add(1)
    }

    fn get(&self, index: usize) -> Option<&usize> {
        let dir_idx = index >> SHIFT;
        let page_idx = index & MASK;

        self.dir
            .get(dir_idx)
            .map(|tmp| &tmp.pages[page_idx])
    }

    fn put(&mut self, index: usize, value: usize) {
        let dir_idx = index >> SHIFT;
        let page_idx = index & MASK;
        if let Some(tmp) = self.dir.get_mut(dir_idx) {
            tmp.pages[page_idx] = value;
        }
    }

    fn swap(&mut self, index_1: usize, index_2: usize) {
        let dir_idx_1 = index_1 >> SHIFT;
        let page_idx_1 = index_1 & MASK;
        let dir_idx_2 = index_2 >> SHIFT;
        let page_idx_2 = index_2 & MASK;

        // 處理同一個 Page 內的交換與跨 Page 的交換，避免 Borrow Checker 報錯
        if dir_idx_1 == dir_idx_2 {
            if let Some(page) = self.dir.get_mut(dir_idx_1) {
                page.pages.swap(page_idx_1, page_idx_2);
            }
        } else {
            let val1 = self.dir.get(dir_idx_1).map(|p| p.pages[page_idx_1]);
            let val2 = self.dir.get(dir_idx_2).map(|p| p.pages[page_idx_2]);
            
            if let (Some(v1), Some(v2)) = (val1, val2) {
                self.dir[dir_idx_1].pages[page_idx_1] = v2;
                self.dir[dir_idx_2].pages[page_idx_2] = v1;
            }
        }
    }
}

impl From<usize> for Paginated {
    fn from(value: usize) -> Self {
        // 初始化 Page 避免後續 get_mut 失敗
        let mut dir = Vec::with_capacity(value);
        for _ in 0..value {
            dir.push(Page { pages: [0; PAGE_SIZE] });
        }
        Self { dir }
    }
}

struct Page {
    pages: [usize; PAGE_SIZE],
}

impl Clone for Page {
    fn clone(&self) -> Self {
        let mut new_page: MaybeUninit<Page> = MaybeUninit::uninit();
        unsafe {
            std::ptr::copy_nonoverlapping(
                &self.pages as *const usize,
                new_page.as_mut_ptr() as *mut usize,
                PAGE_SIZE,
            );
            new_page.assume_init()
        }
    }
}