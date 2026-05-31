mod common;
use common::Cache;
use dualcache_ff::{Config, DualCacheFF};
use moka::sync::Cache as MokaCache;
use tinyufo::TinyUfo;
use rand::distributions::Distribution;
use rand::Rng;
use rand_distr::Zipf;
use std::sync::Arc;
use std::time::{Duration, Instant};

const CAPACITY: u64 = 100_000;
const KEY_SPACE: u64 = 1_000_000;
const THREADS: usize = 4;
const TOTAL_OPS: u64 = 5_000_000; // 5M ops for fast but representative runs

fn start_timeout_watchdog(timeout: Duration) {
    std::thread::spawn(move || {
        std::thread::sleep(timeout);
        eprintln!("Benchmark timed out after {:?}", timeout);
        std::process::exit(101);
    });
}

fn bench_ratio<C>(cache: Arc<C>, read_percentage: u32, keys: &[u64]) -> (f64, f64)
where
    C: Cache<u64, u64> + Send + Sync + 'static,
{
    let ops_per_thread = (TOTAL_OPS / THREADS as u64) as usize;
    let start_time = Instant::now();

    std::thread::scope(|s| {
        let mut handles = Vec::new();
        for t_id in 0..THREADS {
            let cache = Arc::clone(&cache);
            let start_idx = t_id * ops_per_thread;
            let end_idx = start_idx + ops_per_thread;
            let thread_keys = &keys[start_idx..std::cmp::min(end_idx, keys.len())];

            handles.push(s.spawn(move || {
                let mut rng = rand::thread_rng();
                let mut misses = 0;
                let mut gets = 0;
                for &key in thread_keys {
                    let is_read = rng.gen_bool(read_percentage as f64 / 100.0);
                    if is_read {
                        gets += 1;
                        if cache.get(&key).is_none() {
                            cache.insert(key, key);
                            misses += 1;
                        }
                    } else {
                        cache.insert(key, key);
                    }
                }
                (misses, gets)
            }));
        }
        let results: Vec<(u64, u64)> = handles.into_iter().map(|h| h.join().unwrap()).collect();
        let total_misses: u64 = results.iter().map(|r| r.0).sum();
        let total_gets: u64 = results.iter().map(|r| r.1).sum();
        let elapsed = start_time.elapsed();
        let throughput = TOTAL_OPS as f64 / elapsed.as_secs_f64();
        let hit_rate = if total_gets > 0 {
            100.0 * (1.0 - (total_misses as f64 / total_gets as f64))
        } else {
            0.0
        };
        (throughput, hit_rate)
    })
}

fn run_ratios_for_cache<C>(cache_factory: impl Fn() -> Arc<C>, name: &str, keys: &[u64], capacity: usize)
where
    C: Cache<u64, u64> + 'static,
{
    println!("\n=== {} Read/Write Ratios ===", name);
    println!("| Read/Write Ratio | Throughput (ops/s) | Hit Rate (%) |");
    println!("|------------------|--------------------|--------------|");

    let ratios = vec![
        (0, "0% Read / 100% Write"),
        (10, "10% Read / 90% Write"),
        (25, "25% Read / 75% Write"),
        (50, "50% Read / 50% Write"),
        (75, "75% Read / 25% Write"),
        (100, "100% Read / 0% Write"),
    ];

    for (read_percentage, label) in ratios {
        let cache = cache_factory();
        // Warmup with capacity inserts
        for i in 0..capacity {
            cache.insert(i as u64, i as u64);
        }
        cache.sync();
        std::thread::sleep(Duration::from_millis(50));

        let (throughput, hit_rate) = bench_ratio(cache, read_percentage, keys);
        println!("| {:<18} | {:>18.2} | {:>11.2}% |", label, throughput, hit_rate);
    }
}

fn main() {
    start_timeout_watchdog(Duration::from_secs(120)); // 2 minutes watchdog

    let args: Vec<String> = std::env::args().collect();
    let is_full_bench = args.iter().any(|a| a == "--full_bench") || cfg!(feature = "full_bench");

    println!("Generating zipf keys (Total {} ops)...", TOTAL_OPS);
    let zipf = Zipf::new(KEY_SPACE, 1.0).unwrap();
    let mut rng = rand::thread_rng();
    let keys: Vec<u64> = (0..TOTAL_OPS)
        .map(|_| zipf.sample(&mut rng) as u64)
        .collect();

    let config = Config::with_memory_budget((CAPACITY * 128 / 1024 / 1024) as usize, 60);
    let actual_capacity = config.capacity;
    println!("Aligned benchmark physical capacity: {}", actual_capacity);

    // 1. Benchmark DualCacheFF
    run_ratios_for_cache(
        || {
            Arc::new(DualCacheFF::new(config))
        },
        "DualCacheFF",
        &keys,
        actual_capacity,
    );

    // 2. Benchmark Moka if full_bench
    if is_full_bench {
        run_ratios_for_cache(
            || Arc::new(MokaCache::builder().max_capacity(actual_capacity as u64).build()),
            "Moka",
            &keys,
            actual_capacity,
        );
    }

    // 3. Benchmark TinyUFO if full_bench
    if is_full_bench {
        run_ratios_for_cache(
            || Arc::new(TinyUfo::new(actual_capacity, actual_capacity)),
            "TinyUFO",
            &keys,
            actual_capacity,
        );
    }
}
