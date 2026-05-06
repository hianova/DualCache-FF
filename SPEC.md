 

---

### 1. 核心門面與全域配置 (`lib.rs`)

```rust
use crossbeam_channel::{Sender, Receiver};
use crossbeam_epoch::Atomic;
use std::sync::atomic::{AtomicU32, AtomicU64};
use std::sync::Arc;

pub struct Config {
    pub capacity: usize,
    pub t1_slots: usize,      // 嚴格限制在 L1 Cache 預算內 (e.g., 2048)
    pub t2_capacity: usize,   // 總容量的 20%
    pub duration: u32,
}

pub struct DualCacheFF<K, V, S> {
    pub hasher: S,

    // ─── 實體快取層 (唯讀路徑，Wait-Free) ───
    pub t1: Arc<T1<K, V>>,
    pub t2: Arc<T2<K, V>>,
    pub l3: Arc<L3<K, V>>,

    // ─── 雙流分離信號通道 (Lossy & Lossless) ───
    // 命令流：保證執行的狀態變更 (Insert/Remove/Clear)
    pub cmd_tx: Sender<Command<K, V>>,
    // 統計流：取代 TLS 模除黑洞。傳遞精確的 global_idx，滿載即丟棄 (Lossy)
    pub hit_tx: Sender<usize>, 

    // ─── EBR 全域紀元 ───
    pub epoch: Arc<AtomicU32>, 
}
```

### 2. 記憶體訪問路徑 (`unsafe_core.rs`)

```rust
// 實體節點：由 L3 負責 Box::new 分配，由 EBR 負責延遲 Drop
pub struct Node<K, V> {
    pub key: K,
    pub value: V,
    pub expire_at: u32,
}

// ─── T1 & T2: 無所有權的極速指標陣列 ───
pub struct T1<K, V> {
    pub mask: usize,
    // 純指標陣列。發生碰撞時 Daemon 直接 store(Release) 覆寫。
    pub slots: Box<[Atomic<Node<K, V>>]>, 
}

pub struct T2<K, V> {
    pub mask: usize,
    pub slots: Box<[Atomic<Node<K, V>>]>, 
}

// ─── L3: 實體資料持有者與主索引 ───
pub struct L3<K, V> {
    pub index_mask: usize,
    // 索引層：開放尋址表。高 16-bit 存 Hash Tag，低 48-bit 存 global_idx。
    pub index: Box<[AtomicU64]>, 
    
    // 實體層：【已廢除 4KB Page】。
    // 直接存 Node 指標，徹底消除 Insert 時的 memcpy 與 Allocator 鎖爭用。
    pub nodes: Box<[Atomic<Node<K, V>>]>, 
}
```

### 3. 信號流與狀態變更 (`daemon.rs` - Part 1)

```rust
pub enum Command<K, V> {
    Insert(K, V),
    Remove(K),
    Clear(crossbeam_channel::Sender<()>), // 同步阻塞回收橋接
}

// 【已廢除 ThreadLocalStats】
// 理由：模除 256 會導致 global_idx 遺失，Daemon 無法精準給予熱點「階段獎勵」。
// 替代方案：前端 Worker 直接使用 `hit_tx.try_send(global_idx)`。
```

### 4. 背景異步與生命週期管理 (`daemon.rs` - Part 2)

```rust
pub struct Daemon<K, V, S> {
    // 【修正】：Daemon 必須持有 Hasher，否則無法計算 L3 寫入座標與 T1/T2 晉升路由
    pub hasher: S, 
    
    pub arena: Arena,
    pub admission: AdmissionFilter<K, S>,
    
    // Daemon 必須持有這三層的 Arc，才能在背景執行指標覆寫與 EBR 垃圾回收
    pub t1: Arc<T1<K, V>>,
    pub t2: Arc<T2<K, V>>,
    pub l3: Arc<L3<K, V>>,
    
    pub cmd_rx: Receiver<Command<K, V>>,
    pub hit_rx: Receiver<usize>, // 接收精確的 global_idx 進行熱點獎勵
    
    pub epoch: Arc<AtomicU32>,
    pub duration: u32,
}

pub struct AdmissionFilter<K, S> {
    // 存儲被淘汰的 Hash Fingerprint
    pub ghost_set: RingBuffer<u64>, 
    // 【修正】：強制注入極速 Hasher (S)，拒絕 std 預設的 SipHash 效能毒藥
    pub probation: AHashMap<K, u8>, 
}

pub struct Arena {
    pub capacity: usize,
    pub count_sum: u64, 
    pub cursor: usize, 

    // 核心狀態：連續記憶體陣列 (供 SIMD 飽和加減法使用)
    pub rank: Vec<u8>, 
    
    // 【修正】：O(1) 淘汰與 Ghost Set 續命的關鍵
    // 記住每個 global_idx 對應的 Hash。淘汰時直接算出 L3 index 座標，消除 O(N) 全表掃描。
    pub hashes: Vec<u64>, 
    
    // O(1) 尋找空槽位，解決 Insert 隨機丟棄的 Starvation 問題
    pub free_list: Vec<usize>,
}
```

