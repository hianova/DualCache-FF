# DualCache-FF (Fast and Furious) 0.2.1

> **A highly opinionated, absolutely wait-free concurrent cache in Rust, optimized for extreme read-to-write ratios and scan-resistance. Now with full `no_std` support, progressive CPU spin-then-yield optimizations, graceful lifecycle shutdown, dynamic thread ID recycling, and zero external dependencies.**

`DualcacheFF` is not a general-purpose cache. It is a specialized, high-density concurrent primitive built on **CQRS (Command Query Responsibility Segregation)**, **QSBR (Quiet State Based Reclamation)**, and a novel **Avg-based Clock Eviction Algorithm**.

By deliberately abandoning heavy API contracts (like strict linearizability and global LFU history) in favor of CPU spatial locality and wait-free semantics, `DualcacheFF` achieves up to **80x higher throughput** than standard W-TinyLFU implementations (like Moka) under hostile workloads.

## 📊 Performance Benchmark Summary (0.2.1)

`DualCacheFF` v0.2.1 introduces **Dynamic Thread ID Recycling** and **Cold-Start L1 Filter Bypass**, restoring the cache hit rate under heavy concurrent read/write workloads from ~70% to **84.5% - 84.7%** (outperforming Moka by ~4.0% and TinyUFO by ~4.9%), while sustaining an extreme wait-free throughput of **93M - 103M ops/s** (up to 50x faster than Moka and 16x faster than TinyUFO). For the full detailed analysis, see [PERF.md](PERF.md).

`DualCacheFF` 0.2.0 completely removes `crossbeam` dependencies, replacing them with custom wait-free primitives, resulting in a **40-60% throughput boost** over v0.1.0. For the full detailed analysis, see [perf_report.md](perf_report.md).

### Throughput & Hit Rate (50% Read / 50% Write Zipf Workload)
| Cache | Throughput (ops/s) | Hit Rate |
| :--- | :--- | :--- |
| **DualCacheFF (v0.2.1)** | **88,438,573** | **84.56%** |
| **TinyUFO** | 7,859,547 | 79.77% |
| **Moka** | 2,439,712 | 80.55% |

### Latency Distribution (Zipf, 2M ops)
| Metric | DualCacheFF | Moka | TinyUFO |
| :--- | :--- | :--- | :--- |
| **P50** | **42 ns** | 333 ns | 83 ns |
| **P99** | **333 ns** | 7,084 ns | 1,667 ns |
| **P99.9** | **708 ns** | 105,542 ns | 4,875 ns |

### Memory Efficiency (per item, 1M items)
| Cache | Bytes per Item |
| :--- | :--- |
| **DualCacheFF** | **54.62 B** |
| **TinyUFO** | 201.17 B |
| **Moka** | 232.23 B |

---

*Why the leap in 0.2.0? By replacing standard channels with a **State-Gated LossyQueue**, we eliminated the Parker/Unparker wake-up overhead and false sharing in TLS buffers. The read path remains 100% wait-free.*

## ⚖️ The 0.2.0 Evolution

1. **Zero External Dependencies**: Removed `crossbeam-channel` and `crossbeam-utils`. All concurrency primitives (LossyQueue, CachePadded, OneshotAck) are now custom-built for zero overhead.
2. **`no_std` & Embedded Support**: The core engine is now `no_std` compatible (requires `alloc`). Optimized for RTOS environments where the Daemon can be scheduled as a manual task.
3. **State-Gated Lossy Pipeline**: Uses a 3-state turnstile (EMPTY/WRITING/READY) to ensure the Daemon never reads partially written data while maintaining a completely non-blocking writer path.
4. **Time-Based TLS Flush**: Introduced `daemon_tick` to force-flush TLS buffers even under low write pressure, eliminating the "split-brain" visibility lag in high-concurrency scenarios.

## 🧠 Internal Architecture

### 1. Three-Tier Promotion System
- **T1 (Hot Cache):** A high-speed `AtomicPtr` slot array mapping to Cache indices. Holds the most frequently accessed nodes for instant lookup.
- **T2 (Secondary Filter):** A larger slot array for capturing secondary heat patterns.
- **Cache (Main Storage):** The source of truth. Uses an open-addressed index (Linear Probing) and a flat `AtomicPtr<Node>` array for zero-allocation wait-free reads.

### 2. The Circular Clock with Revolution Shield
- **Revolution Shield**: Hit items are refilled to `MAX_RANK` (3), granting them multiple sweeps of guaranteed survival.
- **Avg-based Decay**: Elements with rank below the global average are evicted; others are decayed, ensuring instant adaptation to workload shifts.

### 3. High-Performance Admission
- **Ghost Set Resurrection**: Evicted items leave a 16-bit fingerprint. Re-inserting a "ghost" item bypasses all filters for immediate promotion.
- **TLS Local Probation**: A zero-contention 4KB Bloom-like filter in every thread filters out "one-hit wonders" before they reach the Daemon.
- **Batched Telemetry**: Hits are buffered in TLS (64 items) and flushed as a single batch using our custom `LossyQueue`.

## 📜 License

This project is licensed under the [**MIT License**](LICENSE).

---

*Project co-developed and optimized with Antigravity.*
