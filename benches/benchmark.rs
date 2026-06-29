use crossbeam_utils::thread;
use dualcache_ff::DualCacheFF;
use hdrhistogram::Histogram;
use rand::Rng;
use rand::distributions::Uniform;
use rand::prelude::Distribution;
use rand_distr::Zipf;
use std::sync::{Arc, Barrier};
use std::time::Instant;

const THREAD_COUNT: usize = 4;
const TOTAL_OPS: usize = 10_000_000;
const OPS_PER_THREAD: usize = TOTAL_OPS / THREAD_COUNT;
const DATASET_SIZE: u64 = 1_000_000;
const CACHE_T0_CAP: usize = 64;
const CACHE_T1_CAP: usize = 4096;
const CACHE_T2_CAP: usize = 262144;
const TOTAL_CAP: usize = CACHE_T0_CAP + CACHE_T1_CAP + CACHE_T2_CAP;
const MAX_THREADS: usize = 10;
const TLS_CAP: usize = 1024;
const TLS_INDEX_CAP: usize = 2048;

type BenchCache = DualCacheFF<
    u64,
    u64,
    dualcache_ff::core::config::DefaultExponentialPolicy,
    CACHE_T0_CAP,
    CACHE_T1_CAP,
    CACHE_T2_CAP,
    TOTAL_CAP,
    MAX_THREADS,
    TLS_CAP,
    TLS_INDEX_CAP,
>;

static mut GLOBAL_CACHE: BenchCache = DualCacheFF::new();

#[derive(Clone, Copy)]
enum AccessPattern {
    Uniform,
    Zipf,
    Scan,
}

struct BenchResult {
    throughput: f64,
    hit_rate: f64,
    p50: u64,
    p90: u64,
    p99: u64,
    p99_9: u64,
    p99_99: u64,
}

fn run_workload(
    pattern: AccessPattern,
    read_ratio_percent: u8,
    shift_dataset: bool,
) -> BenchResult {
    // Reset the cache for a fair benchmark across runs
    unsafe {
        dualcache_ff::core::qsbr::reset();
        GLOBAL_CACHE = DualCacheFF::new();
    }
    let cache = unsafe { &*std::ptr::addr_of!(GLOBAL_CACHE) };
    cache.set_daemon_mode(true);

    let mut all_ops_data = Vec::new();
    for thread_id in 0..THREAD_COUNT {
        let mut rng = rand::thread_rng();
        let uniform = Uniform::new(0, DATASET_SIZE);
        let zipf = Zipf::new(DATASET_SIZE, 0.99).unwrap();
        let mut ops_data = Vec::with_capacity(OPS_PER_THREAD);
        for i in 0..OPS_PER_THREAD {
            let mut key = match pattern {
                AccessPattern::Uniform => uniform.sample(&mut rng),
                AccessPattern::Zipf => zipf.sample(&mut rng) as u64,
                AccessPattern::Scan => ((i + thread_id * OPS_PER_THREAD) as u64) % DATASET_SIZE,
            };
            if shift_dataset && i > OPS_PER_THREAD / 2 {
                key = (key + DATASET_SIZE / 2) % DATASET_SIZE;
            }
            let is_read = rng.gen_range(0..100) < read_ratio_percent;
            ops_data.push((key, is_read));
        }
        all_ops_data.push(ops_data);
    }

    let warmup_handle = cache.register_thread();
    // Warmup using the actual pattern
    for &(key, _) in all_ops_data[0].iter().take(10_000) {
        cache.insert(key, key, &warmup_handle);
    }

    let barrier = Arc::new(Barrier::new(THREAD_COUNT));

    let start_time = Instant::now();

    let mut total_hits = 0;
    let mut total_ops = 0;
    let mut total_reads = 0;
    let mut merged_hist = Histogram::<u64>::new(3).unwrap();

    thread::scope(|s| {
        let mut handles = vec![];

        for thread_id in 0..THREAD_COUNT {
            let barrier_clone = barrier.clone();
            let ops_data = all_ops_data[thread_id].clone();

            handles.push(s.spawn(move |_| {
                let tls_handle = cache.register_thread();

                let mut hist = Histogram::<u64>::new(3).unwrap();
                let mut hits = 0;
                let mut reads = 0;
                let mut local_ops = 0;

                barrier_clone.wait(); // Synchronize all threads to start

                for (i, &(key, is_read)) in ops_data.iter().enumerate() {
                    let measure_latency = i % 100 == 0;
                    let op_start = if measure_latency {
                        Some(Instant::now())
                    } else {
                        None
                    };

                    if is_read {
                        reads += 1;
                        if cache.get(&key, &tls_handle).is_some() {
                            hits += 1;
                        } else {
                            // Insert on read miss (realistic cache behavior)
                            cache.insert(key, key, &tls_handle);
                        }
                    } else {
                        cache.insert(key, key, &tls_handle);
                    }

                    if let Some(start) = op_start {
                        let elapsed = start.elapsed().as_nanos() as u64;
                        hist.record(elapsed).unwrap();
                    }
                    local_ops += 1;
                }

                (hits, reads, local_ops, hist)
            }));
        }

        for handle in handles {
            let (hits, reads_done, ops, hist) = handle.join().unwrap();
            total_hits += hits;
            total_reads += reads_done;
            total_ops += ops;
            merged_hist.add(hist).unwrap();
        }
    })
    .unwrap();

    let duration = start_time.elapsed();
    let throughput = (total_ops as f64) / duration.as_secs_f64();
    let hit_rate = if total_reads > 0 {
        (total_hits as f64) / (total_reads as f64) * 100.0
    } else {
        0.0
    };

    // Wait for Daemon to gracefully stop (wait a bit so we don't leak immediately)
    // Actually when Arc drops, things die if we implement drop, but for benchmark it's fine

    BenchResult {
        throughput,
        hit_rate,
        p50: merged_hist.value_at_quantile(0.50),
        p90: merged_hist.value_at_quantile(0.90),
        p99: merged_hist.value_at_quantile(0.99),
        p99_9: merged_hist.value_at_quantile(0.999),
        p99_99: merged_hist.value_at_quantile(0.9999),
    }
}