---

# DualCache-FF Strict Execution Flow

## 實體約定 (Physical Constraints)
*   **Worker (前端)**：多執行緒，唯讀，絕對 Wait-Free。只允許 `load(Acquire)` 與 `try_send`。
*   **Daemon (背景)**：單執行緒，獨佔寫入。負責 `store(Release)`、EBR 垃圾回收與 SIMD 運算。

---

## Phase 1: 前端讀取管線 (Worker Read Path)
**觸發條件**：外部呼叫 `get(Key)`

1.  **[EBR 進入]** 宣告 `guard = crossbeam_epoch::pin()`。
2.  **[座標計算]** `hash = hasher.hash(Key)`。
3.  **[T1 盲狙 - L1 Cache]**
    *   `idx = hash & t1.mask`
    *   `ptr = t1.slots[idx].load(Acquire, guard)`
    *   若 `ptr != null` 且 `ptr->key == Key` $\rightarrow$ **命中 (Goto 7)**。
4.  **[T2 攔截 - L3 Cache]**
    *   `idx = hash & t2.mask`
    *   `ptr = t2.slots[idx].load(Acquire, guard)`
    *   若 `ptr != null` 且 `ptr->key == Key` $\rightarrow$ **命中 (Goto 7)**。
5.  **[L3 探測 - DRAM]**
    *   `tag = hash >> 48`
    *   `idx = hash & l3.index_mask`
    *   **Loop (最多 16 次):**
        *   `entry = l3.index[idx].load(Acquire)`
        *   若 `entry == 0` $\rightarrow$ **未命中 (Goto 8)**。
        *   若 `(entry >> 48) == tag`:
            *   `g_idx = entry & 0x0000_FFFF_FFFF_FFFF`
            *   `ptr = l3.nodes[g_idx].load(Acquire, guard)`
            *   若 `ptr != null` 且 `ptr->key == Key` $\rightarrow$ **命中 (Goto 7)**。
        *   `idx = (idx + 1) & l3.index_mask`
    *   **未命中 (Goto 8)**。
6.  *(保留防呆)*
7.  **[命中結算 (Hit)]**
    *   `hit_tx.try_send(g_idx)` (若 Channel 滿則直接丟棄，Lossy)。
    *   回傳 `ptr->value`，釋放 `guard`。結束。
8.  **[未命中結算 (Miss)]**
    *   回傳 `None`，釋放 `guard`。結束。

---

## Phase 2: 背景統計與晉升管線 (Daemon Sync Flow)
**觸發條件**：Daemon 每次 Event Loop 循環的開頭。

1.  **[提取統計流]**
    *   `while let Ok(g_idx) = hit_rx.try_recv()` 提取所有命中紀錄。
2.  **[計算全域均值]**
    *   `avg = arena.count_sum / arena.capacity` (若 capacity 為 0 則 avg = 0)。
3.  **[注入階級獎勵 (O(1) 原地提權)]**
    *   `arena.rank[g_idx] = saturating_add(arena.rank[g_idx], avg * 2)`
    *   `arena.count_sum += (增加的差值)`
4.  **[指標晉升 (Promotion)]**
    *   若 `arena.rank[g_idx] > T1_THRESHOLD`:
        *   `hash = arena.hashes[g_idx]`
        *   `ptr = l3.nodes[g_idx].load(Relaxed)`
        *   `t1.slots[hash & t1.mask].store(ptr, Release)`
    *   否則，若 `arena.rank[g_idx] > T2_THRESHOLD`:
        *   `hash = arena.hashes[g_idx]`
        *   `ptr = l3.nodes[g_idx].load(Relaxed)`
        *   `t2.slots[hash & t2.mask].store(ptr, Release)`

---

## Phase 3: 背景代謝管線 (Daemon Eviction Flow)
**觸發條件**：當 `Insert` 需要空槽位，但 `arena.free_list.is_empty()` 時。

1.  **[鐘擺掃描]**
    *   `avg = arena.count_sum / arena.capacity`
    *   **Loop (直到 `free_list` 至少有 1 個空位):**
        *   `idx = arena.cursor`
        *   `r = arena.rank[idx]`
        *   若 `r <= avg` $\rightarrow$ **執行擊殺 (Goto 2)**。
        *   若 `r > avg` $\rightarrow$ **執行衰減 (Goto 3)**。
