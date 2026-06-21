# DualCache-FF Crate 設計回饋與封裝建議書 (Insights)

在將 `dualcache-ff` 整合至嵌入式高效能資料庫 `cdDB` 的過程中，我們對這款 wait-free 快取的架構與使用體驗有了深刻的理解。以下為 `dualcache-ff` 作為一個獨立 Crate，未來在 API 設計、封裝與功能擴充上的核心 Insights 建議。

---

## 1. 消除 `std` 與 `no_std` (StaticDualCache) 的 API 不對稱性

### 現狀痛點
在 `#![no_std]` 與 `std` 兩種編譯配置下，`dualcache-ff` 導出了不同的類型。然而，這兩者的 API 存在明顯的不對稱：
* `StaticDualCache`（`no_std` 別名為 `DualCacheFF`）擁有 `insert_t1` 方法，但沒有 `begin_cold_start_session` 與 `warmup`。
* `DualCacheFF`（`std` 下）擁有 `begin_cold_start_session` 與 `warmup`，且擁有 `sync()`，但 `StaticDualCache` 沒有 `sync()`。
* 這造成外部專案（如 `cdDB`）在撰寫通用程式碼時，必須寫滿大量的 `#[cfg(feature = "std")]` 與分支，極易出錯。

### 建議改進
* **統一 API 宣告 (Uniform API Interface)**：
  在 `StaticDualCache` 下提供 `sync()` 的 dummy/no-op 實作，並同樣提供 `begin_cold_start_session()` 以回傳無開銷的 `ColdStartSession`。
* **統一 `new_headless` 的返回型態**：
  在 `no_std` 下 `new_headless` 應同樣返回 `(Self, DummyDaemon)`，其中 `DummyDaemon::run()` 是一個 empty function。這樣外部引擎就可以寫統一的執行緒啟動與維護邏輯：
  ```rust
  let (cache, daemon) = DualCacheFF::new_headless(config);
  executor.spawn(move || daemon.run()); // no_std 下為 no-op，std 下則會運作
  ```

---

## 2. 提供動態輪詢頻率調整與阻斷式 Daemon (Power-Saving / Dynamic Sleep)

### 現狀痛點
在 `cdDB` 這種高度關注省電與 CPU 喚醒開銷（Wakeup Overhead）的場景中，雖然 `dualcache-ff` 的 Daemon 輪詢佔用很少 CPU，但在完全沒有請求時，Daemon 的 `loop` 與自旋依然會阻礙 CPU 核心進入深度休眠狀態（C-states）。

### 建議改進
* **動態頻率控制命令**：
  在 `Command` 中新增 `SetPollInterval(Duration)`，允許上層應用主動調整 Daemon 的 `poll_us`（例如系統閒置時降頻至 100ms 輪詢，繁忙時提升至 1ms 輪詢）。
* **阻斷式（Blocking）Daemon 模式**：
  提供可配置的等待機制。例如當 Command Queue 與 Hit Queue 連續 $N$ 次輪詢為空時，Daemon 改為在信號量（Semaphore）或 `Condvar` 上掛起，有新命令寫入時再行喚醒，以達成真正的零空轉 CPU 開銷。

---

## 3. 提供確定性寫入（Deterministic Write）與可觀測狀態

### 現狀痛點
* **寫後讀不到（Async Friction）**：非同步准入非常利於高併發，但卻是「測試殺手」，迫使開發者在測試中使用不穩定的 `sleep`。
* **L1 Probation 不透明**：開發者無法得知某個數據是「被 Probation Filter 過濾掉了」，還是「仍積壓在 TLS Buffer 尚未被 Daemon 處理」。

### 建議改進
* **內建 `insert_sync(&self, K, V)`**：
  直接在 `DualCacheFF` 的主 API 提供同步寫入方法，內部自動呼叫 `sync()` 屏障，保證返回時快取狀態是可見的。
* **提供 `Config::disable_tls_batching` 開關**：
  允許在偵錯或測試模式下，將 TLS 寫入緩衝與 Probation 關閉，改為直發 Daemon，便於調錯。
* **暴露狀態遙測 (Telemetry)**：
  提供 `pending_write_count()` 或 `queue_utilization()` 等 API，讓外部能夠檢測是否有「背壓」發生。

---

## 4. 註冊快取淘汰與推廣監聽器 (Eviction & Promotion Callbacks)

### 現狀痛點
當 `dualcache-ff` 作為數據引擎的快取層時，快取本身只追蹤「熱度」並汰換節點。但資料庫需要知道**「哪一個實體被快取淘汰了」**（以便釋放對應的 Column 記憶體並更新 block 指標），或者**「哪一個實體從冷變熱被 promotion 了」**。目前快取是一具「黑盒子」，外部無法響應其淘汰事件。

