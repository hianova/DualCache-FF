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
                 Peak Mem RSS: 5072.00 KB
  - Execution Time:  4.68ms
  - Real Hit Rate:   89.53%
  - Net Footprint:   1488.00 KB
  - Avg Cost/Item:   744.00 Bytes (Footprint / Capacity)

running 0 tests

test result: ok. 0 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out; finished in 0.00s

Generating zipf keys (Total 2,000,000 ops)...
Aligned benchmark physical capacity: 131072

=== DualCacheFF ===
  Real Hit Rate: 83.06%
  [READ ] P50:       42 ns | P90:      208 ns | P99:      458 ns | P99.9:      708 ns | P99.99:    11125 ns | Max:  8156291 ns
  [WRITE] P50:       42 ns | P90:      250 ns | P99:      541 ns | P99.9:     1333 ns | P99.99:    12583 ns | Max:  5306208 ns
Running Memory Benchmarks (Isolated Processes)...

--- DualCacheFF ---
    Baseline (empty) RSS: 1.94 MB
          After Init RSS: 41.08 MB
    After 1M Inserts RSS: 69.23 MB
DualcacheFF overhead per item: 54.57 bytes

========== Summary ==========
Refer to output logs above for per-item overheads.
Generating zipf keys (Total 1000000 ops)...
Aligned benchmark physical capacity: 131072

=== DualCacheFF Read/Write Ratios ===
| Read/Write Ratio | Throughput (ops/s) | Hit Rate (%) |
|------------------|--------------------|--------------|
| 0% Read / 100% Write |        45302592.32 |        0.00% |
| 10% Read / 90% Write |        33804245.63 |       85.79% |
| 25% Read / 75% Write |        45817702.81 |       85.79% |
| 50% Read / 50% Write |        42259473.76 |       85.78% |
| 75% Read / 25% Write |        44576026.93 |       85.54% |
| 100% Read / 0% Write |        57224331.51 |       81.53% |
Generating zipf keys (Total 50000000 ops)...
Aligned benchmark physical capacity: 1048576

===================================================================
== Sampling Specification: 1000 operations sampled ==
===================================================================
Found 556 unique hot keys from the first 1000 ops.

[Scenario A] Normal Insert Baseline (Cold Start, No Warmup)
  [Initial   ] Hit Rate:  80.73% | Throughput:  56306569.45 ops/s
  [Growth    ] Hit Rate:  89.63% | Throughput:  66993445.81 ops/s
  [Plateau   ] Hit Rate:  89.26% | Throughput:  55168815.11 ops/s

[Scenario B] Snapshot Fast Pass (Injecting 556 Hot Keys)
  (Fast Pass Warmup took 400.833µs)
  [Initial   ] Hit Rate:  76.62% | Throughput:  44476813.68 ops/s
  [Growth    ] Hit Rate:  89.61% | Throughput:  56662054.25 ops/s
  [Plateau   ] Hit Rate:  90.19% | Throughput:  46602729.04 ops/s

=== Hit Rate Improvement ===
  Initial Stage:  -4.11%
  Growth Stage :  -0.02%
  Plateau Stage:  +0.93%

===================================================================
== Sampling Specification: 10000 operations sampled ==
===================================================================
Found 4053 unique hot keys from the first 10000 ops.

[Scenario A] Normal Insert Baseline (Cold Start, No Warmup)
  [Initial   ] Hit Rate:  80.73% | Throughput:  46948724.90 ops/s
  [Growth    ] Hit Rate:  89.56% | Throughput:  63109934.73 ops/s
  [Plateau   ] Hit Rate:  90.21% | Throughput:  57946401.21 ops/s

[Scenario B] Snapshot Fast Pass (Injecting 4053 Hot Keys)
  (Fast Pass Warmup took 412.917µs)
  [Initial   ] Hit Rate:  80.37% | Throughput:  50208994.94 ops/s
  [Growth    ] Hit Rate:  88.47% | Throughput:  70395888.88 ops/s
  [Plateau   ] Hit Rate:  89.57% | Throughput:  54763781.56 ops/s

=== Hit Rate Improvement ===
  Initial Stage:  -0.37%
  Growth Stage :  -1.09%
  Plateau Stage:  -0.64%

===================================================================
== Sampling Specification: 50000 operations sampled ==
===================================================================
Found 16030 unique hot keys from the first 50000 ops.

[Scenario A] Normal Insert Baseline (Cold Start, No Warmup)
  [Initial   ] Hit Rate:  75.70% | Throughput:  37533663.00 ops/s
  [Growth    ] Hit Rate:  89.60% | Throughput:  59289986.21 ops/s
  [Plateau   ] Hit Rate:  89.54% | Throughput:  55397384.48 ops/s

[Scenario B] Snapshot Fast Pass (Injecting 16030 Hot Keys)
  (Fast Pass Warmup took 1.435125ms)
  [Initial   ] Hit Rate:  81.18% | Throughput:  55306675.52 ops/s
  [Growth    ] Hit Rate:  89.59% | Throughput:  62956580.80 ops/s
  [Plateau   ] Hit Rate:  86.14% | Throughput:  57462598.83 ops/s

=== Hit Rate Improvement ===
  Initial Stage:  +5.48%
  Growth Stage :  -0.01%
  Plateau Stage:  -3.40%

Running throughput benchmarks with OPS_PER_BENCH = 50000000
Aligned benchmark physical capacity: 1048576

=== DualCacheFF Workload: uniform ===
  - Throughput (引擎空轉吞吐): 46881186.10 ops/s
  - DB Penetrates (潛在穿透次數): 46275078
  - Hit Rate (真實業務命中率): 7.45%


=== StaticDualCache Workload: uniform ===
  - Throughput (引擎空轉吞吐): 15983389.85 ops/s
  - DB Penetrates (潛在穿透次數): 45018772
  - Hit Rate (真實業務命中率): 9.96%


=== DualCacheFF Workload: zipf ===
  - Throughput (引擎空轉吞吐): 47254081.08 ops/s
  - DB Penetrates (潛在穿透次數): 10538877
  - Hit Rate (真實業務命中率): 78.92%


=== StaticDualCache Workload: zipf ===
  - Throughput (引擎空轉吞吐): 25608072.75 ops/s
  - DB Penetrates (潛在穿透次數): 6917911
  - Hit Rate (真實業務命中率): 86.16%


=== DualCacheFF Workload: scan ===
  - Throughput (引擎空轉吞吐): 63823309.87 ops/s
  - DB Penetrates (潛在穿透次數): 46265622
  - Hit Rate (真實業務命中率): 7.47%


=== StaticDualCache Workload: scan ===
  - Throughput (引擎空轉吞吐): 17706793.21 ops/s
  - DB Penetrates (潛在穿透次數): 45019272
  - Hit Rate (真實業務命中率): 9.96%


=== DualCacheFF Workload: mixed ===
  - Throughput (引擎空轉吞吐): 43135161.28 ops/s
  - DB Penetrates (潛在穿透次數): 33678795
  - Hit Rate (真實業務命中率): 32.64%


=== StaticDualCache Workload: mixed ===
  - Throughput (引擎空轉吞吐): 20497355.00 ops/s
  - DB Penetrates (潛在穿透次數): 32538800
  - Hit Rate (真實業務命中率): 34.92%
```
