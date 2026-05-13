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

fn measure_dualcacheff() {
    println!("\n--- DualCacheFF ---");
    let baseline = print_memory("Baseline (empty)");
    use dualcache_ff::{Config, DualCacheFF};

    let peak = {
        let config = Config::with_memory_budget((CAPACITY * 128 / 1024 / 1024) as usize, 60);
        let cache = DualCacheFF::new(config);
        let _init = print_memory("After Init");

        for i in 0..CAPACITY as u64 {
            cache.insert(i, i);
        }
        std::thread::sleep(Duration::from_millis(500));
        print_memory("After 1M Inserts")
    };

    let total_used = peak.saturating_sub(baseline);
    let payload = CAPACITY * 16; // 8 byte key + 8 byte value
    let overhead = total_used.saturating_sub(payload);
    let per_item = overhead as f64 / CAPACITY as f64;

    println!("DualcacheFF overhead per item: {:.2} bytes", per_item);
}

fn measure_moka() {
    println!("\n--- Moka ---");
    let baseline = print_memory("Baseline (empty)");
    use moka::sync::Cache;

    let peak = {
        let cache: Cache<u64, u64> = Cache::builder().max_capacity(CAPACITY as u64).build();
        let _init = print_memory("After Init");

        for i in 0..CAPACITY as u64 {
            cache.insert(i, i);
        }
        std::thread::sleep(Duration::from_millis(500));
        print_memory("After 1M Inserts")
    };

    let total_used = peak.saturating_sub(baseline);
    let payload = CAPACITY * 16;
    let overhead = total_used.saturating_sub(payload);
    let per_item = overhead as f64 / CAPACITY as f64;

    println!("Moka overhead per item: {:.2} bytes", per_item);
}

fn measure_tinyufo() {
    println!("\n--- TinyUFO ---");
    let baseline = print_memory("Baseline (empty)");
    use tinyufo::TinyUfo;

    let peak = {
        let cache = TinyUfo::new(CAPACITY, CAPACITY);
        let _init = print_memory("After Init");

        for i in 0..CAPACITY as u64 {
            cache.put(i, i, 1);
        }
        std::thread::sleep(Duration::from_millis(500));
        print_memory("After 1M Inserts")
    };

    let total_used = peak.saturating_sub(baseline);
    let payload = CAPACITY * 16;
    let overhead = total_used.saturating_sub(payload);
    let per_item = overhead as f64 / CAPACITY as f64;

    println!("TinyUFO overhead per item: {:.2} bytes", per_item);
}

fn main() {
    let args: Vec<String> = std::env::args().collect();
    let is_full_bench = args.iter().any(|a| a == "--full_bench") || cfg!(feature = "full_bench");

    if args.iter().any(|arg| arg == "--dual") {
        measure_dualcacheff();
        return;
    } else if args.iter().any(|arg| arg == "--moka") {
        measure_moka();
        return;
    } else if args.iter().any(|arg| arg == "--tiny") {
        measure_tinyufo();
        return;
    }

    if args.iter().any(|arg| arg == "--bench") && args.len() == 2 {
        // Run as coordinator if invoked by cargo bench
    } else if args.len() > 1 && !args.contains(&"--bench".to_string()) && !args.contains(&"--full_bench".to_string()) {
         return; // Unknown or irrelevant flags passed by cargo, ignore unless it's our target.
    }

    println!("Running Memory Benchmarks (Isolated Processes)...");
    let exe = std::env::current_exe().unwrap();
    
    std::process::Command::new(&exe).arg("--dual").status().unwrap();
    if is_full_bench {
        std::process::Command::new(&exe).arg("--moka").status().unwrap();
        std::process::Command::new(&exe).arg("--tiny").status().unwrap();
    }
    
    println!("\n========== Summary ==========");
    println!("Refer to output logs above for per-item overheads.");
}
