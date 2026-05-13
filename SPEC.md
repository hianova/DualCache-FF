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

pub struct DualCacheFF<K, V, S = RandomState> {
    pub hasher: S,
    pub t1: Arc<T1<K, V>>,
    pub t2: Arc<T2<K, V>>,
    pub cache: Arc<Cache<K, V>>,
    pub cmd_tx: Sender<Command<K, V>>,
    pub hit_tx: Sender<[usize; 64]>,
    pub epoch: Arc<AtomicU32>,
    pub worker_states: Arc<[WorkerState]>,
    pub miss_buffers: Arc<[WorkerSlot<K, V>]>,
}
```

### 2. 記憶體訪問路徑 (`unsafe_core.rs`)

**物理約束：**
- **Alignment**: 根據平台自動對齊。ARM/Apple Silicon 使用 `align(128)`，其餘使用 `align(64)`。
- **Wait-Free Read**: 使用 `AtomicPtr` 與 **QSBR (Quiet State Based Reclamation)** 確保記憶體安全。

```rust
// ─── Node: 實體資料節點 ───
pub struct Node<K, V> {
    pub key: K,
    pub value: V,
    pub expire_at: u32,
    pub g_idx: u32,
}

// ─── Cache: 實體資料持有者 ───
pub struct Cache<K, V> {
    pub index_mask: usize,
    pub index: Box<[AtomicU64]>, 
    pub nodes: Box<[AtomicPtr<Node<K, V>>]>, 
}
```

### 3. 生命週期管理 (`daemon.rs`)

```rust
pub struct Daemon<K, V, S> {
    pub hasher: S, 
    pub arena: Arena,
    pub cache: Arc<Cache<K, V>>,
    pub cmd_rx: Receiver<Command<K, V>>,
    pub hit_rx: Receiver<[usize; 64]>,
    // ... 其他過濾器與通道
}
```

---

# 執行流 (Execution Flow)

## 物理約束與並行模型
*   **Worker (前端)**：100% Wait-Free。使用 `L1_FILTER` (TLS Probation) 進行本地准入控制。命中紀錄緩衝至 TLS，滿 64 則發送。
*   **Daemon (背景)**：唯一的寫入者與維護者。負責全局淘汰邏輯、QSBR 資源回收與索引回填。

---

## Phase 1: 前端讀取管線 (Worker Read Path)
**觸發條件**：外部呼叫 `get(Key)`

1.  **[QSBR Check-in]**：將當前執行緒的 `local_epoch` 標記為 `GLOBAL_EPOCH`。
2.  **[AtomicPtr 讀取]**：使用 `Ordering::Acquire` 讀取 `AtomicPtr`。
3.  **[命中判定]**：比對 Key 並檢查 `expire_at`。
4.  **[QSBR Check-out]**：清除 `local_epoch` (歸零)。
5.  **[命中紀錄]**：將 `g_idx` 緩衝至 TLS。滿 64 則發送至 `hit_tx`。

---

## Phase 2: 背景維護管線 (Daemon Maintenance)
**觸發條件**：事件循環

1.  **[命中結算]**：批量接收 `hit_rx`，更新 `Arena` 中的 `rank` (Revolution Shield) 並回填至 T1 索引。
2.  **[QSBR 資源回收]**：掃描所有 Worker 的 `local_epoch`，決定 `garbage_queue` 中哪些 `Node` 指標可以安全釋放。
3.  **[時鐘滴答]**：更新全域 `epoch`。

---

## Phase 3: 背景代謝管線 (Daemon Eviction)
**觸發條件**：`free_list` 低於閾值。

1.  **[均值掃描]**：使用 **Clock (Circular Scan)** 演算法。遍歷 `Arena` 指標，若 `rank` 低於全域平均則淘汰，否則遞減 `rank` (Decay)。
2.  **[索引移除]**：從全局 Index 中移除，指標進入 `garbage_queue` 等待 QSBR 回收，槽位進入 `free_list` 等待重用。

---

## Phase 4: 背景寫入管線 (Daemon Insertion)
**觸發條件**：收到 `Command::Insert` 或 `BatchInsert`。

1.  **[准入控制]**：檢查 `AdmissionFilter` (Ghost Set) 或 TLS Probation。
2.  **[原子交換]**：使用 `swap` 將新 `Node` 指標寫入 `nodes` 陣列。
3.  **[索引更新]**：更新全局 Open-addressed Index。
