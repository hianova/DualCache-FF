mod common;
use common::Cache;
use moka::sync::Cache as MokaCache;
use rand::distributions::Distribution;
use rand_distr::Zipf;
use std::sync::Arc;
use std::time::Duration;
use tinyufo::TinyUfo;

const CAPACITY: u64 = 1_000_000;
const KEY_SPACE: u64 = 10_000_000; // 键总数远大于容量，模拟真实场景
const THREADS: usize = 4;
const OPS_PER_BENCH: u64 = 50_000_000;

// ----- 统一测试函数 -----
fn bench_workload<C>(cache: Arc<C>, workload: &str, keys: &[u64]) -> u64
where
    C: Cache<u64, u64> + Send + Sync + 'static,
{
    let ops_per_thread = (OPS_PER_BENCH / (THREADS as u64)) as usize;
    std::thread::scope(|s| {
        let mut handles = Vec::new();
        for t_id in 0..THREADS {
            let cache = Arc::clone(&cache);
            let start_idx = t_id * ops_per_thread;
            let end_idx = start_idx + ops_per_thread;

            let thread_keys = if keys.is_empty() {
                &[] as &[u64]
            } else {
                &keys[start_idx..std::cmp::min(end_idx, keys.len())]
            };

            handles.push(s.spawn(move || match workload {
                "uniform" | "zipf" | "mixed" => run_keys(cache, thread_keys),
                "scan" => run_scan(cache, ops_per_thread as u64, t_id as u64),
                _ => panic!("unknown workload"),
            }));
        }
        handles.into_iter().map(|h| h.join().unwrap()).sum()
    })
}

// 预先生成好 key 的测试
fn run_keys<C>(cache: Arc<C>, keys: &[u64]) -> u64
where
    C: Cache<u64, u64> + 'static,
{
    let mut misses = 0;
    for &key in keys {
        if let Some(v) = cache.get(&key) {
            // 命中时什么也不做，只是防止编译器优化掉
            std::hint::black_box(v);
        } else {
            cache.insert(key, key);
            misses += 1;
        }
    }
    misses
}

// 顺序扫描
fn run_scan<C>(cache: Arc<C>, ops: u64, thread_id: u64) -> u64
where
    C: Cache<u64, u64> + 'static,
{
    let mut misses = 0;
    let mut key = (thread_id * (KEY_SPACE / THREADS as u64)) % KEY_SPACE;
    for _ in 0..ops {
        if let Some(v) = cache.get(&key) {
            std::hint::black_box(v);
        } else {
            cache.insert(key, key);
            misses += 1;
        }
        key = (key + 1) % KEY_SPACE;
    }
    misses
}

