use rand_distr::{Distribution, Zipf};
use std::collections::HashSet;
use std::sync::Arc;
use std::time::Instant;

const CAPACITY: usize = 1_000_000; // Capacity 1M
const KEY_SPACE: u64 = 10_000_000;
const OPS_PER_BENCH: usize = 10_000_000; // 10M operations

fn main() {
    let mut rng = rand::thread_rng();
    let zipf = Zipf::new(KEY_SPACE, 0.99).unwrap();

    println!("Generating Workload (Zipfian)...");
    let mut keys = Vec::with_capacity(OPS_PER_BENCH);
    for _ in 0..OPS_PER_BENCH {
        keys.push(zipf.sample(&mut rng) as u64);
    }

    println!("Extracting Oracle Hot Set...");
    let oracle_window = 1000;
    let mut seen = HashSet::new();
    let mut hot_set = HashSet::new();
    for &k in &keys[..oracle_window] {
        if !seen.insert(k) {
            hot_set.insert(k);
        }
    }
    println!("Oracle extracted {} hot keys from first {} ops", hot_set.len(), oracle_window);

    let config = dualcache_ff::Config::with_memory_budget((CAPACITY * 128 / 1024 / 1024) as usize, 60);

    // Group A (Control)
    println!("\n=== Group A: Pure Cold Start (Control) ===");
    let ff_stat_a = Arc::new(dualcache_ff::DualCacheFF::new(config.clone()));
    let start_a = Instant::now();
    let mut misses_a = 0;
    for &key in &keys {
        if ff_stat_a.get(&key).is_none() {
            ff_stat_a.insert(key, key);
            misses_a += 1;
        }
    }
    ff_stat_a.sync();
    let elapsed_a = start_a.elapsed();
    let throughput_a = OPS_PER_BENCH as f64 / elapsed_a.as_secs_f64();
    let hitrate_a = 100.0 * (1.0 - (misses_a as f64 / OPS_PER_BENCH as f64));
    println!("Group A - Throughput: {:.2} ops/s", throughput_a);
    println!("Group A - Hit Rate: {:.2}%", hitrate_a);

    // Group B (Experimental / T1 Pass)
    println!("\n=== Group B: Experimental (insert_t1) ===");
    let ff_stat_b = Arc::new(dualcache_ff::DualCacheFF::new(config.clone()));
    let start_b = Instant::now();
    let mut misses_b = 0;
    for &key in &keys {
        if ff_stat_b.get(&key).is_none() {
            if hot_set.contains(&key) {
                ff_stat_b.insert_t1(key, key);
            } else {
                ff_stat_b.insert(key, key);
            }
            misses_b += 1;
        }
    }
    ff_stat_b.sync();
    let elapsed_b = start_b.elapsed();
    let throughput_b = OPS_PER_BENCH as f64 / elapsed_b.as_secs_f64();
    let hitrate_b = 100.0 * (1.0 - (misses_b as f64 / OPS_PER_BENCH as f64));
    println!("Group B - Throughput: {:.2} ops/s", throughput_b);
    println!("Group B - Hit Rate: {:.2}%", hitrate_b);
}
