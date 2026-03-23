use ahash::AHashMap;
use arc_swap::ArcSwap;
use crossbeam::channel::{Receiver, Sender, bounded};
use std::sync::Arc;
use std::time::{SystemTime, UNIX_EPOCH};
use tracing::instrument;

/// # Specification: Cache Configuration
#[derive(Clone, Debug)]
pub struct Config {
    pub capacity: usize,
    pub duration: u64,
}

/// # Specification: Action Protocol (The Instruction Set)
pub enum Action<K, V> {
    Hit(K, u64),
    Put(K, V, u64),
    Delete(K),
    Clear,
}

/// # Specification: Physical Node (Plain Old Data)
///
/// # Invariants
/// - `rank` MUST perfectly mirror its index in the Daemon's `arena`.
/// - `arena[node.rank] == physical_idx_of_this_node`
#[derive(Clone, Debug)]
pub struct Node<K, V> {
    pub key: K,
    pub value: V,
    pub epoch: u64,
    pub count: u64,
    pub rank: usize, // Reverse mapping to arena (The Magic!)
}

/// # Specification: Read-Only View (Lock-Free Snapshot)
///
/// # Invariants
/// - `index` maps `K -> physical_idx`. Untouched during `Hit` or `Climb`.
/// - `nodes` maps `physical_idx -> Node`.
#[derive(Clone)]
pub struct CacheView<K, V> {
    pub index: Arc<AHashMap<K, usize>>,
    pub nodes: Arc<Vec<Node<K, V>>>,
}
#[doc = r#"
# Example

## Fn `build` customize capacity

```
use dual_cache_ff::{DualCacheFF, Config};
use std::thread;

let config = Config {
    capacity: 100, duration: 5000,
};
let cache = DualCacheFF::build(config);

for i in 0..100 {
    cache.put(i, format!("value_{}", i));
}
std::thread::sleep(std::time::Duration::from_millis(10)); // Wait for daemon
assert!(cache.get(&0).is_some());
assert!(cache.get(&99).is_some());
```"#]
/// # Specification: Frontend Handle (Wait-Free Client)
#[derive(Clone)]
pub struct DualCacheFF<K, V> {
    view: Arc<ArcSwap<CacheView<K, V>>>,
    action_tx: Sender<Action<K, V>>,
    config: Arc<Config>,
}