// ----- 測試入口 -----
fn run_benchmarks(is_full_bench: bool) {
    // 创建工作负载列表
    let workloads = vec!["uniform", "zipf", "scan", "mixed"];

    let uniform_keys: Vec<u64> = {
        let dist = rand::distributions::Uniform::new(0, KEY_SPACE);
        let mut rng = rand::thread_rng();
        (0..OPS_PER_BENCH).map(|_| dist.sample(&mut rng)).collect()
    };

    let zipf_keys: Vec<u64> = {
        let zipf = Zipf::new(KEY_SPACE, 1.0).unwrap();
        let mut rng = rand::thread_rng();
        (0..OPS_PER_BENCH)
            .map(|_| zipf.sample(&mut rng) as u64)
            .collect()
    };

    let mixed_keys: Vec<u64> = {
        use rand::Rng;
        let mut rng = rand::thread_rng();
        let zipf = Zipf::new(KEY_SPACE, 1.0).unwrap();
        let uniform = rand::distributions::Uniform::new(0, KEY_SPACE);

        let mut keys = Vec::with_capacity(OPS_PER_BENCH as usize);
        let mut i = 0;
        while i < OPS_PER_BENCH {
            let phase_len = rng.gen_range(50_000..=200_000);
            let phase_type = rng.gen_range(0..3); // 0: zipf, 1: uniform, 2: scan

            let mut scan_start = rng.gen_range(0..KEY_SPACE);
            for _ in 0..phase_len {
                if i >= OPS_PER_BENCH {
                    break;
                }
                let k = match phase_type {
                    0 => zipf.sample(&mut rng) as u64,
                    1 => uniform.sample(&mut rng),
                    _ => {
                        let k = scan_start;
                        scan_start = (scan_start + 1) % KEY_SPACE;
                        k
                    }
                };
                keys.push(k);
                i += 1;
            }
        }
        keys
    };

    println!(
        "Running throughput benchmarks with OPS_PER_BENCH = {}",
        OPS_PER_BENCH
    );

    let config =
        dualcache_ff::Config::with_memory_budget((CAPACITY * 128 / 1024 / 1024) as usize, 60);
    let actual_capacity = config.capacity;
    println!("Aligned benchmark physical capacity: {}", actual_capacity);

    for workload in workloads {
        let keys_to_use: &[u64] = match workload {
            "uniform" => &uniform_keys,
            "zipf" => &zipf_keys,
            "mixed" => &mixed_keys,
            _ => &[], // scan
        };

        // --- Moka measurement run for stats ---
        if is_full_bench {
            println!("\n=== Moka Workload: {} ===", workload);
            let moka_stat = Arc::new(MokaCache::builder().max_capacity(actual_capacity as u64).build());
            for i in 0..actual_capacity {
                moka_stat.insert(i as u64, i as u64);
            }
            moka_stat.sync();
            std::thread::sleep(Duration::from_millis(50));
            let m_start = std::time::Instant::now();
            let m_misses = bench_workload(Arc::clone(&moka_stat), workload, keys_to_use);
            let m_elapsed = m_start.elapsed();
            let m_throughput = OPS_PER_BENCH as f64 / m_elapsed.as_secs_f64();
            let m_hitrate = 100.0 * (1.0 - (m_misses as f64 / OPS_PER_BENCH as f64));
            println!("  - Throughput (引擎空轉吞吐): {:.2} ops/s", m_throughput);
            println!("  - DB Penetrates (潛在穿透次數): {}", m_misses);
            println!("  - Hit Rate (真實業務命中率): {:.2}%\n", m_hitrate);
        }

        // --- DualCacheFF measurement run for stats ---
        println!("\n=== DualCacheFF Workload: {} ===", workload);
        let ff_stat = Arc::new(dualcache_ff::DualCacheFF::new(config.clone()));
        for i in 0..actual_capacity {
            ff_stat.insert(i as u64, i as u64);
        }
        ff_stat.sync();
        std::thread::sleep(Duration::from_millis(50));
        let f_start = std::time::Instant::now();
        let f_misses = bench_workload(Arc::clone(&ff_stat), workload, keys_to_use);
        let f_elapsed = f_start.elapsed();
        let f_throughput = OPS_PER_BENCH as f64 / f_elapsed.as_secs_f64();
        let f_hitrate = 100.0 * (1.0 - (f_misses as f64 / OPS_PER_BENCH as f64));
        println!("  - Throughput (引擎空轉吞吐): {:.2} ops/s", f_throughput);
        println!("  - DB Penetrates (潛在穿透次數): {}", f_misses);
        println!("  - Hit Rate (真實業務命中率): {:.2}%\n", f_hitrate);

        // --- StaticDualCache measurement run for stats ---
        println!("\n=== StaticDualCache Workload: {} ===", workload);
        let static_stat = Arc::new(dualcache_ff::StaticDualCache::new(config.clone()));
        for i in 0..actual_capacity {
            static_stat.insert(i as u64, i as u64);
        }
        static_stat.maintenance();
        std::thread::sleep(Duration::from_millis(50));
        let s_start = std::time::Instant::now();
        let s_misses = bench_workload(Arc::clone(&static_stat), workload, keys_to_use);
        let s_elapsed = s_start.elapsed();
        let s_throughput = OPS_PER_BENCH as f64 / s_elapsed.as_secs_f64();
        let s_hitrate = 100.0 * (1.0 - (s_misses as f64 / OPS_PER_BENCH as f64));
        println!("  - Throughput (引擎空轉吞吐): {:.2} ops/s", s_throughput);
        println!("  - DB Penetrates (潛在穿透次數): {}", s_misses);
        println!("  - Hit Rate (真實業務命中率): {:.2}%\n", s_hitrate);

        // --- TinyUFO measurement run for stats ---
        if is_full_bench {
            println!("\n=== TinyUFO Workload: {} ===", workload);
            let ufo_stat = Arc::new(TinyUfo::new(actual_capacity, actual_capacity));
            for i in 0..actual_capacity {
                ufo_stat.insert(i as u64, i as u64);
            }
            ufo_stat.sync();
            std::thread::sleep(Duration::from_millis(50));
            let u_start = std::time::Instant::now();
            let u_misses = bench_workload(Arc::clone(&ufo_stat), workload, keys_to_use);
            let u_elapsed = u_start.elapsed();
            let u_throughput = OPS_PER_BENCH as f64 / u_elapsed.as_secs_f64();
            let u_hitrate = 100.0 * (1.0 - (u_misses as f64 / OPS_PER_BENCH as f64));
            println!("  - Throughput (引擎空轉吞吐): {:.2} ops/s", u_throughput);
            println!("  - DB Penetrates (潛在穿透次數): {}", u_misses);
            println!("  - Hit Rate (真實業務命中率): {:.2}%\n", u_hitrate);
        }
    }
}

fn start_timeout_watchdog(timeout: Duration) {
    std::thread::spawn(move || {
        std::thread::sleep(timeout);
        eprintln!("Benchmark timed out after {:?}", timeout);
        std::process::exit(101);
    });
}

fn main() {
    start_timeout_watchdog(Duration::from_secs(300));
    let args: Vec<String> = std::env::args().collect();
    let is_full_bench = args.iter().any(|a| a == "--full_bench") || cfg!(feature = "full_bench");

    run_benchmarks(is_full_bench);
}
