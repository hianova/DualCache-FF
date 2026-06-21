mod common;
use dualcache_ff::{Config, DualCacheFF};
use rand::distributions::Distribution;
use rand_distr::Zipf;
use std::collections::HashSet;
use std::sync::Arc;
use std::time::{Duration, Instant};

const CAPACITY: u64 = 1_000_000;
const KEY_SPACE: u64 = 10_000_000;
const THREADS: usize = 4;
const TOTAL_OPS: usize = 50_000_000;

// Definitions for the 3 stages
const STAGE_INITIAL: usize = 1_000_000;
const STAGE_GROWTH: usize = 9_000_000;

const SAMPLE_SIZES: &[usize] = &[1_000, 10_000, 50_000];

fn start_timeout_watchdog(timeout: Duration) {
    std::thread::spawn(move || {
        std::thread::sleep(timeout);
        eprintln!("Benchmark timed out after {:?}", timeout);
        std::process::exit(101);
    });
}

fn bench_workload(cache: Arc<DualCacheFF<u64, u64>>, keys: &[u64]) -> (f64, f64) {
    let ops_per_thread = keys.len() / THREADS;
    let start_time = Instant::now();

    std::thread::scope(|s| {
        let mut handles = Vec::new();
        for t_id in 0..THREADS {
            let cache = Arc::clone(&cache);
            let start_idx = t_id * ops_per_thread;
            let end_idx = if t_id == THREADS - 1 {
                keys.len()
            } else {
                start_idx + ops_per_thread
            };
            let thread_keys = &keys[start_idx..end_idx];

            handles.push(s.spawn(move || {
                let mut misses = 0;
                for &key in thread_keys {
                    if let Some(v) = cache.get(&key) {
                        std::hint::black_box(v);
                    } else {
                        cache.insert(key, key);
                        misses += 1;
                    }
                }
                misses as u64
            }));
        }
        let results: Vec<u64> = handles.into_iter().map(|h| h.join().unwrap()).collect();
        let total_misses: u64 = results.iter().sum();
        let elapsed = start_time.elapsed();
        let throughput = keys.len() as f64 / elapsed.as_secs_f64();
        let hit_rate = 100.0 * (1.0 - (total_misses as f64 / keys.len() as f64));
        (throughput, hit_rate)
    })
}

fn run_phase(cache: Arc<DualCacheFF<u64, u64>>, keys: &[u64], phase_name: &str) -> (f64, f64) {
    let (tp, hr) = bench_workload(cache, keys);
    println!(
        "  [{:<10}] Hit Rate: {:>6.2}% | Throughput: {:>12.2} ops/s",
        phase_name, hr, tp
    );
    (tp, hr)
}

fn main() {
    start_timeout_watchdog(Duration::from_secs(60)); // 1 minute watchdog

    println!("Generating zipf keys (Total {} ops)...", TOTAL_OPS);
    let zipf = Zipf::new(KEY_SPACE, 1.1).unwrap();
    let mut rng = rand::thread_rng();
    let keys: Vec<u64> = (0..TOTAL_OPS)
        .map(|_| zipf.sample(&mut rng) as u64)
        .collect();

    let config = Config::with_memory_budget((CAPACITY * 128 / 1024 / 1024) as usize, 60);
    println!("Aligned benchmark physical capacity: {}\n", config.capacity);

    // To cleanly observe Initial / Growth / Plateau, we DO NOT perform the capacity warmup.
    // The cache will start completely empty for both baseline and fast pass.

    for &sample_size in SAMPLE_SIZES {
        println!("===================================================================");
        println!(
            "== Sampling Specification: {} operations sampled ==",
            sample_size
        );
        println!("===================================================================");

        // Extract hot spots
        let mut sampled_keys = HashSet::new();
        for i in 0..sample_size {
            sampled_keys.insert(keys[i]);
        }
        let hot_spots: Vec<u64> = sampled_keys.into_iter().collect();
        println!(
            "Found {} unique hot keys from the first {} ops.",
            hot_spots.len(),
            sample_size
        );

        let phase_initial = &keys[0..STAGE_INITIAL];
        let phase_growth = &keys[STAGE_INITIAL..(STAGE_INITIAL + STAGE_GROWTH)];
        let phase_plateau = &keys[(STAGE_INITIAL + STAGE_GROWTH)..TOTAL_OPS];

        // ----------------------------------------------------
        // Scenario A: Normal Insert Baseline
        // ----------------------------------------------------
        println!("\n[Scenario A] Normal Insert Baseline (Cold Start, No Warmup)");
        let cache_normal = Arc::new(DualCacheFF::new(config));

        let (_, hr_init_n) = run_phase(cache_normal.clone(), phase_initial, "Initial");
        let (_, hr_grow_n) = run_phase(cache_normal.clone(), phase_growth, "Growth");
        let (_, hr_plat_n) = run_phase(cache_normal.clone(), phase_plateau, "Plateau");

        std::thread::sleep(Duration::from_millis(100)); // give daemon time to clear queue
        // cache_normal.sync(); // ensure cleanup
        drop(cache_normal);

        // ----------------------------------------------------
        // Scenario B: Fast Pass
        // ----------------------------------------------------
        println!(
            "\n[Scenario B] Snapshot Fast Pass (Injecting {} Hot Keys)",
            hot_spots.len()
        );
        let cache_fast = Arc::new(DualCacheFF::new(config));

        let start_warmup = Instant::now();
        let session = cache_fast.begin_cold_start_session();
        for &hot_key in &hot_spots {
            session.insert_t1(hot_key, hot_key);
        }
        cache_fast.sync();
        let warmup_elapsed = start_warmup.elapsed();
        println!("  (Fast Pass Warmup took {:?})", warmup_elapsed);

        let (_, hr_init_f) = run_phase(cache_fast.clone(), phase_initial, "Initial");
        let (_, hr_grow_f) = run_phase(cache_fast.clone(), phase_growth, "Growth");
        let (_, hr_plat_f) = run_phase(cache_fast.clone(), phase_plateau, "Plateau");

        std::thread::sleep(Duration::from_millis(100)); // give daemon time to clear queue
        // cache_fast.sync();
        drop(cache_fast);

        // ----------------------------------------------------
        // Comparison
        // ----------------------------------------------------
        println!("\n=== Hit Rate Improvement ===");
        println!("  Initial Stage: {:>+6.2}%", hr_init_f - hr_init_n);
        println!("  Growth Stage : {:>+6.2}%", hr_grow_f - hr_grow_n);
        println!("  Plateau Stage: {:>+6.2}%", hr_plat_f - hr_plat_n);
        println!();
    }
}
