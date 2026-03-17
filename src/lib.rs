// use std::borrow::Borrow;
// use std::collections::VecDeque;
// use std::fmt::Debug;
// use std::hash::Hash;
// use std::sync::Arc;
// use std::sync::Mutex;
// use std::time::Duration;
// use std::time::SystemTime;
// use std::time::UNIX_EPOCH;

// use ahash::AHashMap;
// use arc_swap::ArcSwap;
// use crossbeam::channel::Receiver;
// use crossbeam::channel::Sender;
// use crossbeam::channel::bounded;
// use tracing::instrument;

// #[derive(Clone)]
// pub struct Config {
//     pub capacity: usize,
//     pub duration: Duration,
// }

// #[doc = r#"
// # Example

// ```
// use dual_cache_ff::DualCacheFF;

// let cache = DualCacheFF::new();

// cache.put("A", 100);
// cache.put("B", 200);

// assert_eq!(cache.get("A"), Some(100));
// assert!(cache.get("C").is_none());
// ```

// ## Fn `build` customize capacity

// ```
// use dual_cache_ff::{DualCacheFF, Config};
// use std::thread;

// let config = Config {
//     capacity: 100, duration: 5000,
// };
// let (cache, rx) = DualCacheFF::build(config);
// let cache_clone = cache.clone();// TODO: don't use clone
// thread::spawn(move || {
//    cache_clone.daemon(rx);
// });
// for i in 0..100 {
//     cache.put(i, format!("value_{}", i));
// }

// assert!(cache.get(&0).is_some());
// assert!(cache.get(&99).is_some());
// ```"#]
// #[repr(align(128))]
// pub struct DualCacheFF<K, V> {
//     mirror: ArcSwap<Cache<K, V>>,
//     tx: Sender<Action<K>>,
// }

// impl<K, V> DualCacheFF<K, V>
// where
//     K: Hash + Eq + Clone + Send + Sync + 'static + Debug,
//     V: Clone + Send + Sync + 'static + Debug,
// {
//     pub fn new() -> Arc<Self> {
//         let config = Config {
//             capacity: 100,
//             duration: Duration::new(5, 0),
//         };
//         let (cache, rx) = DualCacheFF::build(config);
//         let cache_clone = cache.clone();
//         std::thread::spawn(move || {
//             cache_clone.daemon(rx);
//         });
//         cache
//     }

//     pub fn build(config: Config) -> (Arc<Self>, Receiver<Action<K>>) {
//         let capacity = config.capacity;
//         let state = Cache {
//             nodes: Vec::with_capacity(capacity),
//             index: AHashMap::with_capacity(capacity),
//             arena: Vec::with_capacity(capacity),
//             evict_point: 0,
//             lookup_count: 0,
//             config,
//         };
//         let (tx, rx) = bounded(10_000);

//         (
//             Arc::new(Self {
//                 mirror: ArcSwap::from_pointee(state), 
//                 tx,
//             }),
//             rx,
//         )
//     }

// #[doc = r#"
//     # Feature
//     - **Arena evict probation** (鐘擺掃描淘汰)
//     - **Count evict probation** (所得稅衰減機制)

//     # Example

//     ## Evict Probation (滿載淘汰測試)
//     當 Cache 達到 capacity 時，會自動淘汰最舊或最少使用的節點。
//     ```rust
//     use dual_cache_ff::{DualCacheFF, Config};
//     use std::thread;

//     // 設定容量只有 2
//     let config = Config { capacity: 2, duration: 5000 };
//     let (cache, rx) = DualCacheFF::build(config);
    
//     // 啟動背景 Daemon
//     let cache_clone = cache.clone();
//     thread::spawn(move || { cache_clone.daemon(rx); });

//     // 塞入 3 筆資料，必定會觸發淘汰機制
//     cache.put("A", 100);
//     cache.put("B", 200);
//     cache.put("C", 300); // "A" 或 "B" 將被淘汰 (取決於鐘擺指針)

//     // 驗證容量維持在 2，且新資料 "C" 必定存在
//     assert!(cache.get(&"C").is_some());
//     ```
//     "#]
//     #[instrument(skip(self, value), fields(key = ?key))]
//     pub fn put(&self, key: K, value: V) {
//         self.tx.send(Action::Put(key, value));
//     }
// #[doc = r#"
//     # Feature
//     - **Outdated check** (時間戳過期檢查)
//     - **Count progress** (讀取計數增加)

//     # Example 

