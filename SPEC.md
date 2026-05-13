# DualCache-FF Specification 

---

### 1. 核心門面與全域配置 (`lib.rs`)

```rust
pub struct Config {
    pub capacity: usize,
    pub t1_slots: usize,
    pub t2_slots: usize,
    pub duration: u32,
    pub threads: usize,
}

pub struct DualCacheFF<K, V, S> {
    pub hasher: S,
    pub t1: Arc<T1>,
    pub t2: Arc<T2>,
    pub cache: Arc<Cache<K, V>>,
    pub cmd_tx: SyncSender<Command<K, V>>,
    pub hit_tx: SyncSender<[usize; 64]>, 
    pub epoch: Arc<AtomicU32>, 
    pub admission: Arc<AdmissionFilter>,
    pub miss_buffers: Arc<[WorkerSlot<K, V>]>,
}
```

### 2. 記憶體訪問路徑 (`unsafe_core.rs`)

**物理約束：**
- **Alignment**: 根據平台自動對齊。ARM/Apple Silicon 使用 `align(128)`，其餘使用 `align(64)`。
- **Wait-Free Read**: 使用 `SeqLock` 進行樂觀並行讀取。

```rust
// ─── PoolSlot: SeqLock 容器 ───
pub struct PoolSlot<K, V> {
    pub seq: AtomicUsize,
    pub data: UnsafeCell<MaybeUninit<Node<K, V>>>,
}

// ─── Cache: 實體資料持有者 ───
pub struct Cache<K, V> {
    pub index_mask: usize,
    pub index: Box<[AtomicU64]>, 
    pub nodes: Box<[PoolSlot<K, V>]>, 
}
```

### 3. 生命週期管理 (`daemon.rs`)

```rust
pub struct Daemon<K, V, S> {
    pub hasher: S, 
    pub arena: Arena,
    pub cache: Arc<Cache<K, V>>,
    // ... 其他過濾器與通道
}

pub struct Node<K, V> {
    pub key: K,
    pub value: V,
    pub expire_at: u32,
}
```

---

# 執行流 (Execution Flow)

## 物理約束與並行模型
*   **Worker (前端)**：100% Wait-Free。使用 `L1_FILTER` (TinyLFU) 進行本地准入控制。命中紀錄緩衝至 TLS，滿 64 則發送。
*   **Daemon (背景)**：唯一的寫入者與維護者。負責全局淘汰邏輯與索引回填。

---

## Phase 1: 前端讀取管線 (Worker Read Path)
**觸發條件**：外部呼叫 `get(Key)`

1.  **[SeqLock 讀取]**：循環讀取 `seq` 直到為偶數且前後一致。
2.  **[命中判定]**：比對 Key 並檢查 `expire_at`。
3.  **[命中紀錄]**：將 `g_idx` 緩衝至 TLS。滿 64 則發送至 `hit_tx`。

---

## Phase 2: 背景維護管線 (Daemon Maintenance)
**觸發條件**：事件循環

1.  **[命中結算]**：批量接收 `hit_rx`，更新 `Arena` 中的 `rank` 並回填至 T1 索引。
2.  **[時鐘滴答]**：更新全局 `epoch`。

---

## Phase 3: 背景代謝管線 (Daemon Eviction)
**觸發條件**：`free_list` 低於閾值。

1.  **[均值掃描]**：使用鐘擺 (Pendulum) 演算法，根據 `rank` 與全局平均值進行淘汰。
2.  **[索引移除]**：從全局 Index 中移除，槽位進入 `free_list` 等待重用。

---

## Phase 4: 背景寫入管線 (Daemon Insertion)
**觸發條件**：收到 `Command::Insert` 或 `BatchInsert`。

1.  **[准入控制]**：檢查 `AdmissionFilter` (Ghost Set)。
2.  **[SeqLock 更新]**：
    *   `seq.store(odd)` (鎖定)。
    *   `ptr::write` 更新數據。
    *   `seq.store(even)` (解鎖)。
3.  **[索引更新]**：更新全局 Index。
