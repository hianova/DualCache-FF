use std::time::Instant;
use hdrhistogram::Histogram;
use rand::Rng;
use rand::distributions::Uniform;
use rand::prelude::Distribution;
use rand_distr::Zipf;
use crossbeam_utils::thread;
use dualcache_ff::DualCacheFF;
use std::sync::{Arc, Barrier};

const THREAD_COUNT: usize = 4;
const TOTAL_OPS: usize = 10_000_000;
const OPS_PER_THREAD: usize = TOTAL_OPS / THREAD_COUNT;
const DATASET_SIZE: u64 = 1_000_000;
const CACHE_L1_SIZE: usize = 1024; // Per thread
const CACHE_T0_CAP: usize = 256;
const CACHE_T1_CAP: usize = 4096;
const CACHE_T2_CAP: usize = 131072;
const TOTAL_CAP: usize = CACHE_T0_CAP + CACHE_T1_CAP + CACHE_T2_CAP;

type BenchCache = DualCacheFF<u64, u64, dualcache_ff::core::config::DefaultExponentialPolicy, CACHE_T0_CAP, CACHE_T1_CAP, CACHE_T2_CAP, TOTAL_CAP>;

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
    let mut base_cache = DualCacheFF::new(THREAD_COUNT + 1, CACHE_L1_SIZE);
    base_cache.set_daemon_mode(true);
    let cache: Arc<BenchCache> = Arc::new(base_cache);

    let warmup_handle = cache.register_thread();
    let mut rng = rand::thread_rng();
    let uniform = Uniform::new(0, DATASET_SIZE);
    let zipf = Zipf::new(DATASET_SIZE, 1.5).unwrap();
    
    for _ in 0..100_000 {
        let key = match pattern {
            AccessPattern::Uniform => uniform.sample(&mut rng),
            AccessPattern::Zipf => zipf.sample(&mut rng) as u64,
            AccessPattern::Scan => uniform.sample(&mut rng), // Warmup uniform for scan
        };
        cache.insert(key, key, &warmup_handle);
    }

    let barrier = Arc::new(Barrier::new(THREAD_COUNT));

    let start_time = Instant::now();

    let mut total_hits = 0;
    let mut total_ops = 0;
    let mut merged_hist = Histogram::<u64>::new(3).unwrap();

    thread::scope(|s| {
        let mut handles = vec![];
        
        for thread_id in 0..THREAD_COUNT {
            let cache_clone = cache.clone();
            let barrier_clone = barrier.clone();
            
            handles.push(s.spawn(move |_| {
                let tls_handle = cache_clone.register_thread();
                let mut rng = rand::thread_rng();
                let uniform_dist = Uniform::new(0, DATASET_SIZE);
                let zipf_dist = Zipf::new(DATASET_SIZE, 1.5).unwrap();
                
                let mut hist = Histogram::<u64>::new(3).unwrap();
                let mut hits = 0;
                let mut local_ops = 0;
                
                let shift_offset = if shift_dataset { DATASET_SIZE / 2 } else { 0 };
                let shift_trigger = OPS_PER_THREAD / 2; // Shift halfway

                // Pre-generate operations to eliminate RNG overhead from the benchmark loop
                let mut ops_data = Vec::with_capacity(OPS_PER_THREAD);
                for i in 0..OPS_PER_THREAD {
                    let mut key = match pattern {
                        AccessPattern::Uniform => uniform_dist.sample(&mut rng),
                        AccessPattern::Zipf => zipf_dist.sample(&mut rng) as u64,
                        AccessPattern::Scan => ((i + thread_id * OPS_PER_THREAD) as u64) % DATASET_SIZE,
                    };
                    
                    if shift_dataset && i > shift_trigger {
                        key = (key + shift_offset) % DATASET_SIZE;
                    }
                    let is_read = rng.gen_range(0..100) < read_ratio_percent;
                    ops_data.push((key, is_read));
                }

                barrier_clone.wait(); // Synchronize all threads to start

                for (i, &(key, is_read)) in ops_data.iter().enumerate() {
                    
                    let measure_latency = i % 100 == 0;
                    let op_start = if measure_latency { Some(Instant::now()) } else { None };
                    
                    if is_read {
                        if cache_clone.get(&key, &tls_handle).is_some() {
                            hits += 1;
                        } else {
                            // Insert on read miss (realistic cache behavior)
                            cache_clone.insert(key, key, &tls_handle);
                        }
                    } else {
                        cache_clone.insert(key, key, &tls_handle);
                    }
                    
                    if let Some(start) = op_start {
                        let elapsed = start.elapsed().as_nanos() as u64;
                        hist.record(elapsed).unwrap();
                    }
                    local_ops += 1;
                }
                
                (hits, local_ops, hist)
            }));
        }

        for handle in handles {
            let (hits, ops, hist) = handle.join().unwrap();
            total_hits += hits;
            total_ops += ops;
            merged_hist.add(hist).unwrap();
        }
    }).unwrap();

    let duration = start_time.elapsed();
    let throughput = (total_ops as f64) / duration.as_secs_f64();
    let hit_rate = (total_hits as f64) / (total_ops as f64) * 100.0;

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
    println!("* **Cache Size**: ~{} (L2) + ~{} (L1 per thread)", TOTAL_CAP, CACHE_L1_SIZE);
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

    println!("| Pattern | R/W Ratio | Throughput (ops/s) | Hit Rate (%) | P50 (ns) | P90 (ns) | P99 (ns) | P99.9 (ns) | P99.99 (ns) |");
    println!("|---------|-----------|-------------------|-------------|----------|----------|----------|------------|-------------|");

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