2.  **[擊殺與 O(1) 清理 (Kill)]**
    *   `arena.rank[idx] = 0`
    *   `arena.count_sum -= r`
    *   **[L3 索引 O(1) 拔除]**:
        *   `hash = arena.hashes[idx]`
        *   `tag = hash >> 48`
        *   從 `hash & l3.index_mask` 開始探測 `l3.index`，找到對應的 `tag` 與 `idx`，執行 `store(0, Release)`。
    *   **[Ghost Set 續命]**: 將 `hash` 寫入 `admission.ghost_set`。
    *   **[EBR 延遲釋放]**:
        *   `old_ptr = l3.nodes[idx].load(Relaxed)`
        *   `guard.defer_destroy(old_ptr)` (交給 Crossbeam 背景回收實體記憶體)。
        *   `l3.nodes[idx].store(null, Release)`
    *   **[回收槽位]**: `arena.free_list.push(idx)`。
    *   前進 `cursor = (cursor + 1) % capacity`，結束本次 Loop。
3.  **[衰減 (Decay)]**
    *   `arena.rank[idx] -= avg`
    *   `arena.count_sum -= avg`
    *   前進 `cursor = (cursor + 1) % capacity`，繼續 Loop。

---

## Phase 4: 背景寫入管線 (Daemon Insert Flow)
**觸發條件**：從 `cmd_rx` 收到 `Command::Insert(Key, Value)`。

1.  **[准入過濾 (Admission)]**
    *   `hash = hasher.hash(Key)`
    *   檢查 `ghost_set` 與 `probation`。若未達標 $\rightarrow$ 丟棄，結束。
2.  **[獲取實體槽位]**
    *   若 `arena.free_list.is_empty()` $\rightarrow$ 觸發 **Phase 3 (Eviction Flow)**。
    *   `g_idx = arena.free_list.pop()`
3.  **[實體寫入 (RCU 降維版)]**
    *   `new_node = Box::into_raw(Box::new(Node { key: Key, value: Value, ... }))`
    *   `l3.nodes[g_idx].store(new_node, Release)`
4.  **[L3 索引寫入 (Linear Probing)]**
    *   `tag = hash >> 48`
    *   `entry = (tag << 48) | g_idx`
    *   從 `hash & l3.index_mask` 開始探測 `l3.index`。
    *   找到 `0` (空位) 或 `tag` 相同的廢棄位，執行 `store(entry, Release)`。
5.  **[Arena 狀態初始化]**
    *   `arena.hashes[g_idx] = hash` (建立反向映射，供未來 O(1) 淘汰使用)。
    *   `arena.rank[g_idx] = INIT_COUNT` (例如 2)。
    *   `arena.count_sum += INIT_COUNT`。結束。

---

## config::adaptive_config<K, V>() 逻辑流程

1. 编译期基础检查（断言） 
    * 确保节点类型 Node<K, V> 的大小不为零（拒绝零大小类型）。
    * 确保原子指针的大小为 8 字节（假定 64 位架构）。
2. 计算 T1 大小（L1 缓存固定预算） 
    * 设定 T1 数组的目标物理字节数为 16KB（不占满整个 L1，留出空间给调用栈和节点实体）。
    * 由于 T1 是纯指针数组，每个指针占 8 字节。
    * 计算槽位数 = 16KB / 8 = 2048，并向上取整为 2 的幂（此处已是 2048）。
    * 得到 t1_slots = 2048。
3. 计算主缓存容量（基于内存预算） 
    * 设定预分配给缓存的总物理内存预算为 512 MB。
    * 用 512 MB 除以单个节点的大小（node_size），得到原始条目数（向下取整）。
    * 将该原始条目数向上取整为 2 的幂，作为主缓存总容量 capacity。
4. 计算 T2 大小（温数据拦截器） 
    * 取主缓存容量的 1/5（即 capacity / 5）。
    * 将该值向上取整为 2 的幂，并确保不小于 4096（最小槽位下限）。
    * 得到 t2_capacity。
5. 设置基准生存期 
    * duration 固定为 60 秒。
6. 组装配置结构体 
    * 将上述计算的 capacity, t1_slots, t2_capacity, duration 存入 Config。
7. 调试期后置条件验证（仅 debug 构建） 
    * 断言 t1_slots, t2_capacity, capacity 都是 2 的幂。
    * 断言 T1 的实际字节数（t1_slots * 8）不超过 32KB（L1 安全上限）。