//     ## Outdated check (過期自動清理)
//     當資料存活時間超過 `duration`，`get` 會回傳 None 並發送清理訊號。
//     ```rust
//     use dual_cache_ff::{DualCacheFF, Config};
//     use std::thread;
//     use std::time::Duration;

//     // 設定存活時間只有 1 秒
//     let config = Config { capacity: 10, duration: 1 };
//     let (cache, rx) = DualCacheFF::build(config);
    
//     let cache_clone = cache.clone();
//     thread::spawn(move || { cache_clone.daemon(rx); });

//     cache.put("TempKey", 999);
//     assert_eq!(cache.get(&"TempKey"), Some(999)); // 剛放入，讀取成功

//     // 等待 2 秒，讓資料過期
//     thread::sleep(Duration::from_secs(2));
    
//     // 再次讀取，應該被判定為過期 (Outdated)
//     assert!(cache.get(&"TempKey").is_none());
//     ```
//     "#]
//     #[instrument(skip(self), fields(key = ?key))]
//     pub fn get<Q>(&self, key: &Q) -> Option<V>
//     where
//         K: Borrow<Q>,
//         Q: Hash + Eq + ?Sized + Debug,
//     {
//         // let now = SystemTime::now().duration_since(UNIX_EPOCH).expect("err").as_secs();
//         // let cache = self.mirror.load();
//         // let index = cache.index.get(key);
        
//         // match index {
//         //     Some(&idx) => {
//         //         let page = cache.arena[idx];
//         //         if cache.nodes[page].key.borrow() == key {
//         //             if now.saturating_sub(cache.nodes[page].epoch) > cache.config.duration {
//         //                 let _ = self.lazy_tx.send(Action::CleanGhost(cache.nodes[page].key.clone()));// TODO: don't use clone
//         //                 return None;
//         //             }
//         //             let out = cache.nodes[page].value.clone();// TODO: don't use clone
//         //             let _ = self.lazy_tx.send(Action::Hit(cache.nodes[page].key.clone()));// TODO: don't use clone
//         //             Some(out)
//         //         } else {
//         //             None
//         //         }
//         //     }
//         //     None => None,
//         // }
//         todo!()
//     }

//     pub fn daemon(&self, rx: Receiver<Action<K>>) {
//         let mut batch_size: u64 = 1024;
//         let mut sma: VecDeque<u64> = VecDeque::with_capacity(5);
//         let mut sma_sum: u64 = 0;

//         while let Ok(first_action) = rx.recv() {
//             let mut state = self.main.lock().unwrap();
//             let mut processed_count = 0;
//             let start_time = SystemTime::now();

//             state.apply(first_action);
//             processed_count += 1;

//             while processed_count < batch_size {
//                 match rx.try_recv() {
//                     Ok(action) => {
//                         state.apply(action);
//                         processed_count += 1;
//                     }
//                     Err(_) => break,
//                 }
//             }

//             state.lookup_count = state.lookup_count.saturating_add(processed_count as u64);

//             let new_snapshot = Arc::new(state.clone());// TODO: don't use clone
//             self.mirror.store(new_snapshot);

//             if sma.len() == 5 {
//                 if let Some(popped) = sma.pop_front() {
//                     sma_sum = sma_sum.saturating_sub(popped);
//                 }
//             }

//             let elapsed_ms = start_time.elapsed().unwrap_or_default().as_millis() as u64;
//             let elapsed_ms = elapsed_ms.max(1);
//             let current_sma = batch_size / elapsed_ms;
            
//             sma.push_back(current_sma);
//             sma_sum += current_sma;

//             if (sma_sum >> 5) > 100 {
//                 batch_size = batch_size >> 10;
//             } else {
//                 batch_size = batch_size * 10;
//             }
//             batch_size = batch_size.clamp(1, 100_000); 
//         }
//     }
// }

// #[derive(Clone)]
// struct Cache<K, V> {
//     nodes: Vec<Node<K, V>>,
//     index: AHashMap<K, usize>,
//     arena: Vec<usize>,
//     evict_point: isize,
//     lookup_count: u64,
//     config: Config,
// }

// impl<K, V> Cache<K, V> 
// where 
//     K: Hash + Eq + Clone 
// {
//     fn climb(&mut self, index: usize) {
//         if index > 0 && index < self.arena.len() {
//             self.arena.swap(index, index - 1);
//             let key_a = self.nodes[self.arena[index]].key.clone();// TODO: don't use clone
//             let key_b = self.nodes[self.arena[index - 1]].key.clone();// TODO: don't use clone
//             self.index.insert(key_a, index);
//             self.index.insert(key_b, index - 1);
//         }
//     }
    
