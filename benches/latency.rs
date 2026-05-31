mod common;
use common::Cache;
use rand::distributions::Distribution;
use rand::Rng;
use rand_distr::Zipf;
use std::sync::Arc;
use std::sync::atomic::{compiler_fence, Ordering};
use std::time::{Duration, Instant};

const CAPACITY: u64 = 100_000;
const KEY_SPACE: u64 = 1_000_000;
const THREADS: usize = 4;
const OPS_PER_THREAD: u64 = 250_000; // 每個執行緒 25 萬次，總計 200 萬次操作

fn measure_latency<C>(cache: Arc<C>, name: &str, keys: &[u64], capacity: u64)
where
    C: Cache<u64, u64> + 'static,
{
    println!("\n=== {} ===", name);
    
    // 預熱階段
    for i in 0..capacity {
        cache.insert(i, i);
    }
    cache.sync();
    std::thread::sleep(Duration::from_millis(200));

    let mut handles = Vec::new();

    for t_id in 0..THREADS {
        let cache = Arc::clone(&cache);
        let start_idx = t_id * (OPS_PER_THREAD as usize);
        let end_idx = start_idx + (OPS_PER_THREAD as usize);
        
        let thread_keys = if start_idx < keys.len() {
            keys[start_idx..std::cmp::min(end_idx, keys.len())].to_vec()
        } else {
            vec![]
        };

        handles.push(std::thread::spawn(move || {
            let mut read_latencies = Vec::with_capacity(thread_keys.len());
            let mut write_latencies = Vec::with_capacity(thread_keys.len() / 5);
            let mut rng = rand::thread_rng();
            let mut thread_gets = 0u64;
            let mut thread_hits = 0u64;

            for key in thread_keys {
                // 80% Get, 20% Put
                let is_get = rng.gen_bool(0.8);
                
                if is_get {
                    thread_gets += 1;
                    let start = Instant::now();
                    compiler_fence(Ordering::SeqCst);
                    let v = cache.get(&key);
                    compiler_fence(Ordering::SeqCst);
                    let elapsed = start.elapsed();
                    read_latencies.push(elapsed.as_nanos() as u64);
                    
                    std::hint::black_box(v.as_ref());
                    if v.is_some() {
                        thread_hits += 1;
                    } else {
                        cache.insert(key, key);
                    }
                } else {
                    let start = Instant::now();
                    compiler_fence(Ordering::SeqCst);
                    cache.insert(key, key);
                    compiler_fence(Ordering::SeqCst);
                    let elapsed = start.elapsed();
                    write_latencies.push(elapsed.as_nanos() as u64);
                }
            }
            (read_latencies, write_latencies, thread_gets, thread_hits)
        }));
    }

    let mut all_read_latencies = Vec::with_capacity((THREADS as u64 * OPS_PER_THREAD) as usize);
    let mut all_write_latencies = Vec::with_capacity((THREADS as u64 * OPS_PER_THREAD / 5) as usize);
    let mut total_gets = 0;
    let mut total_hits = 0;

    for h in handles {
        let (read_lats, write_lats, gets, hits) = h.join().unwrap();
        all_read_latencies.extend(read_lats);
        all_write_latencies.extend(write_lats);
        total_gets += gets;
        total_hits += hits;
    }

    all_read_latencies.sort_unstable();
    all_write_latencies.sort_unstable();

    let hit_rate = if total_gets > 0 {
        (total_hits as f64 / total_gets as f64) * 100.0
    } else {
        0.0
    };
    println!("  Real Hit Rate: {:.2}%", hit_rate);

    fn print_stats(label: &str, latencies: &[u64]) {
        if latencies.is_empty() {
            println!("  [{}]: No operations recorded.", label);
            return;
        }
        let count = latencies.len() as f64;
        let p50 = latencies[(count * 0.50) as usize];
        let p90 = latencies[(count * 0.90) as usize];
        let p99 = latencies[(count * 0.99) as usize];
        let p99_9 = latencies[(count * 0.999) as usize];
        let p99_99 = latencies[(count * 0.9999) as usize];
        let max = *latencies.last().unwrap();
        println!("  [{}] P50: {:>8} ns | P90: {:>8} ns | P99: {:>8} ns | P99.9: {:>8} ns | P99.99: {:>8} ns | Max: {:>8} ns", 
                 label, p50, p90, p99, p99_9, p99_99, max);
    }

    print_stats("READ ", &all_read_latencies);
    print_stats("WRITE", &all_write_latencies);
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

    println!("Generating zipf keys (Total 2,000,000 ops)...");
    let zipf = Zipf::new(KEY_SPACE, 1.0).unwrap();
    let mut rng = rand::thread_rng();
    let total_ops = (THREADS as u64) * OPS_PER_THREAD;
    let keys: Vec<u64> = (0..total_ops)
        .map(|_| zipf.sample(&mut rng) as u64)
        .collect();
    
    let config = dualcache_ff::Config::with_memory_budget((CAPACITY * 128 / 1024 / 1024) as usize, 60);
    let actual_capacity = config.capacity;
    println!("Aligned benchmark physical capacity: {}", actual_capacity);

    // 測量 DualCacheFF
    let ff_stat = Arc::new(dualcache_ff::DualCacheFF::new(config));
    // Warmup
    for &key in &keys[..1000] {
        ff_stat.insert(key, key);
    }
    ff_stat.sync();
    measure_latency(ff_stat, "DualCacheFF", &keys, actual_capacity as u64);

    // 測量 Moka
    if is_full_bench {
        let moka_stat = Arc::new(moka::sync::Cache::builder().max_capacity(actual_capacity as u64).build());
        measure_latency(moka_stat, "Moka", &keys, actual_capacity as u64);
    }

    // 測量 TinyUFO
    if is_full_bench {
        let ufo_stat = Arc::new(tinyufo::TinyUfo::new(actual_capacity, actual_capacity));
        measure_latency(ufo_stat, "TinyUFO", &keys, actual_capacity as u64);
    }
}
