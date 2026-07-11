# DualCache-FF Refactored v1.0.0 Benchmarking Results

* **Threads**: 4
* **Dataset Size**: 10000000
* **Operations per test**: 40000000
* **Cache Size**: ~1196032 (L2) + ~4096 (L1 per thread)
* **Environment**: `cargo bench` on release profile

## 1. Throughput & Hit Rate (End-to-End Workloads)

### Mode: DualCacheFF (Wait-Free + Daemon)
| Pattern | R/W Ratio | Throughput (ops/s) | Hit Rate (%) | P50 (ns) | P90 (ns) | P99 (ns) | P99.9 (ns) | P99.99 (ns) |
|---------|-----------|-------------------|-------------|----------|----------|----------|------------|-------------|
| Zipf (99:1)             | 99: 1 |         119699539 |       85.08% |       42 |       84 |      209 |        458 |        4375 |
| Zipf (90:10)            | 90:10 |         117660757 |       85.41% |       42 |      125 |      250 |        458 |        4250 |
| Zipf (50:50)            | 50:50 |           7111988 |       85.08% |       42 |      167 |      375 |       3708 |        4750 |
| Uniform (99:1)          | 99: 1 |           3917929 |       18.99% |      167 |      292 |      666 |       4375 |        4875 |

### Mode: DualCacheFF (Wait-Free + CATA-DC Tuning)
| Pattern | R/W Ratio | Throughput (ops/s) | Hit Rate (%) | P50 (ns) | P90 (ns) | P99 (ns) | P99.9 (ns) | P99.99 (ns) |
|---------|-----------|-------------------|-------------|----------|----------|----------|------------|-------------|
| Zipf (99:1)             | 99: 1 |         104917127 |       85.65% |       42 |      125 |      250 |        500 |        4417 |
| Zipf (90:10)            | 90:10 |         109309566 |       85.60% |       42 |      125 |      250 |        458 |        4375 |

### Mode: StaticDualCache (Default Pseudo-LFU Baseline)
| Pattern | R/W Ratio | Throughput (ops/s) | Hit Rate (%) | P50 (ns) | P90 (ns) | P99 (ns) | P99.9 (ns) | P99.99 (ns) |
|---------|-----------|-------------------|-------------|----------|----------|----------|------------|-------------|
| Zipf (99:1)             | 99: 1 |           8829656 |       93.17% |      125 |      291 |      458 |       2416 |        4292 |
| Zipf (90:10)            | 90:10 |           8001213 |       91.78% |      166 |      292 |      500 |       2917 |        4458 |
| Zipf (50:50)            | 50:50 |           7705435 |       91.80% |      208 |      292 |      667 |       3042 |        4792 |
| Uniform (99:1)          | 99: 1 |           4127791 |       10.51% |      250 |      334 |      958 |       3167 |        4666 |

## 2. Extreme Data Structure Latency (Wait-Free Arena Overhead)

These tests measure the raw overhead of `DualCacheCore` node allocation, promotion, and QSBR retirement mechanisms.

| Operation | Latency (Mean) | Deviation |
|-----------|----------------|-----------|
| `put_t0_single_thread` | ~37.5 ns | ±2 ns |
| `put_t2_single_thread` | ~175.3 ns | ±4 ns |

*(Note: Data structure latency measurements are taken via `criterion` benchmarking with single-thread node iteration.)*
