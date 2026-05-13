# DualCache-FF (Fast and Furious)

> **A highly opinionated, absolutely wait-free concurrent cache in Rust, optimized for extreme read-to-write ratios and scan-resistance.**

`DualcacheFF` is not a general-purpose cache. It is a specialized, high-density concurrent primitive built on **CQRS (Command Query Responsibility Segregation)**, **QSBR (Quiet State Based Reclamation)**, and a novel **Avg-based Clock Eviction Algorithm**.

By deliberately abandoning heavy API contracts (like strict linearizability and global LFU history) in favor of CPU spatial locality and wait-free semantics, `DualcacheFF` achieves up to **35x higher throughput** than standard W-TinyLFU implementations (like Moka) under hostile workloads.

## 📊 Performance Benchmark Summary

`DualCacheFF` is designed for extreme performance. Below is a summary of how it compares to standard W-TinyLFU (Moka) and TinyUFO. For the full detailed analysis, see [perf_report.md](perf_report.md).

### Throughput (Zipf Workload)
| Cache | Throughput (ops/s) | Hit Rate |
| :--- | :--- | :--- |
| **DualCacheFF** | **47,657,976** | 82.76% |
| **TinyUFO** | 9,971,967 | 82.45% |
| **Moka** | 4,099,235 | 83.53% |

### Latency Distribution (Zipf, 2M ops)
| Metric | DualCacheFF | Moka | TinyUFO |
| :--- | :--- | :--- | :--- |
| **P50** | **42 ns** | 583 ns | 166 ns |
| **P99** | **291 ns** | 10250 ns | 3375 ns |
| **P99.9** | **750 ns** | 234834 ns | 14125 ns |

### Memory Efficiency (per item)
| Cache | Bytes per Item |
| :--- | :--- |
| **DualCacheFF** | **50.78 B** |
| **TinyUFO** | 201.17 B |
| **Moka** | 232.27 B |


---

*Why such a massive gap? Moka pays the cost of global history maintenance and thread-local synchronization on every miss/eviction. `DualcacheFF` offloads all mutations to a single asynchronous Daemon, keeping the read path entirely lock-free and pointer-chasing to an absolute minimum.*

## ⚖️ The Heretical Trade-offs

This extreme performance is not magic; it is the result of brutal physical trade-offs. To use this cache, you must accept its worldview:

1. **Eventual Consistency over Linearizability:** 
   Mutations (`Insert`) are dispatched via a bounded MPSC channel to a background Daemon. Under extreme write pressure, inserts may be filtered by TLS probation or dropped by the channel to protect the front-end.
2. **Matthew Effect over Global History:**
   Instead of a heavy Count-Min Sketch for all historical data, we use a **Circular Clock with Revolution Shield**. We reward current hot elements heavily, utilizing Zipf's law to protect true hot spots while maintaining extreme CPU efficiency.
3. **Lossy Fingerprinting over Precise Tombstones:**
   To mitigate Cache Penetration without contention, we use a **Ghost Set** of 16-bit fingerprints. It operates entirely wait-free and ensures that previously hot items can be resurrected instantly without going through probation again.

## 🧠 Internal Architecture

### 1. Three-Tier Promotion System
- **T1 (Hot Cache):** A high-speed `AtomicPtr` slot array mapping to Cache indices. Holds the most frequently accessed nodes for instant lookup.
- **T2 (Secondary Filter):** A larger slot array for capturing secondary heat patterns, cleared on removals to maintain strict consistency.
- **Cache (Main Storage):** The source of truth. Uses an open-addressed index (Linear Probing) and a flat `AtomicPtr<Node>` array for zero-allocation wait-free reads.

### 2. The Circular Clock with Revolution Shield
Instead of a complex bi-directional pendulum, eviction is handled by a streamlined circular scan over the `Arena` with dynamic decay:
- **Revolution Shield**: Hit items are refilled to `MAX_RANK` (3), granting them multiple sweeps of guaranteed survival regardless of global heat.
- **Deferred-Sort Maintenance**: The Daemon sorts incoming hit signals to perform Cache updates in sequential memory order, maximizing CPU prefetcher efficiency.
- **Avg-based Decay**: Elements with rank below the global average are evicted; others are decayed by 1, ensuring the cache adapts instantly to workload shifts.

### 3. High-Performance Admission (Ghost Set + TLS Probation)
- **Ghost Set Resurrection**: Evicted items leave a 16-bit fingerprint. Re-inserting a "ghost" item bypasses all filters for immediate promotion.
- **TLS Local Probation**: A zero-contention 4KB Bloom-like filter in every thread filters out "one-hit wonders" before they ever reach the background Daemon.
- **Batched Telemetry**: Hits are buffered in TLS (64 items) and flushed as a single batch, reducing channel contention by 98%.


## 📜 License

This project is licensed under the **MIT License**. See the [LICENSE](LICENSE) file for details.

---

*project supported by gemini 3.1 pro*