### 建議改進
* **淘汰監聽器 (Eviction Callback Hook)**：
  允許使用者在建立快取時傳入一個 `Arc<dyn Fn(K, V) + Send + Sync>`。當背景 Daemon 的 Clock 演算法決定淘汰某個 node 時，調用此回調，讓外部系統能做資源回收：
  ```rust
  let config = Config::default().on_evict(|key, _val| {
      db.evict_column_data_from_memory(key);
  });
  ```
* **推廣事件 (Promotion Event)**：
  同樣地，當某個 key 被判定為熱數據並寫入 T1/L3 Cache 時，觸發回調，通知外部將數據從磁碟拉入記憶體。這能將 `dualcache-ff` 從「熱度標記器」升級為「主動快取控制器」。

---

## 5. Thread Management (執行緒管理) 建議

### 現狀痛點
在 `dualcache-ff` 中，快取利用 TLS 快速分配 Worker ID，並靜態配置最大執行緒數量（`config.threads`）。
* **動態執行緒擴容能力差**：在 Tokio 等動態執行緒池環境中，當活躍執行緒數大於 `config.threads` 時，多出來的執行緒會發生 Worker Slot 越界，被迫退化到無緩衝的直發模式，產生顯著效能落差。
* **TLS 生命週期回收困難**：在短生命週期執行緒頻繁銷毀重建的系統中，舊的 Worker ID 與 TLS 緩衝區難以自動安全回收。

### 建議改進
* **動態執行緒索引登記表 (Dynamic Thread Registry)**：
  捨棄完全靜態的執行緒數上限，引入基於 RCU 的動態 Worker ID 登錄機制。當新執行緒首次寫入時動態註冊槽位，並在執行緒析構 (Drop Helper) 時自動回收 ID，以完美適配現代非同步協程池。
* **執行緒池親和性與調度整合**：
  提供可插拔的執行緒調度介面，允許 Daemon 任務直接排程在用戶現有的非同步運行時（如 Tokio 任務）或執行緒池中，而不是每次都強行 `std::thread::spawn` 一個專屬作業系統執行緒。

---

## 6. Daemon Management (Daemon 管理) 建議

### 現狀痛點
Daemon 執行緒是快取異步准入與記憶體回收的單點心臟。
* **缺乏健康檢測與自動拉起**：若背景 Daemon 因不可抗力或內部 Bug 發生 Panic 意外中止，快取主體（RCU 讀路徑）仍可繼續運作，但非同步佇列將會無聲無息地積壓甚至丟棄所有更新，用戶無法即時感知系統已處於失控狀態。
* **關閉時的佇列流失 (Lossy Shutdown)**：直接 Drop 快取會異步發送 `Command::Shutdown`，但這不保證佇列中剩餘的熱度與准入事件在退出前已被安全排空。

### 建議改進
* **Daemon 健康監測監控器**：
  提供 `pub fn daemon_health(&self) -> DaemonStatus` API，向外界揭示背景執行緒是否存活、是否發生過 Panic。
* **Daemon 自動拉起與重新附著 (Re-attaching)**：
  提供 Daemon 的重置與重新綁定介面。當監測到 Daemon 異常退出時，允許上層應用無縫重建並啟動一個新的 Daemon 連接到同一個 `DualCacheFF` 快取主體。
* **優雅排空關閉 (Graceful Drain)**：
  支持 `shutdown_gracefully(timeout: Duration)`，在退出前阻斷新寫入，但強制排空 command channel 中的所有殘留更新，確保數據不丟失。

---

## 7. Warmup Interface (預熱介面) 建議

### 現狀痛點
目前的預熱機制是透過 `ColdStartSession` 逐個發送 `Command::InsertT1`。
* **大量單一預熱的 Channel 競爭瓶頸**：在資料庫啟動或載入大範圍熱點時，如果預熱 10,000 個元素，會產生 10,000 次 Channel 通信，極易導致快取的非同步 `LossyQueue` 溢出並丟失預熱指令。
* **預熱進度不可控 (No Synchronization Barrier)**：由於預熱命令為異步發送，上層應用無法得知預熱何時在背景 Daemon 徹底執行完畢，無法實施「預熱完成後才開放外部讀寫」的順序控制。

### 建議改進
* **批次預熱 API (Batch Warmup)**：
  在 `ColdStartSession` 中引入 `warmup_batch` 或 `warmup_iter`。快取將打包多個實體為單一的 `Command::BatchInsertT1`，一次性推送到通道，大幅減少併發競爭與通訊開銷。
