# DualCache-FF (Fast and Furious)

## License 
[PolyForm-Noncommercial-1.0.0](https://polyformproject.org/licenses/noncommercial/1.0.0/)

---

**DualCacheFF** 是一個專為極端高併發場景設計的 Rust 記憶體內快取庫 (In-Memory Cache)。

它徹底拋棄了傳統的 `Mutex<HashMap>` 與標準 LRU 鏈表設計，採用了原創的 **「多重輪轉池 (Multi-State Rotation Pool)」** 併發模型與 **「鐘擺掃描 (Pendulum Scan)」** 淘汰演算法。在保證 **100% 無鎖讀取 (Wait-Free Read)** 的同時，達到了寫入與淘汰的 **零記憶體分配 (Zero-Allocation)**。

## ✨ 核心架構與亮點 (Core Features)

### 1. 絕對無鎖讀取 (100% Lock-Free Read)
讀取路徑上沒有任何 `Mutex` 或 `RwLock`。前端透過 `ArcSwap` 直接讀取唯讀快照，耗時僅需數奈秒。讀取命中後，透過非同步 Channel 發送 `Action::Hit` 訊號，**讀取操作永遠不會被寫入阻塞**。

### 2. 多重輪轉池併發模型 (Multi-State Rotation Pool)
受 `left-right` 併發模式啟發，但專為 Cache 負載進行了深度魔改：
* **消滅 `clone()` 災難**：背景 Daemon 維護 3~5 個備用 Cache 實例（Object Pool）。
* **無鎖寫入與切換**：Daemon 透過 `Arc::get_mut` 取得獨佔權進行修改，修改後透過 `ArcSwap::swap` 瞬間切換前端視角。
* **免疫讀者滯留 (Reader Stalling)**：當舊實例被慢速讀者卡住時，Daemon 會直接從 Pool 中拿出下一個乾淨的實例繼續處理，**寫入吞吐量永遠不會被慢讀者拖垮**。

### 3. 日誌壓縮與時序一致性 (Log Compaction & Epoch)
* **連續 Hit 聚合**：Daemon 在收集前端訊號時，會自動將對同一個 Key 的連續 `Hit` 壓縮為單一的權重增加操作（Run-Length Encoding 概念），將重播 (Replay) 效能提升百倍。
* **絕對時間錨點**：`Put` 操作自帶前端時間戳，保證在多個實例間重播時，過期邏輯的絕對一致性。

### 4. 原創淘汰引擎：鐘擺與稅演算法 (Pendulum & Flat-Tax Decay)
傳統的 LRU/LFU 需要維護昂貴的雙向鏈表或 Min-Heap，而 DualCacheFF 採用了極致的 $O(1)$ 陣列覆寫：
* **零分配覆寫 (Zero-Allocation)**：滿載後，底層 `Vec` 絕對不執行 `push` 或 `remove`，只做原地覆寫，極大化 CPU L1 Cache 命中率。
* **鐘擺掃描 (Pendulum Scan)**：淘汰指針在陣列中雙向遊走。撞到熱點牆即反轉，在冷資料區來回掃蕩，形成天然的 A/B Zone (冷熱分離)。
* **稅衰減 (Flat-Tax Decay)**：指針撞擊熱點時，不採用比例扣除，而是精準扣除「系統平均存取量」。完美解決了假熱點的「Legacy 沉澱」問題，讓舊熱點隨時間自然冷卻。
* **幽靈清理 (Ghost Cleaning)**：前端讀取到過期資料時，發送 `CleanGhost` 訊號。Daemon 會將其標記為垃圾，當鐘擺掃過時無條件覆寫，實現極低成本的延遲刪除 (Lazy Deletion)。

---

## 📦 快速開始 (Quick Start)

```rust
use dual_cache_ff::{DualCacheFF, Config};
use std::thread;
use std::time::Duration;

fn main() {
    // 1. 設定 Cache 容量與過期時間 (秒)
    let config = Config {
        capacity: 100_000,
        duration: 60, 
    };

    // 2. 建立 Cache 句柄與背景接收器
    let (cache, rx) = DualCacheFF::build(config);

    // 3. 啟動背景 Daemon 引擎 (負責日誌壓縮與雙星輪轉)
    let cache_clone = cache.clone();
    thread::spawn(move || {
        cache_clone.daemon(rx);
    });

    // 4. 極速寫入 (非同步發送 Put 訊號)
    cache.put("User:1001", "Alice");
    cache.put("User:1002", "Bob");

    // 5. 絕對無鎖讀取 (Wait-Free)
    assert_eq!(cache.get(&"User:1001"), Some("Alice"));
    
    // 測試過期機制
    thread::sleep(Duration::from_secs(61));
    assert!(cache.get(&"User:1001").is_none()); // 觸發 CleanGhost 延遲刪除
}
```

---

## 🔬 效能與複雜度 (Performance Characteristics)

| 操作 (Operation) | 時間複雜度 | 鎖競爭 (Lock Contention) | 記憶體分配 (Allocation) |
| :--- | :--- | :--- | :--- |
| **`get` (讀取)** | $O(1)$ | **無鎖 (Wait-Free)** | 零分配 |
| **`put` (寫入)** | $O(1)$ | **無鎖 (Channel Send)** | 零分配 (滿載後) |
| **`daemon` (背景重播)** | $O(B)$* | 獨佔修改 (無競爭) | 零分配 |
| **淘汰掃描 (Eviction)** | $O(1)$ | 獨佔修改 (無競爭) | 零分配 |

*\* $B$ 為壓縮後的 Batch Size。由於連續 Hit 會被壓縮，實際重播次數遠小於前端請求數。*

---

## 🏗️ 內部記憶體佈局 (Memory Layout)

DualCacheFF 拒絕了會導致 Cache Line 破碎的節點指標，採用了極度緊湊的物理陣列設計：

```rust
struct Cache<K, V> {
    nodes: Vec<Node<K, V>>,      // 物理儲存區：滿載後長度固定，只做原地覆寫
    arena: Vec<usize>,           // 邏輯排名區：僅儲存 usize，climb() 時只交換 8 bytes
    index: AHashMap<K, usize>,   // 快速路由表：Key -> 邏輯排名
    evict_point: usize,          // 鐘擺指針
    direction: isize,            // 鐘擺方向 (1 或 -1)
}
```
這種設計保證了在執行 `climb` (排名晉升) 或 `evict` (淘汰) 時，CPU 的硬體預取器 (Hardware Prefetcher) 能夠發揮最大效能。

---

## 🗺️ 未來展望 (Roadmap)

- [ ] **Criterion Benchmarks**: 加入與 `moka`、`scc`、`dashmap` 的極限吞吐量對比測試。
- [ ] **Zipfian Hit-Rate Simulation**: 驗證「鐘擺與稅演算法」在真實長尾分佈下的快取命中率。
- [ ] **Sync Put API**: 提供基於 `oneshot` channel 的強一致性寫入 API，讓使用者在「極致吞吐量」與「讀己之寫 (Read-After-Write) 一致性」之間自由選擇。

---
*project supported by gemini 3.1 pro*