impl<K, V> DualCacheFF<K, V>
where
    K: std::hash::Hash + Eq + Clone + Send + Sync + 'static + std::fmt::Debug,
    V: Clone + Send + Sync + 'static + std::fmt::Debug,
{
    /// 啟動快取引擎與背景 Daemon
    pub fn build(config: Config) -> Self {
        let config = Arc::new(Config {
            capacity: config.capacity.max(1),
            duration: config.duration.max(1),
        });

        let initial_view = CacheView {
            index: Arc::new(AHashMap::with_capacity(config.capacity)),
            nodes: Arc::new(Vec::with_capacity(config.capacity)),
        };

        let view = Arc::new(ArcSwap::from_pointee(initial_view.clone()));
        let (action_tx, action_rx) = bounded(config.capacity);

        let mut daemon = DaemonEngine {
            current_view: initial_view,
            shared_view: view.clone(),
            action_rx,
            config: config.clone(),
            arena: Vec::with_capacity(config.capacity),
            evict_point: 0,
            direction: 1,
            lookup_count: 0,
        };

        std::thread::spawn(move || daemon.run());

        Self {
            view,
            action_tx,
            config,
        }
    }

    /// # Feature: Wait-Free Read & Lazy Expiration
    ///
    /// ```rust
    /// use dual_cache_ff::{DualCacheFF, Config};
    /// let cache = DualCacheFF::build(Config { capacity: 10, duration: 5 });
    /// cache.put("A", 100);
    /// std::thread::sleep(std::time::Duration::from_millis(10)); // Wait for daemon
    /// assert_eq!(cache.get(&"A"), Some(100));
    /// ```
    #[instrument(skip(self))]
    pub fn get(&self, key: &K) -> Option<V> {
        let view_guard = self.view.load();

        if let Some(&physical_idx) = view_guard.index.get(key) {
            let node = &view_guard.nodes[physical_idx];
            let now = SystemTime::now()
                .duration_since(UNIX_EPOCH)
                .unwrap_or_default()
                .as_secs();

            // Lazy Expiration: 過期直接回傳 None，並發送 Delete 訊號讓 Daemon 收屍
            if now.saturating_sub(node.epoch) > self.config.duration {
                let _ = self.action_tx.send(Action::Delete(key.clone()));
                return None;
            }

            let value = node.value.clone();
            // Lossy Counting: Channel 滿了就丟棄 Hit，絕對不阻塞讀取！
            let _ = self.action_tx.try_send(Action::Hit(key.clone(), 1));
            Some(value)
        } else {
            None
        }
    }

    /// # Feature: Async Write (Backpressured)
    #[instrument(skip(self, value))]
    pub fn put(&self, key: K, value: V) {
        let epoch = SystemTime::now()
            .duration_since(UNIX_EPOCH)
            .unwrap_or_default()
            .as_secs();
        // 使用 send 產生背壓，保證寫入絕對不遺失
        let _ = self.action_tx.send(Action::Put(key, value, epoch));
    }

    /// # Feature: Explicit Deletion
    #[instrument(skip(self))]
    pub fn delete(&self, key: &K) {
        let _ = self.action_tx.send(Action::Delete(key.clone()));
    }

    /// # Feature: Nuclear Clear
    #[instrument(skip(self))]
    pub fn clear(&self) {
        let _ = self.action_tx.send(Action::Clear);
    }

    /// # Feature: Zero-Copy Iterator Export
    ///
    /// ```rust
    /// use dual_cache_ff::{DualCacheFF, Config};
    /// let cache = DualCacheFF::build(Config { capacity: 10, duration: 5 });
    /// cache.put("A", 1);
    /// cache.put("B", 2);
    /// std::thread::sleep(std::time::Duration::from_millis(10));
    /// let items: Vec<_> = cache.iter().map(|(k, v)| (k.clone(), v.clone())).collect();
    /// assert_eq!(items.len(), 2);
    /// ```
    #[instrument(skip(self))]
    pub fn iter(&self) -> impl Iterator<Item = (K, V)> {
        let view_guard = self.view.load_full(); // 取得 Arc 擁有權，保證迭代期間記憶體安全

        // 這裡使用 into_iter 配合 Arc，或者回傳一個自訂的 Iterator
        // 為了簡潔，我們將資料收集後回傳 (實務上可實作專屬 Iterator 結構體)
        let mut result = Vec::new();
        for node in view_guard.nodes.iter() {
            if node.epoch > 0 {
                // 忽略墓碑
                result.push((node.key.clone(), node.value.clone()));
            }
        }
        result.into_iter()
    }
}
/// 專門用來處理物理陣列與鐘擺邏輯的「微型引擎」
/// 它只借用了需要的欄位，完美避開了 current_view.index！
struct EvictionEngine<'a, K, V> {
    nodes: &'a mut Vec<Node<K, V>>,
    arena: &'a mut Vec<usize>,
    evict_point: &'a mut usize,
    direction: &'a mut isize,
    lookup_count: &'a mut u64,
    config: &'a Config,
}
impl<'a, K, V> EvictionEngine<'a, K, V> {
    #[inline(always)]
    fn climb(&mut self, physical_idx: usize) {
        let rank = self.nodes[physical_idx].rank;
        if rank > 0 && rank < self.arena.len() {
            let prev_rank = rank - 1;
            let prev_physical_idx = self.arena[prev_rank];

            self.arena.swap(rank, prev_rank);
            self.nodes[physical_idx].rank = prev_rank;
            self.nodes[prev_physical_idx].rank = rank;
        }
    }

