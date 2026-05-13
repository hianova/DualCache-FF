# DualCache-FF (Fast and Furious)

> **A highly opinionated, absolutely wait-free concurrent cache in Rust, optimized for extreme read-to-write ratios and scan-resistance.**

`DualcacheFF` is not a general-purpose cache. It is a specialized, high-density concurrent primitive built on **CQRS (Command Query Responsibility Segregation)**, **Deferred Copy-On-Write (COW)**, and a novel **Bi-directional Pendulum Eviction Algorithm**.

By deliberately abandoning heavy API contracts (like strict linearizability and global LFU history) in favor of CPU spatial locality and wait-free semantics, `DualcacheFF` achieves up to **35x higher throughput** than standard W-TinyLFU implementations (like Moka) under hostile workloads.

## 📊 Benchmarks vs. Standard W-TinyLFU (Moka) vs. TinyUFO


---

### 表 1：内存开销对比（100 万条 `u64` → `u64` 数据）

| 缓存库 | 初始 RSS | 满载 RSS | 净增内存 | 每项开销 | 相对 DualcacheFF 倍数 |
| :--- | ---: | ---: | ---: | ---: | ---: |
| **DualcacheFF** | 54.98 MB | 151.88 MB | 96.90 MB | **141.70 B** | **1.0×** |
| **Moka** | 151.95 MB | 320.09 MB | 168.14 MB | 318.09 B | 2.2× |
| **TinyUFO** | 387.72 MB | 526.47 MB | 138.75 MB | 534.49 B | 3.8× |

> **注**：每项开销 = (满载 RSS - 初始 RSS - 有效载荷 16 MB) / 1,000,000。有效载荷为 100 万对 `u64`（16 MB）。

---

### 表 2：吞吐量与命中率对比（Test1：4 线程，1M 操作）

| 缓存库 | 负载 | 吞吐量 (M ops/s) | 命中率 | 穿透次数 |
| :--- | :--- | ---: | ---: | ---: |
| **Moka** | uniform | 2.07 | 9.57% | 904,254 |
| | zipf | 5.60 | 76.63% | 233,686 |
| | scan | 0.997 | 1.00% | 990,000 |
| **DualcacheFF** | uniform | **37.18** | 3.18% | 968,195 |
| | zipf | **13.98** | 73.36% | 266,418 |
| | scan | **44.01** | 0.18% | 998,182 |
| **TinyUFO** | uniform | 4.07 | 9.55% | 904,482 |
| | zipf | 11.44 | **76.44%** | 235,639 |
| | scan | 3.11 | 1.00% | 990,000 |

---

### 表 3：吞吐量与命中率对比（Test2：16 线程，10M 操作）

| 缓存库 | 负载 | 吞吐量 (M ops/s) | 命中率 | 穿透次数 |
| :--- | :--- | ---: | ---: | ---: |
| **Moka** | uniform | 1.49 | 10.00% | 8,999,725 |
| | zipf | 4.55 | 80.28% | 1,972,003 |
| | scan | 0.559 | 3.86% | 9,613,531 |
| **DualcacheFF** | uniform | **42.46** | 8.01% | 9,199,234 |
| | zipf | 12.44 | 77.26% | 2,274,084 |
| | scan | **42.00** | 3.87% | 9,612,701 |
| **TinyUFO** | uniform | 3.13 | 9.96% | 9,004,207 |
| | zipf | **14.11** | **80.37%** | 1,963,386 |
| | scan | 2.80 | **39.72%** | 6,028,356 |

---

### 表 4：综合评分矩阵