* **預熱同步屏障 (Warmup Barrier)**：
  提供 `warmup_sync(...)` 或 awaitable 的預熱介面，在所有預熱節點皆已正式進駐 T1/Cache 後才解除阻塞，便於資料庫控制冷啟動流程。
* **分級熱度預熱 (Rank-injected Warmup)**：
  預熱不應局限於塞滿 T1 快取。應允許指定預熱級別 `warmup_with_rank(key, value, target_tier)`，以支援更細緻的冷啟動層級規劃。

---

## 8. Advanced Cache Interaction (進階快取互動) 建議

當快取被部署於實際資料庫（如 `cdDB`）或高負載後端系統時，快取的「日常互動」往往超越了簡單的 `get` 與 `insert`。以下是能顯著增強快取與主系統協同能力的五個進階互動設計：

### A. 防擊穿的併發回填控制 (Coalescing / SingleFlight 讀取)
* **痛點**：當熱點 Key 過期或被淘汰時，大量併發請求會同時遭遇 Cache Miss（`get` 返回 `None`），隨後這些執行緒會同時穿透到磁碟或後端服務去重複加載相同數據，造成「快取擊穿」（Cache Breakdown）。
* **改進建議**：
  在快取中提供一個 `get_or_load` 互動介面，底層整合無鎖的 `SingleFlight` 機制：
  ```rust
  pub fn get_or_load<F, E>(&self, key: &K, load_fn: F) -> Result<V, E>
  where F: FnOnce() -> Result<V, E>
  ```
  對於同一個 Key 的併發加載，快取會保證只有一個執行緒在執行 `load_fn`，其餘執行緒掛起等待該結果並共享回填，加載完畢後自動 insert，從而徹底在快取內部防禦擊穿。

### B. 快取穿透防禦的聯動 (Bloom Filter Integration)
* **痛點**：對於系統中根本不存在的惡意/無效 Key，快取每次都會 Miss，導致每次都會穿透去執行昂貴的後端查詢（快取穿透）。
* **改進建議**：
  允許快取初始化時綁定或注入一個動態布隆過濾器（Bloom Filter）。當 `get` 發生 Cache Miss 且布隆過濾器判斷該 Key 確實不存在時，快取內部直接攔截並快速返回 `None`，且不向背景 Daemon 發送任何無效的 Miss 統計事件，降低系統開銷。

### C. 帶權重的熱度微調與充值 (Access Boost & Dynamic Weight)
* **痛點**：目前所有的 `get` 都被視為相同的熱度貢獻。但在複雜業務中，查詢的「價值」不同（例如管理員的 VIP 查詢應在快取留存更久；批量掃描查詢應給予較低熱度權重，以防止污染快取）。
* **改進建議**：
  * 提供 `get_with_weight(&self, key: &K, weight: u8)` 介面，讓讀取能攜帶自訂的熱度貢獻。
  * 提供 `boost_heat(&self, key: &K, extra_rank: u8)`，允許外部在不執行 `insert`（不覆寫 Value）的前提下，手動為某個特定 Key 在快取中「續期」或提升其存活排名。

### D. 雙向熱度回饋 API (Bidirectional Heat Feedback)
* **痛點**：目前快取內部淘汰完全是個黑盒子。在多級儲存（Tiered Storage）資料庫中，資料庫無法得知哪些記憶體常駐數據即將因為不常被讀取而「面臨淘汰」。
* **改進建議**：
  提供 `get_heat_rank(&self, key: &K) -> Option<u8>` API。允許資料庫的記憶體管理器定期掃描某些大對象，查詢其當前在快取中的熱度級別。如果發現其熱度已降至臨界點（即使快取尚未正式 Evict），資料庫便能主動實施平滑的降級與持久化，進行更精細的主動內存調度。

### E. 有損佇列丟棄通知與動態背壓機制 (Lossy Drop & Backpressure Alerts)
* **痛點**：`dualcache-ff` 的 `LossyQueue` 在高負載下為保證 Wait-Free 讀寫，會在通道滿時無聲丟棄統計事件。但若丟棄率過高，將導致熱度偏離真實分佈，引發誤淘汰。
* **改進建議**：
  當 `LossyQueue` 發生丟棄時，提供事件統計或觸發 `on_lossy_drop` 回調。當外部檢測到丟棄率超過閥值時，可動態調整背壓策略（例如主動拉大 Daemon 輪詢頻率，或將核心寫入暫時切換為 `insert_sync`），保證熱度統計的保真度。


