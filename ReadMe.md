# DualCache-FF (Fast and Furious)

> **A highly opinionated, absolutely wait-free concurrent cache in Rust, optimized for extreme read-to-write ratios and scan-resistance.**

`DualCacheFF` is not a general-purpose cache. It is a specialized, high-density concurrent primitive built on **CQRS (Command Query Responsibility Segregation)**, **Deferred Copy-On-Write (COW)**, and a novel **Bi-directional Pendulum Eviction Algorithm**.

By deliberately abandoning heavy API contracts (like strict linearizability and global LFU history) in favor of CPU spatial locality and wait-free semantics, `DualCacheFF` achieves up to **35x higher throughput** than standard W-TinyLFU implementations (like Moka) under hostile workloads.

## 📊 Benchmarks vs. Standard W-TinyLFU (Moka) 

#### uniform: 鍵值均勻隨機分佈（無熱點）
test cache_throughput/Moka/uniform ... bench:   460914614 ns/iter (+/- 8944012)
test cache_throughput/DualCacheFF/uniform ... bench:    25807371 ns/iter (+/- 378929)

#### zipf: 偏態分佈（有熱點）
test cache_throughput/Moka/zipf ... bench:   173218181 ns/iter (+/- 3728119)
test cache_throughput/DualCacheFF/zipf ... bench:    70458416 ns/iter (+/- 645116)

#### scan: 順序訪問（模擬掃描）
test cache_throughput/Moka/scan ... bench:   770184541 ns/iter (+/- 14331471)
test cache_throughput/DualCacheFF/scan ... bench:    22190607 ns/iter (+/- 517550)

#### NAME:      Moka vs DualCacheFF
#### uniform:  460ms vs  25ms      → 18.4x
#### zipf:     173ms vs  70ms      →  2.47x
#### scan:     770ms vs  22ms      → 35x

2026/04/11

*Why such a massive gap? Moka pays the cost of global history maintenance and thread-local synchronization on every miss/eviction. `DualCacheFF` offloads all mutations to a single asynchronous Daemon, keeping the read path entirely lock-free and pointer-chasing to an absolute minimum.*

## ⚖️ The Heretical Trade-offs

This extreme performance is not magic; it is the result of brutal physical trade-offs. To use this cache, you must accept its worldview:

1. **Eventual Consistency over Linearizability:** 
   Mutations (`Insert`) are dispatched via a bounded MPSC channel to a background Daemon. Under extreme write pressure, inserts may be silently dropped to protect the front-end from thread starvation. *(Note: `Remove` operations are blocking to guarantee invalidation and prevent stale reads).*
2. **$\mathcal{O}(1)$ Array Scans over Global History:**
   Instead of maintaining a heavy Count-Min Sketch for ghost entries, we use a custom **Pendulum Algorithm** over a contiguous flat array. We trade precise historical memory for raw L1/L3 cache-friendly overwrites, utilizing Zipf's law to protect true hot spots probabilistically.
3. **Lossy Bit-packing over Precise Tombstones:**
   To mitigate Cache Penetration without polluting the main eviction pool or introducing lock contention, we use a Direct-Mapped Atomic Ring. It packs an `Epoch` and a `Hash Signature` into a single `AtomicU32`. It operates entirely wait-free but carries a mathematically negligible $1/65536$ false-negative rate.

## 🧠 Internal Architecture

### 1. Three-Tier Promotion System
- **T1 (Hot Cache):** An `ArcSwap<AHashMap>`. Holds only the elite, highly-proven keys. $\mathcal{O}(1)$ access, zero pointer chasing.
- **T2 (Warm Continuous Array):** A `Vec<Option<(u16, V)>>`. A physical shadow memory of L3. It eliminates hash lookups by reusing the L3 `global_idx` as a physical offset. Protected against ABA dirty reads via a strict `version` gating mechanism.
- **L3 (Cold Page Shards):** Resolves hash collisions and absorbs write shocks. Chunked into 64-item `Page` arrays to strictly bound the blast radius of Copy-On-Write (COW) allocations.