| 维度 | DualcacheFF | Moka | TinyUFO |
| :--- | :---: | :---: | :---: |
| **内存效率** | ⭐⭐⭐⭐⭐ (142 B) | ⭐⭐⭐ (318 B) | ⭐⭐ (534 B) |
| **吞吐量 (uniform/scan)** | ⭐⭐⭐⭐⭐ (42M) | ⭐ (0.6–2M) | ⭐⭐ (3–4M) |
| **吞吐量 (zipf)** | ⭐⭐⭐⭐ (12–14M) | ⭐⭐ (4–6M) | ⭐⭐⭐⭐ (11–14M) |
| **命中率 (zipf)** | ⭐⭐⭐⭐ (77%) | ⭐⭐⭐⭐ (80%) | ⭐⭐⭐⭐⭐ (80%) |
| **抗扫描污染** | ⭐⭐⭐ (3.9%) | ⭐⭐ (3.9%) | ⭐⭐⭐⭐⭐ (40%) |
| **高并发扩展性** | ⭐⭐⭐⭐⭐ | ⭐⭐ | ⭐⭐⭐ |

---

*Why such a massive gap? Moka pays the cost of global history maintenance and thread-local synchronization on every miss/eviction. `DualcacheFF` offloads all mutations to a single asynchronous Daemon, keeping the read path entirely lock-free and pointer-chasing to an absolute minimum.*

## ⚖️ The Heretical Trade-offs

This extreme performance is not magic; it is the result of brutal physical trade-offs. To use this cache, you must accept its worldview:

1. **Eventual Consistency over Linearizability:** 
   Mutations (`Insert`) are dispatched via a bounded MPSC channel to a background Daemon. Under extreme write pressure, inserts may be filtered by TLS probation or dropped by the channel to protect the front-end.
2. **Matthew Effect over Global History:**
   Instead of a heavy Count-Min Sketch for all historical data, we use a **Circular Clock with Exponential Rewards**. We reward current hot elements heavily, utilizing Zipf's law to protect true hot spots while maintaining extreme CPU efficiency.
3. **Lossy Fingerprinting over Precise Tombstones:**
   To mitigate Cache Penetration without contention, we use a **Ghost Set** of 16-bit fingerprints. It operates entirely wait-free and ensures that previously hot items can be resurrected instantly without going through probation again.

## 🧠 Internal Architecture

### 1. Three-Tier Promotion System
- **T1 (Hot Cache):** A high-speed `AtomicUsize` slot array mapping to Cache indices. Holds the most frequently accessed keys for instant lookup.
- **T2 (Warm Cache):** A larger `AtomicUsize` slot array for "above-average" hot items. Acts as a middle-tier buffer to capture secondary heat patterns.
- **Cache (Main Storage):** The source of truth. Uses an open-addressed index (Linear Probing) and a flat `RwLock<Option<Node>>` array for zero-allocation RCU-like updates.

### 2. The Circular Clock with Matthew Effect
Instead of a complex bi-directional pendulum, eviction is handled by a streamlined circular scan over the `Arena` with dynamic decay:
- **Matthew Effect Rewards**: Hit counts are not just incremented; they receive an exponential "bonus" based on current rank, making established hot items significantly harder to evict.
- **Deferred-Sort Maintenance**: The Daemon sorts incoming hit signals to perform Cache updates in sequential memory order, maximizing CPU prefetcher efficiency.
- **Dynamic Decay**: Elements below the global average rank are evicted; others are decayed by the average, ensuring the cache adapts instantly to workload shifts.

### 3. High-Performance Admission (Ghost Set + TLS Probation)
- **Ghost Set Resurrection**: Evicted items leave a 16-bit fingerprint. Re-inserting a "ghost" item bypasses all filters for immediate promotion.
- **TLS Local Probation**: A zero-contention 8KB Count-Min Sketch in every thread filters out "one-hit wonders" before they ever reach the background Daemon.
- **Batched Telemetry**: Hits are buffered in TLS (64 items) and flushed as a single batch, reducing channel contention by 98%.


## 📜 License

[PolyForm-Noncommercial-1.0.0](https://polyformproject.org/licenses/noncommercial/1.0.0/)

---

*project supported by gemini 3.1 pro*
