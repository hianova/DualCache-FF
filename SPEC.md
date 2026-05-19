# DualCache-FF Specification (v0.2.1)

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

---

## Phase 5: 生命週期銷毀與優化 (Lifecycle Destruction & CPU Yielding)
1. **[無鎖無損銷毀]**：`DualCacheFF` 的 `Drop` 實作會檢測 Arc 引用計數。當最後一個控制端實例被 dropped 時，會自動向 `cmd_tx` 發送 `Command::Shutdown`，安全關閉 Daemon 的事件輪詢迴圈。
2. **[記憶體零洩漏]**：
   * `Cache` 的 `Drop` 遍歷所有節點，安全釋放 (`Box::from_raw`) 剩餘的實體 `Node`。
   * `Daemon` 的 `Drop` 安全釋放 `garbage_queue` 中等待 QSBR 宣告回收的 `Node` 記憶體。
3. **[漸進式 CPU 讓步 (Spin-then-Yield)]**：在 `std` 模式下，`OneshotAck::wait()` 和 `LossyQueue::send_blocking()` 採用漸進式自旋：前 100 次使用 `core::hint::spin_loop()`，之後轉為呼叫 `std::thread::yield_now()` 讓出時間片，徹底解決極端競爭下的 CPU 嚴重發熱 (Busy Waiting) 問題；在 `no_std` 模式下則保持安全自旋。

---

## Phase 6: Concurrency Safety, Loom Checking & Timeout Watchdogs

1. **[Loom 協程棧溢出預防 (Loom Stack Protection)]**：
   * 在 `loom` 模擬環境下，受限的虛擬協程棧（2 KB - 4 KB）會因大容量的 `BatchBuf`（`[MaybeUninit; 32]` 約 768+ 位元組）於 `new_headless` 中被頻繁拷貝而極易引發棧溢出（Stack Overflow）。
   * 系統已實作在啟用 `loom` 條件編譯時，自動將 `WorkerSlot` 中的 `BatchBuf` 改為 `UnsafeCell<Box<BatchBuf<K, V>>>` 堆分配（Heap-allocated），並透過 `**ptr` 智慧解包，既保持了 Wait-Free 熱路徑對外 API 完美相容，又徹底消除了 Loom 的棧溢出崩潰。
2. **[主動式逾時看門狗 (Active Timeout Watchdogs)]**：
   * **整合測試端**：全套 6 大整合測試（`concurrent`、`pressure`、`robust`、`stability`、`test_hash`、`unsafe_spec`）均全面包裝於 `run_with_timeout` 逾時看門狗中（5 至 30 秒上限），凡逾時即立刻觸發 Panic 崩潰，防範死鎖或活鎖無窮自旋。
   * **基準測試端**：所有 5 大基準測試（`capex`、`latency`、`memory`、`throughput`、`rw_ratio`）的 `main` 熱路徑啟動時，皆在背景派生非同步看門狗 `start_timeout_watchdog`（`rw_ratio` 為 120 秒，其餘為 60 秒上限），一旦逾時即主動透過 `std::process::exit(101)` 安全熔斷並印出逾時診斷，拒絕任何執行緒懸掛或殭屍行程。

---

## Phase 7: Dynamic Thread ID Recycling, Cold Start & Hit Rate Restoration

1. **[動態執行緒 ID 回收機制 (Dynamic Thread ID Recycling)]**：
   * **問題背景**：先前執行緒 ID `WORKER_ID` 採用簡單的遞增 `AtomicUsize::fetch_add(1)` 分配。在多測試/基準測試連續執行的行程中，執行緒不斷新建與銷毀，使得 ID 迅速遞增並超過 `config.threads` 上限，進而使大批執行緒退化為「溢出執行緒」無法存取 L1 准入控制與命中率追蹤。
   * **優化實作**：引入全域安全 `IdAllocator` 與執行緒局部守衛 `ThreadIdGuard` (實作 `Drop`)。當工作執行緒生命週期結束銷毀時，其持有的 ID 會被自動 push 回全域 `free_list` 重複利用，從而使並行執行緒數嚴格維持在當前活躍線程的物理峰值以內，徹底解決 ID 溢出問題。
2. **[冷啟動感應與更新查找旁路 (Cold Start & Update Lookup Bypass)]**：
   * 為了克服大寫入佔比下，因 L1 准入過濾器（Probation Filter）對單次寫入誤殺而造成的命中率折損，引入了全域 `is_cold_start` 狀態。
   * 當處於冷啟動期或鍵已存在於 `t1`、`t2` 或 `cache` (L3) 中時，前端 `insert` 將主動旁路（Bypass） L1 准入過濾器，直接允許插入或就地更新，使 `Zipf` 和各種讀寫比下的命中率從 70% 完美回復至 **84.5% - 84.7%** 的極致水準。
3. **[安全溢出降級與邊界保護 (Graceful Overflow Safety)]**：
   * 在 `insert` 與 `get` 熱路徑中，將所有 `t1`、`t2` 和 `cache` 的 QSBR 標記區塊嚴格包裝在 `if id_opt.is_some() { ... }` 內。
   * 針對在極端情況下仍超出 `config.threads` 註冊空間的執行緒，系統能優雅降級為不記錄命中（Safe Miss）與採用 LossyQueue 直接發送，完全消除 Use-After-Free (UAF) 的隱患。
