# DualCache-FF Specification (v0.2.0)

---

### 1. 核心門面與全域配置 (`lib.rs`)

```rust
pub struct Config {
    pub capacity: usize,
    pub t1_slots: usize,
    pub t2_slots: usize,
    pub duration: u32,
    pub threads: usize,
    pub poll_us: u64,             // Daemon 輪詢間隔 (µs)
    pub flush_tick_threshold: u64, // TLS 強制刷新閾值 (ticks)
}

pub struct DualCacheFF<K, V, S = RandomState> {
    pub hasher: S,
    pub t1: Arc<T1<K, V>>,
    pub t2: Arc<T2<K, V>>,
    pub cache: Arc<Cache<K, V>>,
    pub cmd_tx: Arc<LossyQueue<Command<K, V>>>, // 自研 Wait-Free 佇列
    pub hit_tx: Arc<LossyQueue<[usize; 64]>>,
    pub epoch: Arc<AtomicU32>,
    pub worker_states: Arc<[WorkerState]>,
    pub miss_buffers: Arc<[WorkerSlot<K, V>]>,
    pub daemon_tick: Arc<AtomicU64>,             // 背景計數器
}
```

### 2. 記憶體訪問路徑 (`storage.rs`, `arena.rs`, `cache_padded.rs`)

**物理約束：**
- **Alignment**: 使用 `cache_padded::CachePadded` 確保 `WorkerState` 不發生 False Sharing。ARM/Apple 使用 128-byte 對齊。
- **Wait-Free Read**: 100% 讀取路徑無鎖，基於 `AtomicPtr` 與 **QSBR**。
- **no_std**: 全核心代碼相容 `no_std` + `alloc`。

```rust
// ─── Node: 實體資料節點 ───
pub struct Node<K, V> {
    pub key: K,
    pub value: V,
    pub expire_at: u32,
    pub g_idx: u32,
}

// ─── LossyQueue: State Turnstile 佇列 ───
// 狀態碼：EMPTY(0) -> WRITING(1) -> READY(2)
pub struct LossyQueue<T> {
    tail: AtomicUsize, // Producer FAA
    head: AtomicUsize, // Consumer
    buffer: Box<[Slot<T>]>,
}
```

### 3. 生命週期管理 (`daemon.rs`)

```rust
pub struct Daemon<K, V, S> {
    pub arena: Arena,
    pub cmd_rx: Arc<LossyQueue<Command<K, V>>>,
    pub hit_rx: Arc<LossyQueue<[usize; 64]>>,
    pub daemon_tick: Arc<AtomicU64>,
    // ...
}
```

---

# 執行流 (Execution Flow)

## 物理約束與並行模型
*   **Worker (前端)**：100% Wait-Free。使用 `L1_FILTER` 進行本地准入控制。
*   **Time-based Flush**: Worker 比對本地 `LAST_FLUSH_TICK` 與全域 `daemon_tick`，若間隔過大則強制 flush TLS 緩衝區，解決低頻寫入下的可見性延遲。
*   **Daemon (背景)**：唯一的寫入者。使用 `poll_us` 進行定時任務執行，在 `no_std` 下可由外部 RTOS 驅動。

---

## Phase 1: 前端讀取管線 (Worker Read Path)
1.  **[QSBR Check-in]**：標記 `local_epoch`。
2.  **[分層查找]**：T1 (L1) -> T2 (L2) -> Cache (L3)。
3.  **[QSBR Check-out]**：清除標記。
4.  **[命中紀錄]**：緩衝至 TLS，滿 64 或逾時則發送至 `hit_tx`。

---

## Phase 2: 背景維護管線 (Daemon Maintenance)
1.  **[命中結算]**：批量接收 `hit_rx`，更新 `Arena` rank 並回填 T1/T2。
2.  **[QSBR 資源回收]**：檢查所有 Worker 狀態，釋放 `garbage_queue`。
3.  **[計數推進]**：增加 `daemon_tick`，觸發前端 flush。

---

## Phase 3: 背景代謝管線 (Daemon Eviction)
1.  **[均值掃描]**：使用 Clock 演算法遍歷 `Arena`。
2.  **[Revolution Shield]**：高頻項獲得保護，低於均值則進入 `garbage_queue`。

---

## Phase 4: 背景寫入管線 (Daemon Insertion)
1.  **[准入控制]**：檢查 `Ghost Set` (Resurrection)。
2.  **[Lossy Enqueue]**：使用 `LossyQueue` 進行 MPSC 傳輸。若 `compare_exchange` 失敗則直接丟棄以保護前端延遲。
