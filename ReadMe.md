# DualCache-FF (Fast and Furious) 0.3.1

> **A highly opinionated, absolutely wait-free concurrent cache in Rust, optimized for extreme read-to-write ratios and scan-resistance. Now with full `no_std` support (including allocation-free static caches and zero-overhead stubs), progressive CPU spin-then-yield optimizations, graceful lifecycle shutdown, dynamic thread ID recycling, and zero external dependencies.**

`DualcacheFF` is not a general-purpose cache. It is a specialized, high-density concurrent primitive built on **CQRS (Command Query Responsibility Segregation)**, **QSBR (Quiet State Based Reclamation)**, and a novel **Avg-based Clock Eviction Algorithm**.

By deliberately abandoning heavy API contracts (like strict linearizability and global LFU history) in favor of CPU spatial locality and wait-free semantics, `DualcacheFF` achieves up to **80x higher throughput** than standard W-TinyLFU implementations (like Moka) under hostile workloads.

## 📊 Performance Benchmark Summary (0.3.1)

`DualCacheFF` v0.3.1 introduces a **Zero-Cost Generic TLS Provider (`TlsProvider`)** that completely eliminates dynamic dispatch and branching overhead on the hot path, achieving unprecedented throughput restoration. It integrates **Dynamic Thread ID Recycling**, **Cold-Start L1 Filter Bypass**, and strict capacity budget alignments. It maintains a stable, verified cache hit rate under heavy concurrent read/write workloads at **85.65%**, while sustaining an extreme wait-free throughput of **62.1M - 87.3M ops/s**. For the full detailed analysis, see [PERF.md](PERF.md).

### Throughput & Hit Rate (50% Read / 50% Write Zipf Workload)
| Cache | Throughput (ops/s) | Hit Rate |
| :--- | :--- | :--- |
| **DualCacheFF (v0.3.1)** | **78,964,875** | **85.66%** |
| **TinyUFO** | 10,514,318 | 81.58% |
| **Moka** | 2,980,172 | 82.16% |

### Latency Distribution (Zipf, 2M ops)
| Metric | DualCacheFF | Moka | TinyUFO |
| :--- | :--- | :--- | :--- |
| **P50** | **42 ns** | 292 ns | 84 ns |
| **P99** | **458 ns** | 9,083 ns | 2,125 ns |
| **P99.9** | **1,083 ns** | 97,500 ns | 6,041 ns |

### Memory Efficiency (per item, 1M items)
| Cache | Bytes per Item |
| :--- | :--- |
| **DualCacheFF** | **50.32 B** |
| **TinyUFO** | 201.22 B |
| **Moka** | 232.00 B |

---

*Why the leap in 0.2.0? By replacing standard channels with a **State-Gated LossyQueue**, we eliminated the Parker/Unparker wake-up overhead and false sharing in TLS buffers. The read path remains 100% wait-free.*

## 🔌 Embedded `no_std` Options & Custom TLS (v0.3.1)

Version 0.3.1 implements a **Zero-Cost Generic TLS Abstraction**, enabling custom task-local storage injection in `no_std` environments without the overhead of `dyn Trait`.

In addition to the high-performance concurrent dynamic `DualCacheFF`, it features specialized interfaces under the `static_cache` module for memory-constrained and bare-metal environments:

1. **`StaticDualCache<K, V, const N: usize>` (Zero-Allocation Static Cache)**:
   - **100% `alloc`-free**: Avoids dynamic heap allocations and fragmentation.
   - **Thread-Safe**: Uses slot-level isolation via atomic spinlocks.
   - **API Parity**: Fully supports `get`, `insert`, `remove`, `clear`, and `sync`.
2. **`DualCacheStub<K, V>` (Zero-Overhead Facade)**:
   - **Direct No-Op**: All methods are marked `#[inline(always)]` and evaluate to no-ops.
   - **Zero Physical Footprint**: Optimizes to exactly 0 bytes and 0 CPU cycles in Release mode, allowing caching to be compiled out cleanly.

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
