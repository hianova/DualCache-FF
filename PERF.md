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
  - Execution Time:  4.60ms
  - Real Hit Rate:   89.58%
  - Net Footprint:   1488.00 KB
  - Avg Cost/Item:   744.00 Bytes (Footprint / Capacity)

running 0 tests

test result: ok. 0 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out; finished in 0.00s

Generating zipf keys (Total 2,000,000 ops)...
Aligned benchmark physical capacity: 131072

=== DualCacheFF ===
  Real Hit Rate: 83.73%
  [READ ] P50:       83 ns | P90:      250 ns | P99:      417 ns | P99.9:      667 ns | P99.99:    10917 ns | Max:   181542 ns
  [WRITE] P50:       84 ns | P90:      292 ns | P99:      791 ns | P99.9:     1500 ns | P99.99:     8917 ns | Max:    82709 ns
Running Memory Benchmarks (Isolated Processes)...

--- DualCacheFF ---
    Baseline (empty) RSS: 1.92 MB
          After Init RSS: 41.08 MB
    After 1M Inserts RSS: 67.55 MB
DualcacheFF overhead per item: 52.81 bytes

========== Summary ==========
Refer to output logs above for per-item overheads.
Generating zipf keys (Total 1000000 ops)...
Aligned benchmark physical capacity: 131072

=== DualCacheFF Read/Write Ratios ===
| Read/Write Ratio | Throughput (ops/s) | Hit Rate (%) |
|------------------|--------------------|--------------|
| 0% Read / 100% Write |        42499840.63 |        0.00% |
| 10% Read / 90% Write |        35553817.37 |       85.91% |
| 25% Read / 75% Write |        39807663.70 |       85.87% |
| 50% Read / 50% Write |        42111690.73 |       85.60% |
| 75% Read / 25% Write |        43508132.04 |       85.43% |
| 100% Read / 0% Write |        49854591.61 |       81.57% |
Generating zipf keys (Total 50000000 ops)...
Aligned benchmark physical capacity: 1048576

===================================================================
== Sampling Specification: 1000 operations sampled ==
===================================================================
Found 564 unique hot keys from the first 1000 ops.

[Scenario A] Normal Insert Baseline (Cold Start, No Warmup)
  [Initial   ] Hit Rate:  80.77% | Throughput:  55354765.37 ops/s
  [Growth    ] Hit Rate:  89.61% | Throughput:  64541344.11 ops/s
  [Plateau   ] Hit Rate:  90.06% | Throughput:  53413949.87 ops/s

[Scenario B] Snapshot Fast Pass (Injecting 564 Hot Keys)
  (Fast Pass Warmup took 190.875µs)
  [Initial   ] Hit Rate:  80.65% | Throughput:  48728590.67 ops/s
  [Growth    ] Hit Rate:  89.70% | Throughput:  58055651.97 ops/s
  [Plateau   ] Hit Rate:  89.95% | Throughput:  43701968.20 ops/s

=== Hit Rate Improvement ===
  Initial Stage:  -0.12%
  Growth Stage :  +0.09%
  Plateau Stage:  -0.12%

===================================================================
== Sampling Specification: 10000 operations sampled ==
===================================================================
Found 4089 unique hot keys from the first 10000 ops.

[Scenario A] Normal Insert Baseline (Cold Start, No Warmup)
  [Initial   ] Hit Rate:  80.49% | Throughput:  42833277.38 ops/s
  [Growth    ] Hit Rate:  89.64% | Throughput:  62073942.14 ops/s
  [Plateau   ] Hit Rate:  89.28% | Throughput:  51478560.79 ops/s

[Scenario B] Snapshot Fast Pass (Injecting 4089 Hot Keys)
  (Fast Pass Warmup took 571.625µs)
  [Initial   ] Hit Rate:  81.11% | Throughput:  37823925.99 ops/s
  [Growth    ] Hit Rate:  89.63% | Throughput:  66709822.49 ops/s
  [Plateau   ] Hit Rate:  89.90% | Throughput:  54530331.62 ops/s

=== Hit Rate Improvement ===
  Initial Stage:  +0.62%
  Growth Stage :  -0.01%
  Plateau Stage:  +0.62%

===================================================================
== Sampling Specification: 50000 operations sampled ==
===================================================================
Found 16204 unique hot keys from the first 50000 ops.

[Scenario A] Normal Insert Baseline (Cold Start, No Warmup)
  [Initial   ] Hit Rate:  80.64% | Throughput:  47532565.51 ops/s
  [Growth    ] Hit Rate:  89.65% | Throughput:  59951456.11 ops/s
  [Plateau   ] Hit Rate:  89.60% | Throughput:  54092738.26 ops/s

[Scenario B] Snapshot Fast Pass (Injecting 16204 Hot Keys)
  (Fast Pass Warmup took 1.121042ms)
  [Initial   ] Hit Rate:  81.73% | Throughput:  46857611.43 ops/s
  [Growth    ] Hit Rate:  89.69% | Throughput:  64064748.11 ops/s
  [Plateau   ] Hit Rate:  89.69% | Throughput:  54510301.60 ops/s

=== Hit Rate Improvement ===
  Initial Stage:  +1.09%
  Growth Stage :  +0.04%
  Plateau Stage:  +0.10%

Running throughput benchmarks with OPS_PER_BENCH = 50000000
Aligned benchmark physical capacity: 1048576

=== DualCacheFF Workload: uniform ===
  - Throughput (引擎空轉吞吐): 38456595.81 ops/s
  - DB Penetrates (潛在穿透次數): 45925991
  - Hit Rate (真實業務命中率): 8.15%


=== StaticDualCache Workload: uniform ===
  - Throughput (引擎空轉吞吐): 15611479.20 ops/s
  - DB Penetrates (潛在穿透次數): 45019716
  - Hit Rate (真實業務命中率): 9.96%


=== DualCacheFF Workload: zipf ===
  - Throughput (引擎空轉吞吐): 44956896.48 ops/s
  - DB Penetrates (潛在穿透次數): 11625210
  - Hit Rate (真實業務命中率): 76.75%


=== StaticDualCache Workload: zipf ===
  - Throughput (引擎空轉吞吐): 27690938.49 ops/s
  - DB Penetrates (潛在穿透次數): 6910643
  - Hit Rate (真實業務命中率): 86.18%


=== DualCacheFF Workload: scan ===
  - Throughput (引擎空轉吞吐): 51577398.01 ops/s
  - DB Penetrates (潛在穿透次數): 46222549
  - Hit Rate (真實業務命中率): 7.55%


=== StaticDualCache Workload: scan ===
  - Throughput (引擎空轉吞吐): 16127237.23 ops/s
  - DB Penetrates (潛在穿透次數): 45019075
  - Hit Rate (真實業務命中率): 9.96%


=== DualCacheFF Workload: mixed ===
  - Throughput (引擎空轉吞吐): 44393134.19 ops/s
  - DB Penetrates (潛在穿透次數): 33015906
  - Hit Rate (真實業務命中率): 33.97%


=== StaticDualCache Workload: mixed ===
  - Throughput (引擎空轉吞吐): 18168757.87 ops/s
  - DB Penetrates (潛在穿透次數): 31717565
  - Hit Rate (真實業務命中率): 36.56%
```