fn main() {
    println!("# DualCache-FF Benchmarking Results");
    println!("* **Threads**: {}", THREAD_COUNT);
    println!("* **Dataset Size**: {}", DATASET_SIZE);
    println!("* **Operations per test**: {}", TOTAL_OPS);
    println!(
        "* **Cache Size**: ~{} (L2) + ~{} (L1 per thread)",
        TOTAL_CAP, TLS_CAP
    );
    println!();

    let configs = vec![
        (AccessPattern::Zipf, 99, false, "Zipf (99:1)"),
        (AccessPattern::Zipf, 90, false, "Zipf (90:10)"),
        (AccessPattern::Zipf, 50, false, "Zipf (50:50)"),
        (AccessPattern::Zipf, 10, false, "Zipf (10:90)"),
        (AccessPattern::Uniform, 99, false, "Uniform (99:1)"),
        (AccessPattern::Scan, 99, false, "Scan (99:1)"),
        (AccessPattern::Zipf, 90, true, "Zipf Data Shift (90:10)"),
    ];

    println!(
        "| Pattern | R/W Ratio | Throughput (ops/s) | Hit Rate (%) | P50 (ns) | P90 (ns) | P99 (ns) | P99.9 (ns) | P99.99 (ns) |"
    );
    println!(
        "|---------|-----------|-------------------|-------------|----------|----------|----------|------------|-------------|"
    );

    std::thread::Builder::new().stack_size(64 * 1024 * 1024).spawn(move || {
        for (pattern, read_ratio, shift, name) in configs {
            let result = run_workload(pattern, read_ratio, shift);
            println!(
                "| {:<23} | {:>2}:{:>2} | {:>17.0} | {:>11.2}% | {:>8} | {:>8} | {:>8} | {:>10} | {:>11} |",
                name,
                read_ratio,
                100 - read_ratio,
                result.throughput,
                result.hit_rate,
                result.p50,
                result.p90,
                result.p99,
                result.p99_9,
                result.p99_99
            );
        }
    }).unwrap().join().unwrap();
}
