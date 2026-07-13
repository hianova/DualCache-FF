# DualCache-FF Refactored v1.0.0 Benchmarking Results
* **Threads**: 4
* **Dataset Size**: 10000000
* **Operations per test**: 40000000
* **Cache Size**: ~2000000 (L2) + ~4096 (L1 per thread)

Running DualCacheFF (Wait-Free + Daemon)...

### Mode: DualCacheFF (Wait-Free + Daemon)
| Pattern | R/W Ratio | Throughput (ops/s) | Hit Rate (%) | P50 (ns) | P90 (ns) | P99 (ns) | P99.9 (ns) | P99.99 (ns) |
|---------|-----------|-------------------|-------------|----------|----------|----------|------------|-------------|
Warming up cache for Daemon mode...
| Zipf (99:1)             | 99: 1 |         100507900 |       85.12% |       41 |       84 |      209 |        375 |        1208 |
Warming up cache for Daemon mode...
| Zipf (90:10)            | 90:10 |         124305009 |       85.40% |       42 |      125 |      250 |        458 |        4167 |
Warming up cache for Daemon mode...
| Zipf (50:50)            | 50:50 |           1806267 |       85.12% |       42 |      208 |      459 |       3791 |        4833 |
Warming up cache for Daemon mode...
| Uniform (99:1)          | 99: 1 |            995818 |       19.01% |      167 |      334 |      791 |       4334 |        4875 |
Running DualCacheFF (Wait-Free + CATA-DC Tuning)...

### Mode: DualCacheFF (Wait-Free + CATA-DC Tuning)
| Pattern | R/W Ratio | Throughput (ops/s) | Hit Rate (%) | P50 (ns) | P90 (ns) | P99 (ns) | P99.9 (ns) | P99.99 (ns) |
|---------|-----------|-------------------|-------------|----------|----------|----------|------------|-------------|
Warming up cache for CATA-DC mode...
| Zipf (99:1)             | 99: 1 |         118648299 |       85.73% |       42 |      125 |      250 |        334 |        2959 |
Warming up cache for CATA-DC mode...
| Zipf (90:10)            | 90:10 |         112786327 |       85.67% |       42 |      125 |      250 |        500 |        4334 |
Running StaticDualCache (Default Pseudo-LFU)...

### Mode: StaticDualCache (Default Pseudo-LFU)
| Pattern | R/W Ratio | Throughput (ops/s) | Hit Rate (%) | P50 (ns) | P90 (ns) | P99 (ns) | P99.9 (ns) | P99.99 (ns) |
|---------|-----------|-------------------|-------------|----------|----------|----------|------------|-------------|
Warming up cache for Static Default mode...
| Zipf (99:1)             | 99: 1 |          42736763 |       93.14% |       42 |      292 |      500 |       2125 |        4375 |
Warming up cache for Static Default mode...
| Zipf (90:10)            | 90:10 |          34412855 |       91.72% |       42 |      333 |      542 |       1708 |        4334 |
Warming up cache for Static Default mode...
| Zipf (50:50)            | 50:50 |          30960579 |       91.73% |       84 |      333 |      584 |       2459 |        4542 |
Warming up cache for Static Default mode...
| Uniform (99:1)          | 99: 1 |          15384536 |       10.48% |      250 |      375 |      875 |       3083 |        4500 |
     Running benches/extreme_optimization.rs (target/release/deps/extreme_optimization-4b974f5df6e55fad)
Gnuplot not found, using plotters backend
Benchmarking data_structure_latency/put_t0_single_thread
Benchmarking data_structure_latency/put_t0_single_thread: Warming up for 3.0000 s
Benchmarking data_structure_latency/put_t0_single_thread: Collecting 100 samples in estimated 5.0000 s (499M iterations)
Benchmarking data_structure_latency/put_t0_single_thread: Analyzing
data_structure_latency/put_t0_single_thread
                        time:   [30.840 ns 32.671 ns 34.155 ns]
                        change: [-14.970% -5.1318% +6.0153%] (p = 0.36 > 0.05)
                        No change in performance detected.
Benchmarking data_structure_latency/put_t2_single_thread
Benchmarking data_structure_latency/put_t2_single_thread: Warming up for 3.0000 s
Benchmarking data_structure_latency/put_t2_single_thread: Collecting 100 samples in estimated 5.0003 s (83M iterations)
Benchmarking data_structure_latency/put_t2_single_thread: Analyzing
data_structure_latency/put_t2_single_thread
                        time:   [108.51 ns 112.59 ns 116.24 ns]
                        change: [+1.2950% +5.7436% +10.435%] (p = 0.01 < 0.05)
                        Performance has regressed.
Found 5 outliers among 100 measurements (5.00%)
  1 (1.00%) low mild
  4 (4.00%) high mild

Benchmarking tls_parallel_overhead/get_block_mut_contention/1
Benchmarking tls_parallel_overhead/get_block_mut_contention/1: Warming up for 3.0000 s
Benchmarking tls_parallel_overhead/get_block_mut_contention/1: Collecting 100 samples in estimated 5.1006 s (197k iterations)
Benchmarking tls_parallel_overhead/get_block_mut_contention/1: Analyzing
tls_parallel_overhead/get_block_mut_contention/1
                        time:   [24.949 µs 25.365 µs 25.892 µs]
                        change: [-3.4247% -1.4155% +0.4976%] (p = 0.17 > 0.05)
                        No change in performance detected.
Found 11 outliers among 100 measurements (11.00%)
  4 (4.00%) low mild
  4 (4.00%) high mild
  3 (3.00%) high severe
Benchmarking tls_parallel_overhead/get_block_mut_contention/4
Benchmarking tls_parallel_overhead/get_block_mut_contention/4: Warming up for 3.0000 s
Benchmarking tls_parallel_overhead/get_block_mut_contention/4: Collecting 100 samples in estimated 5.0371 s (91k iterations)
Benchmarking tls_parallel_overhead/get_block_mut_contention/4: Analyzing
tls_parallel_overhead/get_block_mut_contention/4
                        time:   [48.659 µs 51.238 µs 54.495 µs]
                        change: [-9.9881% -1.8176% +5.8144%] (p = 0.66 > 0.05)
                        No change in performance detected.
Found 7 outliers among 100 measurements (7.00%)
  3 (3.00%) high mild
  4 (4.00%) high severe
Benchmarking tls_parallel_overhead/get_block_mut_contention/8
Benchmarking tls_parallel_overhead/get_block_mut_contention/8: Warming up for 3.0000 s
Benchmarking tls_parallel_overhead/get_block_mut_contention/8: Collecting 100 samples in estimated 5.1571 s (56k iterations)
Benchmarking tls_parallel_overhead/get_block_mut_contention/8: Analyzing
tls_parallel_overhead/get_block_mut_contention/8
                        time:   [124.45 µs 147.63 µs 177.87 µs]
                        change: [+32.889% +59.795% +87.520%] (p = 0.00 < 0.05)
                        Performance has regressed.
Found 13 outliers among 100 measurements (13.00%)
  4 (4.00%) high mild
  9 (9.00%) high severe
Benchmarking tls_parallel_overhead/get_block_mut_contention/16
Benchmarking tls_parallel_overhead/get_block_mut_contention/16: Warming up for 3.0000 s
Benchmarking tls_parallel_overhead/get_block_mut_contention/16: Collecting 100 samples in estimated 5.7093 s (35k iterations)
Benchmarking tls_parallel_overhead/get_block_mut_contention/16: Analyzing
