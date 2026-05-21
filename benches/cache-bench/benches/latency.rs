use cache_bench::Cache;
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
            let mut latencies = Vec::with_capacity(thread_keys.len());
            let mut rng = rand::thread_rng();
            let mut thread_gets = 0u64;
            let mut thread_hits = 0u64;

            for key in thread_keys {
                // 80% Get, 20% Put
                let is_get = rng.gen_bool(0.8);
                
                if is_get {
                    thread_gets += 1;
                    compiler_fence(Ordering::SeqCst);
                    let start = Instant::now();
                    let v = cache.get(&key);
                    latencies.push(start.elapsed().as_nanos() as u64);
                    compiler_fence(Ordering::SeqCst);
                    
                    std::hint::black_box(v.as_ref());
                    if v.is_some() {
                        thread_hits += 1;
                    } else {
                        cache.insert(key, key);
                    }
                } else {
                    compiler_fence(Ordering::SeqCst);
                    let start = Instant::now();
                    cache.insert(key, key);
                    latencies.push(start.elapsed().as_nanos() as u64);
                    compiler_fence(Ordering::SeqCst);
                }
            }
            (latencies, thread_gets, thread_hits)
        }));
    }

    let mut all_latencies = Vec::with_capacity((THREADS as u64 * OPS_PER_THREAD) as usize);
    let mut total_gets = 0;
    let mut total_hits = 0;

    for h in handles {
        let (latencies, gets, hits) = h.join().unwrap();
        all_latencies.extend(latencies);
        total_gets += gets;
        total_hits += hits;
    }

    all_latencies.sort_unstable();

    if all_latencies.is_empty() {
        println!("No operations recorded.");
        return;
    }

    let count = all_latencies.len() as f64;
    let p50 = all_latencies[(count * 0.50) as usize];
    let p90 = all_latencies[(count * 0.90) as usize];
    let p99 = all_latencies[(count * 0.99) as usize];
    let p99_9 = all_latencies[(count * 0.999) as usize];
    let p99_99 = all_latencies[(count * 0.9999) as usize];
    let max = *all_latencies.last().unwrap();

    let hit_rate = if total_gets > 0 {
        (total_hits as f64 / total_gets as f64) * 100.0
    } else {
        0.0
    };

    println!("  Real Hit Rate: {:.2}%", hit_rate);
    println!("  P50:      {:>8} ns", p50);
    println!("  P90:      {:>8} ns", p90);
    println!("  P99:      {:>8} ns", p99);
    println!("  P99.9:    {:>8} ns", p99_9);
    println!("  P99.99:   {:>8} ns", p99_99);
    println!("  Max:      {:>8} ns", max);
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
