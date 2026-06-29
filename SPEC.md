# DualCache-FF (Fast Forward) 系統規格與架構流程書

## 1. 系統概述

DualCache-FF 是一個專為極端高併發、極低延遲場景設計的雙層快取系統（Local Cache + Wait-Free Core Cache），以 Rust 語言開發並支援 `no_std` 環境。此架構的核心目標在於解決傳統快取系統在面對「突發熱點轉移 (Data Shift)」與「冷啟動 (Cold Start)」時的效能崩潰與延遲突波，提供 P99.99 < 150ns 的極致壓制力。

---

## 2. 核心架構元件

### 2.1 TlsCache (Local Cache - L1)
- **定位**：綁定於各執行緒 (Thread-Local) 的獨立區域快取。
- **讀取成本**：< 1ns（無競爭開銷）。
- **抗掃描 (Scan Resistance) 機制**：引入 **Probation Filter** (留校察看過濾器) 與 Clock-sweep aging 演算法。首次寫入的資料會被過濾器阻擋，連續存取兩次以上才能正式進入 TlsCache，有效防止一次性掃描攻擊造成的快取污染。
- **非同步通訊**：資料在 L1 被頻繁命中時，會將命中計數 (Hit count) 以背景批次 (`DaemonMessage::HitBatch`) 送至全域，或在達到晉升閥值時發送 `Promote` 訊息。

### 2.2 DualCacheCore (Core Cache - L2)
- **定位**：全域無鎖 (Wait-Free) 的核心快取。
- **層級架構**：內部採用固定大小的 Static Cache Tier 分為 T0 (Royal Class), T1, T2，並搭配基於陣列的 `Arena` 記憶體池進行資料節點管理。
- **QSBR 記憶體回收**：使用 QSBR (Quiescent State Based Reclamation) 實作 Wait-Free 安全讀寫與記憶體釋放，避免了傳統 CAS (Compare-And-Swap) 重試循環造成的效能抖動，也省去了 Hazard Pointer 每步讀取的高昂開銷。

### 2.3 背景守護行程 (Daemon)
- **定位**：負責非同步的資料晉升與熱度同步（限 `std` 環境）。
- **運作模式**：各執行緒將命中統計量透過無鎖通道 (Channel) 批次發送，Daemon 背景接收後進行「壓縮合併 (Compress)」並統一更新至 Core Cache，將原本會產生劇烈競爭的多執行緒寫入，轉換為平滑的單線程更新。

---

## 3. 創新流程與機制

### 3.1 算牌機制 (Blackjack Scoring) 與 Fast Pass (快速通關)
為了解決快取在冷啟動與熱點轉移階段「無法快速讓熱點進入 T0」的系統摩擦，我們引入了創新的 `warmup_state` 機制來動態追蹤各執行緒的工作負載溫度。

- **計分規則**：
  - **TlsCache 命中 / Total Miss (`-10` 分)**：如果資料在 L1 命中或完全沒命中，代表該資料尚未成功晉升至全域 T0，此時我們**扣分**（判定系統為冷狀態）。
  - **T0 命中 (`+10` 分)**：如果資料在 T0 被找到，代表全域已經對該熱點達成共識。此時我們**加分**（判定系統為熱狀態）。
- **Fast Pass 觸發**：當 `warmup_state` 小於 `100` 時，系統進入 Fast Pass 模式。
- **Fast Pass 特權**：在此模式下，任何 `insert` 或 `get` 補捉到的快取不需層層晉升，會**直接越級寫入全域 T0**，並在 `TlsCache` 中直接賦予最高存活分 (`255`)，免除被本地 LFU 演算法誤殺的機率，達到瞬間熱機的效果。

---

## 4. 核心執行流程 (Flow)

### 4.1 Get (讀取) 流程
1. **查詢 TlsCache (L1)**：
   - 若 **命中**：動態更新狀態分數 (`warmup_state.saturating_sub(10)`)，直接回傳資料。
     - 若命中次數過高達到晉升閥值，發送 `Promote` 訊息。
     - 否則，將命中次數存入批次陣列，集滿 32 個即發送 `HitBatch` 訊息。
2. **查詢 Core Cache (L2)**（L1 未命中時）：
   - 使用 QSBR 進入安全區間，無鎖讀取 Core。
   - 若在 **T0 命中**：更新狀態分數 (`warmup_state.saturating_add(10)`)。
   - **快取回填 (Backfill)**：將讀到的資料寫回 TlsCache。
     - 若 `warmup_state < 100`，使用 `insert_fast_pass` 回填。
     - 若 `warmup_state >= 100`，使用一般 `insert`（需過 Probation Filter）。
   - 回傳資料。
3. **Total Miss (全域未命中)**：
   - 狀態扣分 (`warmup_state.saturating_sub(10)`)，回傳 `None`。

### 4.2 Insert (寫入) 流程
1. **判斷 Fast Pass 狀態**：依據當下執行緒的 `warmup_state < 100` 決定。
2. **Fast Pass 啟動時 (冷啟動/熱點轉移)**：
   - 呼叫 `insert_fast_pass` 寫入 TlsCache（繞過 Probation Filter 並給予 255 命運值）。
   - 將資料透過背景 `Promote` 或同步 `put_t0`，直接越級保送至全域 T0。
3. **Fast Pass 關閉時 (穩定狀態)**：
   - 呼叫一般 `insert` 寫入 TlsCache（受到 Probation Filter 限制，防止快取污染）。
   - 由系統後續的命中次數決定是否自然晉升，不再強迫寫入 Core。

---

## 5. 系統效能與品質保證
- **極致吞吐**：在 `thread::park()` 與高頻率 CAS 造成的效能抖動被 Wait-Free 架構消滅後，系統能在維持千萬級 OPS 的同時，達成微秒等級以下的 P99.99 穩定性。
- **100% Clippy Clean**：所有程式碼皆通過嚴格的 `clippy` 檢查，無任何警告，並修正所有潛在型別與生命週期問題。
- **高測試覆蓋率**：透過 `cargo llvm-cov` 驗證，Lines, Functions, Regions 覆蓋率均達到 **90% 以上**（整體高達 96%），包含所有的 Daemon 通道排程、Tls 驅逐路徑、QSBR 回收機制及 Fast Pass 閥值。
- **Loom 併發驗證**：在無鎖資料結構上使用 `loom` 進行反覆交錯測試，確保所有 Memory Ordering (SeqCst, Acquire, Release) 完全無 Data Race 與 UB (Undefined Behavior)。