//     fn next(&mut self) -> usize { 
//         let capacity = self.config.capacity as isize;
//         if capacity == 0 { return 0; }
//         let avg = self.lookup_count / (capacity as u64).max(1);

//         loop {
//             let is_forward = self.evict_point >= 0;
//             let rank = if is_forward {
//                 self.evict_point
//             } else {
//                 !self.evict_point
//             } as usize;

//             if rank >= self.arena.len() {
//                 self.evict_point = 0;
//                 continue;
//             }

//             let physical_idx = self.arena[rank];
//             let node = &mut self.nodes[physical_idx];

//             if node.count > avg {
//                 node.count -= avg;
//                 self.evict_point = if is_forward {
//                     !(rank as isize)
//                 } else {
//                     rank as isize
//                 };
//             } else {
//                 let victim_rank = rank;
//                 let next_rank = if is_forward {
//                     rank as isize + 1
//                 } else {
//                     rank as isize - 1
//                 };
                
//                 if next_rank < 0 {
//                     self.evict_point = 1;
//                 } else if next_rank >= capacity {
//                     self.evict_point = !(capacity - 2);
//                 } else {
//                     self.evict_point = if is_forward { next_rank } else { !next_rank };
//                 }
                
//                 return victim_rank;
//             }
//         }
//     }

//     fn apply(&mut self, action: Action<K>) {
//         match action {
//             Action::Get(k) => {
//                 if let Some(&idx) = self.index.get(&k) {
//                     self.climb(idx);
//                     let physical_idx = self.arena[idx];
//                     if self.nodes[physical_idx].count < (self.lookup_count / self.config.capacity as u64).saturating_mul(10) {
//                         self.nodes[physical_idx].count += 1;
//                     }
//                 }
//             },
//             Action::Put(key, value)=>{        let mut cache = self.main.lock().unwrap();
//         let epoch = SystemTime::now();
            
//         if let Some(&rank) = cache.index.get(&key) {
//             let physical_idx = cache.arena[rank];
//             cache.nodes[physical_idx].value = value;
//             cache.nodes[physical_idx].epoch = epoch;
//             return;
//         }

//         let node = Node {
//             key: key.clone(),// TODO: don't use clone
//             value,
//             epoch,
//             count: 0,
//         };
        
//         if cache.arena.len() < cache.config.capacity {
//             let index = cache.nodes.len();
//             cache.nodes.push(node);
//             cache.arena.push(index);
//             cache.index.insert(key, index);
//             return;
//         }
        
//         let rank = cache.next();
//         let physical_idx = cache.arena[rank];
        
//         let old_key = cache.nodes[physical_idx].key.clone();// TODO: don't use clone
//         cache.index.remove(&old_key);
        
//         cache.nodes[physical_idx] = node;
//         cache.index.insert(key, rank);},
//             Action::CleanGhost(k) => {
//                 self.index.remove(&k);
//             },
//             Action::Barrier=>{},
//         }
//     }
// }

// pub enum Action<K,V> {
//     Get(K,u64),
//     Put(K, V),
//     CleanGhost(K),
//     Barrier,
// }

// #[repr(align(128))]
// #[derive(Clone)]
// struct Node<K, V> {
//     key: K,
//     value: V,
//     epoch: Duration,
//     count: u64,
// }

use std::time::Duration;

use ahash::AHashMap;
use arc_swap::ArcSwap;
use crossbeam::channel::{Receiver,Sender};

pub struct DualCacheFF<K,V>{
    view: ArcSwap<Cache<K,V>>,
    action_tx: Sender<Action<K,V>>,
}
pub enum Action<K,V> {
    Get(K,u64),
    Put(K, V),
    CleanGhost(K),
    Barrier,
}

pub struct Daemon<K,V>{
    view_pool:Vec<ArcSwap<Cache<K,V>>>,
    action_rx:Receiver<Action<K,V>>,
    config:Config,
}

pub struct Config{
    duration:Duration,
    capacity:usize,
}

#[repr(align(128))]
pub struct Cache<K,V>{
    nodes:Vec<Node<K,V>>,
    arena:Vec<usize>,
    index:AHashMap<K,usize>,
    count_sum:u64,
    evict_point:isize,
}

#[repr(align(128))]
#[derive(Clone)]
struct Node<K, V> {
    key: K,
    value: V,
    epoch: Duration,
    count: u64,
}