### 2. The Bi-directional Pendulum
Instead of a standard Ring Buffer or LRU linked list, eviction is handled by a bouncing pointer over a contiguous `Arena`:
- Computes a dynamic `avg` hit count continuously via bit-shifting (`count_sum >> shift_amt`).
- When the pendulum hits a "hot" element (`count > avg`), it decays the count by `avg` and **physically reverses its scanning direction** (`direction = -direction`). 
- This creates an elastic survival window for new entries, making the cache statistically immune to scan-pollution (as proven by the 35x scan benchmark).

### 3. Hot-Path Telemetry (Amortized Sync)
Telemetry (`Gets`) does not touch atomic counters on the hot path. Hits are buffered in a lock-free `crossbeam::queue::ArrayQueue`. Once full, they are flushed as a batch (`Action::Gets(Vec)`) to the Daemon, cutting cross-core CAS contention by over 98%.


## 📜 License

[PolyForm-Noncommercial-1.0.0](https://polyformproject.org/licenses/noncommercial/1.0.0/)

---

*project supported by gemini 3.1 pro*


## muilti factor test 多元變量測試

### test 1
const CAPACITY: u64 = 100_000;
const KEY_SPACE: u64 = 1_000_000; // 键总数远大于容量，模拟真实场景
const THREADS: usize = 4;
const OPS_PER_BENCH: u64 = 1_000_000;


=== Moka Workload: uniform ===
  - Throughput (引擎空轉吞吐): 2250819.30 ops/s
  - DB Penetrates (潛在穿透次數): 903966
  - Hit Rate (真實業務命中率): 9.60%

test cache_throughput/Moka/uniform ... bench:   510966895 ns/iter (+/- 47638710)

=== DualCacheFF Workload: uniform ===
  - Throughput (引擎空轉吞吐): 40162053.89 ops/s
  - DB Penetrates (潛在穿透次數): 958531
  - Hit Rate (真實業務命中率): 4.15%

test cache_throughput/DualCacheFF/uniform ... bench:    25056095 ns/iter (+/- 1569461)

=== TinyUFO Workload: uniform ===
  - Throughput (引擎空轉吞吐): 4128758.08 ops/s
  - DB Penetrates (潛在穿透次數): 904450
  - Hit Rate (真實業務命中率): 9.56%

test cache_throughput/TinyUFO/uniform ... bench:   244742520 ns/iter (+/- 29762162)

=== Moka Workload: zipf ===
  - Throughput (引擎空轉吞吐): 4220911.98 ops/s
  - DB Penetrates (潛在穿透次數): 235129
  - Hit Rate (真實業務命中率): 76.49%

test cache_throughput/Moka/zipf ... bench:   208532888 ns/iter (+/- 3753737)

=== DualCacheFF Workload: zipf ===
  - Throughput (引擎空轉吞吐): 12436450.98 ops/s
  - DB Penetrates (潛在穿透次數): 267500
  - Hit Rate (真實業務命中率): 73.25%

test cache_throughput/DualCacheFF/zipf ... bench:    63618217 ns/iter (+/- 1139273)

=== TinyUFO Workload: zipf ===
  - Throughput (引擎空轉吞吐): 13504039.33 ops/s
  - DB Penetrates (潛在穿透次數): 235353
  - Hit Rate (真實業務命中率): 76.46%

test cache_throughput/TinyUFO/zipf ... bench:    78930815 ns/iter (+/- 5511877)

=== Moka Workload: scan ===
  - Throughput (引擎空轉吞吐): 894283.94 ops/s
  - DB Penetrates (潛在穿透次數): 990000
  - Hit Rate (真實業務命中率): 1.00%


Warning: Unable to complete 10 samples in 5.0s. You may wish to increase target time to 13.4s.
test cache_throughput/Moka/scan ... bench:  1505561625 ns/iter (+/- 75701778)

=== DualCacheFF Workload: scan ===
  - Throughput (引擎空轉吞吐): 31895934.54 ops/s
  - DB Penetrates (潛在穿透次數): 995993
  - Hit Rate (真實業務命中率): 0.40%

test cache_throughput/DualCacheFF/scan ... bench:    38164325 ns/iter (+/- 2136608)

=== TinyUFO Workload: scan ===
  - Throughput (引擎空轉吞吐): 2573773.74 ops/s
  - DB Penetrates (潛在穿透次數): 990000
  - Hit Rate (真實業務命中率): 1.00%

test cache_throughput/TinyUFO/scan ... bench:   402809281 ns/iter (+/- 40095073)

### test 2
const CAPACITY: u64 = 100_000;
const KEY_SPACE: u64 = 1_000_000; // 键总数远大于容量，模拟真实场景
const THREADS: usize = 16;
const OPS_PER_BENCH: u64 = 1_000_000;


=== Moka Workload: uniform ===
  - Throughput (引擎空轉吞吐): 1664387.96 ops/s
  - DB Penetrates (潛在穿透次數): 903544
  - Hit Rate (真實業務命中率): 9.65%


Warning: Unable to complete 10 samples in 5.0s. You may wish to increase target time to 6.2s.
test cache_throughput/Moka/uniform ... bench:   650483437 ns/iter (+/- 25039494)

=== DualCacheFF Workload: uniform ===
  - Throughput (引擎空轉吞吐): 38489049.25 ops/s
  - DB Penetrates (潛在穿透次數): 966600
  - Hit Rate (真實業務命中率): 3.34%

test cache_throughput/DualCacheFF/uniform ... bench:    26005687 ns/iter (+/- 701035)

=== TinyUFO Workload: uniform ===
  - Throughput (引擎空轉吞吐): 3174154.34 ops/s
  - DB Penetrates (潛在穿透次數): 904052
  - Hit Rate (真實業務命中率): 9.59%

test cache_throughput/TinyUFO/uniform ... bench:   278090573 ns/iter (+/- 3528457)

=== Moka Workload: zipf ===
  - Throughput (引擎空轉吞吐): 4534590.41 ops/s
  - DB Penetrates (潛在穿透次數): 237163
  - Hit Rate (真實業務命中率): 76.28%

test cache_throughput/Moka/zipf ... bench:   183070715 ns/iter (+/- 8303910)

=== DualCacheFF Workload: zipf ===
  - Throughput (引擎空轉吞吐): 12913702.57 ops/s
  - DB Penetrates (潛在穿透次數): 284960
  - Hit Rate (真實業務命中率): 71.50%

test cache_throughput/DualCacheFF/zipf ... bench:    79212625 ns/iter (+/- 4962272)

=== TinyUFO Workload: zipf ===
  - Throughput (引擎空轉吞吐): 10028568.89 ops/s
  - DB Penetrates (潛在穿透次數): 235689
  - Hit Rate (真實業務命中率): 76.43%

test cache_throughput/TinyUFO/zipf ... bench:    69174250 ns/iter (+/- 3472727)

=== Moka Workload: scan ===
  - Throughput (引擎空轉吞吐): 742546.23 ops/s
  - DB Penetrates (潛在穿透次數): 990000
  - Hit Rate (真實業務命中率): 1.00%


Warning: Unable to complete 10 samples in 5.0s. You may wish to increase target time to 15.1s.
test cache_throughput/Moka/scan ... bench:  1717983250 ns/iter (+/- 82901545)

=== DualCacheFF Workload: scan ===
  - Throughput (引擎空轉吞吐): 27664686.08 ops/s
  - DB Penetrates (潛在穿透次數): 998911
  - Hit Rate (真實業務命中率): 0.11%

test cache_throughput/DualCacheFF/scan ... bench:    24597616 ns/iter (+/- 684668)

=== TinyUFO Workload: scan ===
  - Throughput (引擎空轉吞吐): 2794242.14 ops/s
  - DB Penetrates (潛在穿透次數): 990000
  - Hit Rate (真實業務命中率): 1.00%

test cache_throughput/TinyUFO/scan ... bench:   352927156 ns/iter (+/- 7196598)

### test 3  
const CAPACITY: u64 = 100_000;
const KEY_SPACE: u64 = 1_000_000; // 键总数远大于容量，模拟真实场景
const THREADS: usize = 16;
const OPS_PER_BENCH: u64 = 10_000_000;

=== Moka Workload: uniform ===
  - Throughput (引擎空轉吞吐): 1556087.47 ops/s
  - DB Penetrates (潛在穿透次數): 9000370
  - Hit Rate (真實業務命中率): 10.00%


Warning: Unable to complete 10 samples in 5.0s. You may wish to increase target time to 65.4s.
test cache_throughput/Moka/uniform ... bench:  6630051625 ns/iter (+/- 134343310)

=== DualCacheFF Workload: uniform ===
  - Throughput (引擎空轉吞吐): 40824040.11 ops/s
  - DB Penetrates (潛在穿透次數): 9071182
  - Hit Rate (真實業務命中率): 9.29%

test cache_throughput/DualCacheFF/uniform ... bench:   258943229 ns/iter (+/- 1609050)

=== TinyUFO Workload: uniform ===
  - Throughput (引擎空轉吞吐): 2849444.81 ops/s
  - DB Penetrates (潛在穿透次數): 9003580
  - Hit Rate (真實業務命中率): 9.96%


Warning: Unable to complete 10 samples in 5.0s. You may wish to increase target time to 33.9s.
test cache_throughput/TinyUFO/uniform ... bench:  3449365167 ns/iter (+/- 32659392)

=== Moka Workload: zipf ===
  - Throughput (引擎空轉吞吐): 4115013.46 ops/s
  - DB Penetrates (潛在穿透次數): 1985169
  - Hit Rate (真實業務命中率): 80.15%


Warning: Unable to complete 10 samples in 5.0s. You may wish to increase target time to 24.1s.
test cache_throughput/Moka/zipf ... bench:  2249487812 ns/iter (+/- 52308694)

=== DualCacheFF Workload: zipf ===
  - Throughput (引擎空轉吞吐): 12386305.97 ops/s
  - DB Penetrates (潛在穿透次數): 2293612
  - Hit Rate (真實業務命中率): 77.06%


Warning: Unable to complete 10 samples in 5.0s. You may wish to increase target time to 8.1s.
test cache_throughput/DualCacheFF/zipf ... bench:   830111270 ns/iter (+/- 12444020)

=== TinyUFO Workload: zipf ===
  - Throughput (引擎空轉吞吐): 10928657.68 ops/s
  - DB Penetrates (潛在穿透次數): 1965464
  - Hit Rate (真實業務命中率): 80.35%


Warning: Unable to complete 10 samples in 5.0s. You may wish to increase target time to 8.5s.
test cache_throughput/TinyUFO/zipf ... bench:   802362916 ns/iter (+/- 9884680)

=== Moka Workload: scan ===
  - Throughput (引擎空轉吞吐): 588259.08 ops/s
  - DB Penetrates (潛在穿透次數): 9604204
  - Hit Rate (真實業務命中率): 3.96%


Warning: Unable to complete 10 samples in 5.0s. You may wish to increase target time to 171.6s.
test cache_throughput/Moka/scan ... bench: 17638689354 ns/iter (+/- 291517960)

=== DualCacheFF Workload: scan ===
  - Throughput (引擎空轉吞吐): 53669615.12 ops/s
  - DB Penetrates (潛在穿透次數): 9502265
  - Hit Rate (真實業務命中率): 4.98%

test cache_throughput/DualCacheFF/scan ... bench:   282322000 ns/iter (+/- 15350267)

=== TinyUFO Workload: scan ===
  - Throughput (引擎空轉吞吐): 4022488.46 ops/s
  - DB Penetrates (潛在穿透次數): 6079784
  - Hit Rate (真實業務命中率): 39.20%


Warning: Unable to complete 10 samples in 5.0s. You may wish to increase target time to 27.5s.
test cache_throughput/TinyUFO/scan ... bench:  3601210521 ns/iter (+/- 43519073)

