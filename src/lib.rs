use std::sync::Arc;
use std::time::{SystemTime, UNIX_EPOCH};
use arc_swap::ArcSwap;
use crossbeam::channel::{bounded, Receiver, Sender};
use ahash::AHashMap;

// --- 1. 定義 Action 與 Node ---

pub enum Action<K, V> {
    Hit(K, u64),          // Key, Weight (用於日誌壓縮)
    Put(K, V, u64),       // Key, Value, 絕對時間戳
    CleanGhost(K),        // 幽靈清理
    EpochBarrier,         // 強制 Flush 訊號
}

#[derive(Clone)]
pub struct Node<K, V> {
    pub key: K,
    pub value: V,
    pub epoch: u64,
    pub count: u64,
}

#[derive(Clone)]
pub struct Config {
    pub capacity: usize,
    pub duration: u64,
}

// --- 2. 核心資料結構 (純粹的邏輯，沒有鎖) ---

#[derive(Clone)]
pub struct Cache<K, V> {
    pub nodes: Vec<Node<K, V>>,
    pub index: AHashMap<K, usize>,
    pub arena: Vec<usize>,
    pub evict_point: usize,
    pub direction: isize,
    pub lookup_count: u64,
    pub config: Config,
}

impl<K, V> Cache<K, V> where K: std::hash::Hash + Eq + Clone,V: Clone {
    pub fn new(config: Config) -> Self {
        Self {
            nodes: Vec::with_capacity(config.capacity),
            index: AHashMap::with_capacity(config.capacity),
            arena: Vec::with_capacity(config.capacity),
            evict_point: 0,
            direction: 1,
            lookup_count: 0,
            config,
        }
    }

    /// 核心批次處理引擎：負責消化 Daemon 收集來的所有 Action
    pub fn apply_batch(&mut self, batch: &[Action<K, V>]) {
        for action in batch {
            match action {
                Action::Hit(k, weight) => {
                    if let Some(&rank) = self.index.get(k) {
                        let physical_idx = self.arena[rank];
                        
                        // 1. 增加計數 (加上日誌壓縮後的權重)
                        self.nodes[physical_idx].count = self.nodes[physical_idx].count.saturating_add(*weight);
                        self.lookup_count = self.lookup_count.saturating_add(*weight);
                        
                        // 2. 觸發排名晉升 (O(1) Swap)
                        self.climb(rank);
                    }
                }
                Action::Put(k, v, epoch) => {
                    if let Some(&rank) = self.index.get(k) {
                        // Fast Path: Key 已經存在，直接更新 Value 和時間戳
                        let physical_idx = self.arena[rank];
                        self.nodes[physical_idx].value = v.clone();
                        self.nodes[physical_idx].epoch = *epoch;
                    } else {
                        // Slow Path: 插入新資料
                        if self.nodes.len() < self.config.capacity {
                            // --- 暖機階段 (Warmup) ---
                            let physical_idx = self.nodes.len();
                            let rank = physical_idx;
                            
                            self.nodes.push(Node { 
                                key: k.clone(), value: v.clone(), epoch: *epoch, count: 0 
                            });
                            self.arena.push(physical_idx);
                            self.index.insert(k.clone(), rank);
                        } else {
                            // --- 滿載階段 (Full)：觸發鐘擺淘汰 ---
                            let victim_rank = self.find_victim_and_advance(*epoch);
                            let physical_idx = self.arena[victim_rank];

                            // 1. 從 HashMap 刪除舊 Key
                            let old_key = self.nodes[physical_idx].key.clone();
                            self.index.remove(&old_key);

                            // 2. 原地覆寫物理節點 (Zero-Allocation!)
                            self.nodes[physical_idx] = Node { 
                                key: k.clone(), value: v.clone(), epoch: *epoch, count: 0 
                            };

                            // 3. 將新 Key 註冊到這個排名
                            self.index.insert(k.clone(), victim_rank);
                        }
                    }
                }
                Action::CleanGhost(k) => {
                    // 幽靈清理的神級優化：
                    // 不只從 HashMap 刪除，我們還把它的 count 和 epoch 歸零！
                    // 這樣當鐘擺指針掃到它時，會立刻把它當作「過期垃圾」無情覆寫，瞬間回收空間。
                    if let Some(rank) = self.index.remove(k) {
                        let physical_idx = self.arena[rank];
                        self.nodes[physical_idx].count = 0;
                        self.nodes[physical_idx].epoch = 0; 
                    }
                }
                Action::EpochBarrier => {
                    // Barrier 只是用來中斷 Daemon 的收集迴圈，在這裡不需要做任何事
                }
            }
        }
    }

    /// 排名晉升：與前一名交換位置 (O(1) 極速操作)
    #[inline(always)]
    fn climb(&mut self, rank: usize) {
        if rank > 0 && rank < self.arena.len() {
            let prev_rank = rank - 1;
            
            // 1. 交換邏輯排名
            self.arena.swap(rank, prev_rank);

            // 2. 同步更新 HashMap 裡的指標
            let key_a = self.nodes[self.arena[rank]].key.clone();
            let key_b = self.nodes[self.arena[prev_rank]].key.clone();

            self.index.insert(key_a, rank);
            self.index.insert(key_b, prev_rank);
        }
    }

