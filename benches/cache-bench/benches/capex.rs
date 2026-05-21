use cache_bench::Cache;
use dualcache_ff::{Config, DualCacheFF};
use memory_stats::memory_stats;
use moka::sync::Cache as MokaCache;
use rand::Rng;
use rand_distr::{Distribution, Zipf};
use std::sync::Arc;
use std::time::Instant;
use tinyufo::TinyUfo;

const CAPEX_CAPACITY: usize = 2000;
const KEY_SPACE: u64 = 50_000;
const TOTAL_OPS: usize = 200_000;

fn print_memory(label: &str) -> usize {
    if let Some(usage) = memory_stats() {
        let kb = usage.physical_mem as f64 / 1024.0;
        println!("{:>25} RSS: {:.2} KB", label, kb);
        usage.physical_mem
    } else {
        0
    }
}

fn measure_capex<C, F>(name: &str, keys: &[u64], init_cache: F)
where
    C: Cache<u64, u64> + 'static,
    F: FnOnce() -> Arc<C>,
{
    println!("\n=== {} (CAPEX Constrained) ===", name);
    let base_mem = print_memory("Baseline Mem");
    
    let peak_mem = {
        let cache = init_cache();
        let capacity = 2048; // aligned capacity

        for i in 0..(capacity as u64) {
            cache.insert(i, i);
        }
        cache.sync();

        let mut misses = 0;
        let mut get_ops = 0;
        let mut rng = rand::thread_rng();

        let start_time = Instant::now();
        for (_count, &key) in keys.iter().enumerate() {
            if rng.gen_bool(0.8) {
                get_ops += 1;
                if cache.get(&key).is_none() {
                    cache.insert(key, key);
                    misses += 1;
                }
            } else {
                cache.insert(key, key);
            }
        }
        cache.sync();
        let elapsed = start_time.elapsed();
        let peak = print_memory("Peak Mem");

        let hit_rate = if get_ops > 0 {
            100.0 * (1.0 - (misses as f64 / get_ops as f64))
        } else {
            0.0
        };

        println!("  - Execution Time:  {:.2?}", elapsed);
        println!("  - Real Hit Rate:   {:.2}%", hit_rate);
        peak
    };
    
    let footprint_kb = peak_mem.saturating_sub(base_mem) as f64 / 1024.0;
    println!("  - Net Footprint:   {:.2} KB", footprint_kb);
    println!(
        "  - Avg Cost/Item:   {:.2} Bytes (Footprint / Capacity)",
        (footprint_kb * 1024.0) / 2048.0
    );
}

fn start_timeout_watchdog(timeout: std::time::Duration) {
    std::thread::spawn(move || {
        std::thread::sleep(timeout);
        eprintln!("Benchmark timed out after {:?}", timeout);
        std::process::exit(101);
    });
}

fn main() {
    start_timeout_watchdog(std::time::Duration::from_secs(60));
    let args: Vec<String> = std::env::args().collect();
    let is_full_bench = args.iter().any(|a| a == "--full_bench") || cfg!(feature = "full_bench");
    
    println!("Generating realistic zipf distribution...");
    let zipf = Zipf::new(KEY_SPACE, 1.2).unwrap();
    let mut rng = rand::thread_rng();
    let keys: Vec<u64> = (0..TOTAL_OPS)
        .map(|_| zipf.sample(&mut rng) as u64)
        .collect();

    if args.iter().any(|arg| arg == "--dual") {
        measure_capex("DualCacheFF", &keys, || {
            let config = Config::new_expert(2048, 2048, 2048, 60, 1);
            Arc::new(DualCacheFF::new(config))
        });
        return;
    } else if args.iter().any(|arg| arg == "--moka") {
        measure_capex("Moka", &keys, || {
            Arc::new(
                MokaCache::builder()
                    .max_capacity(2048)
                    .build(),
            )
        });
        return;
    } else if args.iter().any(|arg| arg == "--tiny") {
        measure_capex("TinyUFO", &keys, || {
            Arc::new(TinyUfo::new(2048, 2048))
        });
        return;
    }
    
    if args.len() > 1 && !args.contains(&"--bench".to_string()) && !args.contains(&"--full_bench".to_string()) {
         return;
    }

    println!("--- CAPEX Constraint Benchmark (Isolated Processes) ---");
    println!(
        "Capacity: 2048 Items | Total Ops: {} (Single Thread)",
        TOTAL_OPS
    );

    let exe = std::env::current_exe().unwrap();
    std::process::Command::new(&exe).arg("--dual").status().unwrap();
    if is_full_bench {
        std::process::Command::new(&exe).arg("--moka").status().unwrap();
        std::process::Command::new(&exe).arg("--tiny").status().unwrap();
    }
}
