# Performance Guide - dualcache-ff

## Benchmark Results

```text
running 40 tests
test cache::extra_coverage_tests::test_wake_daemon_if_parked ... ignored
test cache::tests::test_daemon_command_insert_coverage ... ignored
test cache::tests::test_daemon_panic_guard ... ignored
test cache::tests::test_daemon_shutdown_with_garbage ... ignored
test cache::tests::test_quiescent ... ignored
test components::extra_coverage_tests::test_allocator_missed_lines ... ignored
test components::tests::test_cache_padded ... ignored
test components::tests::test_cache_padded_align ... ignored
test components::tests::test_default_spawner ... ignored
test components::tests::test_default_tls_methods ... ignored
test components::tests::test_id_allocator_concurrent_via_tls ... ignored
test components::tests::test_id_allocator_exhaustion - should panic ... ignored
test components::tests::test_id_allocator_is_allocated ... ignored
test components::tests::test_worker_state ... ignored
test config::tests::test_config_flush_tick ... ignored
test config::tests::test_config_memory_budget_asserts ... ignored
test config::tests::test_config_new_expert_invalid_capacity - should panic ... ignored
test config::tests::test_config_new_expert_invalid_t1 - should panic ... ignored
test config::tests::test_config_new_expert_invalid_t1_size - should panic ... ignored
test config::tests::test_config_new_expert_invalid_t2 - should panic ... ignored
test config::tests::test_config_new_expert_valid ... ignored
test config::tests::test_config_poll_clamping ... ignored
test core_cache::tests::test_core_cache_drop ... ignored
test core_cache::tests::test_core_cache_insert_variations ... ignored
test lossy_queue::tests::test_lossy_queue_basic ... ignored
test lossy_queue::tests::test_lossy_queue_drop_does_not_leak ... ignored
test lossy_queue::tests::test_lossy_queue_len_and_drops ... ignored
test lossy_queue::tests::test_lossy_queue_mpsc ... ignored
test lossy_queue::tests::test_lossy_queue_non_power_of_two - should panic ... ignored
test lossy_queue::tests::test_lossy_queue_send_blocking ... ignored
test lossy_queue::tests::test_oneshot_ack ... ignored
test lossy_queue::tests::test_oneshot_ack_timeout ... ignored
test static_cache::static_cache::tests::test_static_cache_coverage ... ignored
test sync::std_impl::tests::test_new_arc_slice ... ignored
test sync::std_impl::tests::test_unsafe_cell_get_with ... ignored
test sync::std_impl::tests::test_unsafe_cell_with_mut ... ignored
test workers::tests::test_batch_buf_drop ... ignored
test workers::tests::test_batch_buf_push_and_drain ... ignored
test workers::tests::test_worker_slot_default ... ignored
test workers::tests::test_worker_slot_safe_access ... ignored

test result: ok. 0 passed; 0 failed; 40 ignored; 0 measured; 0 filtered out; finished in 0.00s

Generating realistic zipf distribution...
--- CAPEX Constraint Benchmark (Isolated Processes) ---
Capacity: 2048 Items | Total Ops: 200000 (Single Thread)
Generating realistic zipf distribution...

=== DualCacheFF (Static) (CAPEX Constrained) ===
             Baseline Mem RSS: 3584.00 KB
                 Peak Mem RSS: 5088.00 KB
  - Execution Time:  7.61ms
  - Real Hit Rate:   89.51%
  - Net Footprint:   1504.00 KB
  - Avg Cost/Item:   752.00 Bytes (Footprint / Capacity)

running 0 tests

test result: ok. 0 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out; finished in 0.00s

Generating zipf keys (Total 2,000,000 ops)...
Aligned benchmark physical capacity: 131072

=== DualCacheFF ===
  Real Hit Rate: 84.54%
  [READ ] P50:       84 ns | P90:      250 ns | P99:      458 ns | P99.9:      625 ns | P99.99:    30875 ns | Max:  3248166 ns
  [WRITE] P50:       84 ns | P90:      292 ns | P99:      750 ns | P99.9:     1292 ns | P99.99:    23125 ns | Max:  4143458 ns
Running Memory Benchmarks (Isolated Processes)...

--- DualCacheFF ---
    Baseline (empty) RSS: 1.92 MB
          After Init RSS: 41.08 MB
    After 1M Inserts RSS: 68.20 MB
DualcacheFF overhead per item: 53.50 bytes

========== Summary ==========
Refer to output logs above for per-item overheads.
Generating zipf keys (Total 1000000 ops)...
Aligned benchmark physical capacity: 131072

=== DualCacheFF Read/Write Ratios ===
| Read/Write Ratio | Throughput (ops/s) | Hit Rate (%) |
|------------------|--------------------|--------------|
| 0% Read / 100% Write |        14173206.16 |        0.00% |
| 10% Read / 90% Write |        16530826.80 |       85.87% |
| 25% Read / 75% Write |        23250970.18 |       85.76% |
| 50% Read / 50% Write |        22771046.44 |       85.40% |
| 75% Read / 25% Write |        29439291.31 |       85.70% |
| 100% Read / 0% Write |        28384663.97 |       74.54% |
Generating zipf keys (Total 50000000 ops)...
Aligned benchmark physical capacity: 1048576

===================================================================
== Sampling Specification: 1000 operations sampled ==
===================================================================
Found 547 unique hot keys from the first 1000 ops.

[Scenario A] Normal Insert Baseline (Cold Start, No Warmup)
  [Initial   ] Hit Rate:  80.23% | Throughput:  36580124.19 ops/s
  [Growth    ] Hit Rate:  89.70% | Throughput:  39268736.20 ops/s
  [Plateau   ] Hit Rate:  89.96% | Throughput:  40289087.62 ops/s

[Scenario B] Snapshot Fast Pass (Injecting 547 Hot Keys)
  (Fast Pass Warmup took 205.833µs)
  [Initial   ] Hit Rate:  80.68% | Throughput:  52679636.64 ops/s
  [Growth    ] Hit Rate:  89.66% | Throughput:  56601089.13 ops/s
  [Plateau   ] Hit Rate:  89.87% | Throughput:  45126517.11 ops/s

=== Hit Rate Improvement ===
  Initial Stage:  +0.45%
  Growth Stage :  -0.04%
  Plateau Stage:  -0.09%

===================================================================
== Sampling Specification: 10000 operations sampled ==
===================================================================
Found 4058 unique hot keys from the first 10000 ops.

[Scenario A] Normal Insert Baseline (Cold Start, No Warmup)
  [Initial   ] Hit Rate:  73.33% | Throughput:  57458468.30 ops/s
  [Growth    ] Hit Rate:  89.25% | Throughput:  48115316.37 ops/s
  [Plateau   ] Hit Rate:  89.28% | Throughput:  44361033.38 ops/s

[Scenario B] Snapshot Fast Pass (Injecting 4058 Hot Keys)
  (Fast Pass Warmup took 695.334µs)
  [Initial   ] Hit Rate:  71.11% | Throughput:  63808574.28 ops/s
  [Growth    ] Hit Rate:  86.34% | Throughput:  49779667.17 ops/s
  [Plateau   ] Hit Rate:  87.34% | Throughput:  49939232.82 ops/s

=== Hit Rate Improvement ===
  Initial Stage:  -2.22%
  Growth Stage :  -2.91%
  Plateau Stage:  -1.93%

===================================================================
== Sampling Specification: 50000 operations sampled ==
===================================================================
Found 16229 unique hot keys from the first 50000 ops.

[Scenario A] Normal Insert Baseline (Cold Start, No Warmup)
  [Initial   ] Hit Rate:  80.16% | Throughput:  40369311.38 ops/s
  [Growth    ] Hit Rate:  89.61% | Throughput:  56329918.07 ops/s
  [Plateau   ] Hit Rate:  89.95% | Throughput:  47095417.17 ops/s

[Scenario B] Snapshot Fast Pass (Injecting 16229 Hot Keys)
  (Fast Pass Warmup took 1.02025ms)
  [Initial   ] Hit Rate:  81.17% | Throughput:  55855780.38 ops/s
  [Growth    ] Hit Rate:  89.69% | Throughput:  41931814.15 ops/s
  [Plateau   ] Hit Rate:  89.53% | Throughput:  45946756.61 ops/s

=== Hit Rate Improvement ===
  Initial Stage:  +1.01%
  Growth Stage :  +0.08%
  Plateau Stage:  -0.42%

Running throughput benchmarks with OPS_PER_BENCH = 50000000
Aligned benchmark physical capacity: 1048576

=== DualCacheFF Workload: uniform ===
  - Throughput (引擎空轉吞吐): 27734440.14 ops/s
  - DB Penetrates (潛在穿透次數): 46149734
  - Hit Rate (真實業務命中率): 7.70%


=== StaticDualCache Workload: uniform ===
  - Throughput (引擎空轉吞吐): 6583012.31 ops/s
  - DB Penetrates (潛在穿透次數): 45022440
  - Hit Rate (真實業務命中率): 9.96%


=== DualCacheFF Workload: zipf ===
  - Throughput (引擎空轉吞吐): 12776522.27 ops/s
  - DB Penetrates (潛在穿透次數): 29840023
  - Hit Rate (真實業務命中率): 40.32%


=== StaticDualCache Workload: zipf ===
  - Throughput (引擎空轉吞吐): 12449408.45 ops/s
  - DB Penetrates (潛在穿透次數): 6909787
  - Hit Rate (真實業務命中率): 86.18%


=== DualCacheFF Workload: scan ===
  - Throughput (引擎空轉吞吐): 41888502.63 ops/s
  - DB Penetrates (潛在穿透次數): 46221577
  - Hit Rate (真實業務命中率): 7.56%


=== StaticDualCache Workload: scan ===
  - Throughput (引擎空轉吞吐): 10625566.03 ops/s
  - DB Penetrates (潛在穿透次數): 45018943
  - Hit Rate (真實業務命中率): 9.96%


=== DualCacheFF Workload: mixed ===
  - Throughput (引擎空轉吞吐): 39506498.01 ops/s
  - DB Penetrates (潛在穿透次數): 32839259
  - Hit Rate (真實業務命中率): 34.32%


=== StaticDualCache Workload: mixed ===
  - Throughput (引擎空轉吞吐): 19906039.51 ops/s
  - DB Penetrates (潛在穿透次數): 30839743
  - Hit Rate (真實業務命中率): 38.32%
```