    /// 鐘擺演算法：尋找適合並推進指針
    fn find_victim_and_advance(&mut self, current_epoch: u64) -> usize {
        let capacity = self.config.capacity as isize;
        if capacity == 0 { return 0; }
        
        // 計算系統平均值 
        let avg = self.lookup_count / (capacity as u64).max(1);
        let duration = self.config.duration;

        loop {
            let current_rank = self.evict_point;
            let physical_idx = self.arena[current_rank];
            let node = &mut self.nodes[physical_idx];

            // 1. 絕對真理：時間戳檢查 
            if current_epoch.saturating_sub(node.epoch) > duration {
                self.step_forward(capacity);
                return current_rank;
            }

            // 2. 冷資料：直接淘汰
            if node.count <= avg {
                self.step_forward(capacity);
                return current_rank;
            }

            // 3. 撞到熱點牆：繳交稅，並「掉頭」
            node.count -= avg;
            self.direction *= -1; // 鐘擺反轉！
            
            self.step_forward(capacity);
            // 迴圈繼續：下一步極大機率會踩到剛插入的冷資料，完美保持 O(1)
        }
    }

    /// 處理鐘擺的步進與物理邊界反彈
    #[inline(always)]
    fn step_forward(&mut self, capacity: isize) {
        let mut next_point = self.evict_point as isize + self.direction;
        
        // 碰到陣列頭尾的物理邊界，觸發反轉
        if next_point < 0 {
            next_point = 1;
            self.direction = 1;
        } else if next_point >= capacity {
            next_point = capacity - 2;
            self.direction = -1;
        }
        
        self.evict_point = next_point as usize;
    }
}

// --- 3. 前端句柄 (極度輕量，無鎖讀寫) ---

#[derive(Clone)]
pub struct DualCacheFF<K, V> {
    view: Arc<ArcSwap<Cache<K, V>>>,
    action_tx: Sender<Action<K, V>>,
}

impl<K, V> DualCacheFF<K, V> 
where 
    K: std::hash::Hash + Eq + Clone + Send + Sync + 'static,
    V: Clone + Send + Sync + 'static 
{
    pub fn build(config: Config) -> Self {
        // 準備 4 個實例 (1 個給 view，3 個放進 pool)
        let instance_active = Arc::new(Cache::new(config.clone()));
        let pool = vec![
            Arc::new(Cache::new(config.clone())),
            Arc::new(Cache::new(config.clone())),
            Arc::new(Cache::new(config)),
        ];

        let view = Arc::new(ArcSwap::new(instance_active));
        let (action_tx, action_rx) = bounded(100_000);

        let handle = Self { view: view.clone(), action_tx };

        let mut daemon = Daemon {
            view,
            pool,
            action_rx,
        };

        std::thread::spawn(move || {
            daemon.run();
        });

        handle
    }

    pub fn get(&self, key: &K) -> Option<V> {
        let cache = self.view.load();
        let now = SystemTime::now().duration_since(UNIX_EPOCH).unwrap().as_secs();

        if let Some(&rank) = cache.index.get(key) {
            let physical_idx = cache.arena[rank];
            let node = &cache.nodes[physical_idx];

            //TODO: daemon expire improve
            if now.saturating_sub(node.epoch) > cache.config.duration {
                let _ = self.action_tx.try_send(Action::CleanGhost(key.clone()));
                return None;
            }

            let value = node.value.clone();
            let _ = self.action_tx.try_send(Action::Hit(key.clone(), 1));
            Some(value)
        } else {
            None
        }
    }

    pub fn put(&self, key: K, value: V) {
        let epoch = SystemTime::now().duration_since(UNIX_EPOCH).unwrap().as_secs();
        let _ = self.action_tx.try_send(Action::Put(key, value, epoch));
    }
}

// --- 4. 背景引擎 (多重輪轉池，絕對無鎖) ---

pub struct Daemon<K, V> {
    view: Arc<ArcSwap<Cache<K, V>>>,
    pool: Vec<Arc<Cache<K, V>>>,
    action_rx: Receiver<Action<K, V>>,
}

impl<K, V> Daemon<K, V> where K: std::hash::Hash + Eq + Clone, V: Clone {
    pub fn run(&mut self) {
        let mut batch_log = Vec::with_capacity(1024);
        let timeout = std::time::Duration::from_millis(10);

        loop {
            // 1. 收集與日誌壓縮 (Log Compaction)
            match self.action_rx.recv_timeout(timeout) {
                Ok(action) => {
                    self.compress_and_push(&mut batch_log, action);
                    
                    // 繼續收，直到沒東西或滿了
                    while batch_log.len() < 1024 {
                        if let Ok(next_action) = self.action_rx.try_recv() {
                            self.compress_and_push(&mut batch_log, next_action);
                        } else {
                            break;
                        }
                    }
                }
                Err(_) => {
                    if batch_log.is_empty() { continue; }
                }
            }

            // 2. 從池子拿一個沒人讀的實例
            let mut standby_arc = self.get_free_cache();

            // 3. 無鎖修改
            let cache_mut = Arc::get_mut(&mut standby_arc).unwrap();
            cache_mut.apply_batch(&batch_log);

            // 4. 瞬間切換！
            let old_arc = self.view.swap(standby_arc);

            // 5. 舊實例直接丟回池子 (不等待！)
            self.pool.push(old_arc);
            batch_log.clear();
        }
    }

    // 日誌壓縮邏輯：連續 Hit 合併
    fn compress_and_push(&self, batch: &mut Vec<Action<K, V>>, action: Action<K, V>) {
        if let Action::Hit(ref key, weight) = action {
            if let Some(Action::Hit(last_key, last_weight)) = batch.last_mut() {
                if last_key == key {
                    *last_weight += weight;
                    return;
                }
            }
        }
        batch.push(action);
    }

    // 輪詢池子，找出 Count == 1 的實例
    fn get_free_cache(&mut self) -> Arc<Cache<K, V>> {
        loop {
            for i in 0..self.pool.len() {
                if Arc::strong_count(&self.pool[i]) == 1 {
                    return self.pool.remove(i);
                }
            }
            std::thread::yield_now();
        }
    }
}