    #[inline(always)]
    fn teleport_tombstone(&mut self, rank_deleted: usize) {
        let current_evict = *self.evict_point;
        if rank_deleted != current_evict && current_evict < self.arena.len() {
            self.arena.swap(rank_deleted, current_evict);
            let physical_idx_deleted = self.arena[current_evict];
            let bystander_physical_idx = self.arena[rank_deleted];

            self.nodes[bystander_physical_idx].rank = rank_deleted;
            self.nodes[physical_idx_deleted].rank = current_evict;
        }
        if current_evict < self.arena.len() {
            let physical_idx_deleted = self.arena[current_evict];
            *self.lookup_count = self
                .lookup_count
                .saturating_sub(self.nodes[physical_idx_deleted].count);
            self.nodes[physical_idx_deleted].count = 0;
            self.nodes[physical_idx_deleted].epoch = 0;
        }
    }

    fn find_victim_and_advance(&mut self, current_epoch: u64) -> usize {
        let capacity = self.config.capacity as isize;
        let avg = (*self.lookup_count / (capacity as u64).max(1)).max(1);
        let duration = self.config.duration;

        loop {
            let current_rank = *self.evict_point;
            let physical_idx = self.arena[current_rank];
            let node = &mut self.nodes[physical_idx];

            if current_epoch.saturating_sub(node.epoch) > duration {
                self.step_forward(capacity);
                return current_rank;
            }
            if node.count <= avg {
                self.step_forward(capacity);
                return current_rank;
            }

            node.count -= avg;
            *self.lookup_count = self.lookup_count.saturating_sub(avg);
            *self.direction *= -1;
            self.step_forward(capacity);
        }
    }

    #[inline(always)]
    fn step_forward(&mut self, capacity: isize) {
        let mut next = *self.evict_point as isize + *self.direction;
        if next < 0 {
            next = 1.min(capacity - 1);
            *self.direction = 1;
        } else if next >= capacity {
            next = (capacity - 2).max(0);
            *self.direction = -1;
        }
        *self.evict_point = next as usize;
    }
}

/// # Specification: Control Plane (Daemon Engine)
struct DaemonEngine<K, V> {
    current_view: CacheView<K, V>,
    shared_view: Arc<ArcSwap<CacheView<K, V>>>,
    action_rx: Receiver<Action<K, V>>,
    config: Arc<Config>,

    // 絕對私有的物理控制層
    arena: Vec<usize>,
    evict_point: usize,
    direction: isize,
    lookup_count: u64,
}

