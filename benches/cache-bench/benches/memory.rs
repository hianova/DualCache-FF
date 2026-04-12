use memory_stats::memory_stats;
use std::time::Duration;

const CAPACITY: usize = 1_000_000;

fn print_memory(label: &str) -> usize {
    if let Some(usage) = memory_stats() {
        let mb = usage.physical_mem as f64 / 1024.0 / 1024.0;
        println!("{:>20} RSS: {:.2} MB", label, mb);
        usage.physical_mem
    } else {
        eprintln!("Failed to read memory stats");
        0
    }
}

fn measure_dualcacheff(baseline: usize) -> f64 {
    println!("\n--- DualCacheFF ---");
    use dualcache_ff::{Config, DualCacheFF};

    let cache = DualCacheFF::new(Config {
        capacity: CAPACITY,
        duration: 60,
    });
    let _init = print_memory("After Init");

    for i in 0..CAPACITY as u64 {
        cache.insert(i, i);
    }
    std::thread::sleep(Duration::from_millis(500));
    let peak = print_memory("After 1M Inserts");

    let total_used = peak.saturating_sub(baseline);
    let payload = CAPACITY * 16; // 8 byte key + 8 byte value
    let overhead = total_used.saturating_sub(payload);
    let per_item = overhead as f64 / CAPACITY as f64;

    println!("Overhead per item: {:.2} bytes", per_item);
    per_item
}

fn measure_moka(baseline: usize) -> f64 {
    println!("\n--- Moka ---");
    use moka::sync::Cache;

    let cache: Cache<u64, u64> = Cache::builder().max_capacity(CAPACITY as u64).build();
    let _init = print_memory("After Init");

    for i in 0..CAPACITY as u64 {
        cache.insert(i, i);
    }
    std::thread::sleep(Duration::from_millis(500));
    let peak = print_memory("After 1M Inserts");

    let total_used = peak.saturating_sub(baseline);
    let payload = CAPACITY * 16;
    let overhead = total_used.saturating_sub(payload);
    let per_item = overhead as f64 / CAPACITY as f64;

    println!("Overhead per item: {:.2} bytes", per_item);
    per_item
}

fn measure_tinyufo(baseline: usize) -> f64 {
    println!("\n--- TinyUFO ---");
    use tinyufo::TinyUfo;

    let cache = TinyUfo::new(CAPACITY, CAPACITY);
    let _init = print_memory("After Init");

    for i in 0..CAPACITY as u64 {
        cache.put(i, i, 1);
    }
    std::thread::sleep(Duration::from_millis(500));
    let peak = print_memory("After 1M Inserts");

    let total_used = peak.saturating_sub(baseline);
    let payload = CAPACITY * 16;
    let overhead = total_used.saturating_sub(payload);
    let per_item = overhead as f64 / CAPACITY as f64;

    println!("Overhead per item: {:.2} bytes", per_item);
    per_item
}

fn main() {
    let baseline = print_memory("Baseline (empty)");

    let dual = measure_dualcacheff(baseline);
    let moka = measure_moka(baseline);
    let tiny = measure_tinyufo(baseline);

    println!("\n========== Summary ==========");
    println!("DualCacheFF overhead: {:.2} bytes/item", dual);
    println!("Moka overhead:        {:.2} bytes/item", moka);
    println!("TinyUFO overhead:     {:.2} bytes/item", tiny);
}