impl<K, V> DaemonEngine<K, V>
where
    K: std::hash::Hash + Eq + Clone,
    V: Clone,
{
    pub fn run(&mut self) {
        let mut batch = Vec::with_capacity(1024);
        let timeout = std::time::Duration::from_millis(10);

        loop {
            // 1. 收集與日誌壓縮 (Log Compaction)
            match self.action_rx.recv_timeout(timeout) {
                Ok(action) => {
                    self.compress_and_push(&mut batch, action);
                    while batch.len() < 1024 {
                        if let Ok(next_action) = self.action_rx.try_recv() {
                            self.compress_and_push(&mut batch, next_action);
                        } else {
                            break;
                        }
                    }
                }
                Err(_) => {
                    if batch.is_empty() {
                        continue;
                    }
                }
            }

            // 2. 執行業務邏輯 (Copy-On-Write)
            self.apply_batch(&batch);

            // 3. 瞬間切換 ArcSwap (發布新視角)
            self.shared_view.store(Arc::new(self.current_view.clone()));
            batch.clear();
        }
    }

    #[inline(always)]
    fn compress_and_push(&self, batch: &mut Vec<Action<K, V>>, action: Action<K, V>) {
        if let Action::Hit(ref key, weight) = action {
            if let Some(Action::Hit(last_key, last_weight)) = batch.last_mut() {
                if last_key == key {
                    *last_weight += weight; // 連續 Hit 完美壓縮！
                    return;
                }
            }
        }
        batch.push(action);
    }

    fn apply_batch(&mut self, batch: &[Action<K, V>]) {
        // 1. 挖出 nodes_mut
        let nodes_mut = Arc::make_mut(&mut self.current_view.nodes);
        let mut index_is_mut = false;

        // 2. 建立微型引擎！(這就是 Splitting Borrows 的魔法)
        // 編譯器清楚地知道，engine 借用了 arena 和 nodes，但沒有借用 index！
        let mut engine = EvictionEngine {
            nodes: nodes_mut,
            arena: &mut self.arena,
            evict_point: &mut self.evict_point,
            direction: &mut self.direction,
            lookup_count: &mut self.lookup_count,
            config: &self.config,
        };

        for action in batch {
            match action {
                Action::Hit(k, weight) => {
                    if let Some(&physical_idx) = self.current_view.index.get(k) {
                        let node = &mut engine.nodes[physical_idx];
                        let max_count = (*engine.lookup_count / engine.config.capacity as u64)
                            .max(1)
                            .saturating_mul(10);

                        node.count = node.count.saturating_add(*weight).min(max_count);
                        *engine.lookup_count = engine.lookup_count.saturating_add(*weight);

                        // 3. 呼叫變得極度乾淨！不需要傳一堆參數！
                        engine.climb(physical_idx);
                    }
                }
                Action::Put(k, v, epoch) => {
                    if !index_is_mut {
                        Arc::make_mut(&mut self.current_view.index);
                        index_is_mut = true;
                    }
                    let index_mut = Arc::get_mut(&mut self.current_view.index).unwrap();

                    if let Some(&physical_idx) = index_mut.get(k) {
                        engine.nodes[physical_idx].value = v.clone();
                        engine.nodes[physical_idx].epoch = *epoch;
                    } else {
                        if engine.nodes.len() < engine.config.capacity {
                            let physical_idx = engine.nodes.len();
                            let rank = physical_idx;
                            engine.nodes.push(Node {
                                key: k.clone(),
                                value: v.clone(),
                                epoch: *epoch,
                                count: 0,
                                rank,
                            });
                            engine.arena.push(physical_idx);
                            index_mut.insert(k.clone(), physical_idx);
                        } else {
                            // 呼叫變得極度乾淨！
                            let victim_rank = engine.find_victim_and_advance(*epoch);
                            let physical_idx = engine.arena[victim_rank];

                            let old_key = engine.nodes[physical_idx].key.clone();
                            let old_count = engine.nodes[physical_idx].count;

                            *engine.lookup_count = engine.lookup_count.saturating_sub(old_count);
                            index_mut.remove(&old_key);

                            engine.nodes[physical_idx] = Node {
                                key: k.clone(),
                                value: v.clone(),
                                epoch: *epoch,
                                count: 0,
                                rank: victim_rank,
                            };
                            index_mut.insert(k.clone(), physical_idx);
                        }
                    }
                }
                Action::Delete(k) => {
                    if !index_is_mut {
                        Arc::make_mut(&mut self.current_view.index);
                        index_is_mut = true;
                    }
                    let index_mut = Arc::get_mut(&mut self.current_view.index).unwrap();

                    if let Some(physical_idx) = index_mut.remove(k) {
                        let rank_deleted = engine.nodes[physical_idx].rank;
                        // 呼叫變得極度乾淨！
                        engine.teleport_tombstone(rank_deleted);
                    }
                }
                Action::Clear => {
                    // 1. 觸發 HashMap 的 Copy-On-Write (因為我們要清空它)
                    if !index_is_mut {
                        Arc::make_mut(&mut self.current_view.index);
                        index_is_mut = true;
                    }
                    let index_mut = Arc::get_mut(&mut self.current_view.index).unwrap();

                    // 2. 清空物理陣列與邏輯陣列 (保留 Capacity，極致效能！)
                    engine.arena.clear();
                    engine.nodes.clear();
                    index_mut.clear();

                    // 3. 神級修正：使用 * 解參考，直接修改原本記憶體裡的值！
                    // 絕對不要寫 = &mut 0！
                    *engine.evict_point = 0;
                    *engine.direction = 1;
                    *engine.lookup_count = 0;
                }
            }
        }
    }
}
