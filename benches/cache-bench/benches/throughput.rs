use cache_bench::Cache;
use criterion::{BenchmarkId, Criterion, Throughput, criterion_group, criterion_main};
use moka::sync::Cache as MokaCache;
use rand::distributions::Distribution;
use rand_distr::Zipf;
use std::sync::Arc;
use std::time::Duration;
use tinyufo::TinyUfo;

const CAPACITY: u64 = 100_000;
const KEY_SPACE: u64 = 1_000_000; // 键总数远大于容量，模拟真实场景
const THREADS: usize = 16;
const OPS_PER_BENCH: u64 = 10_000_000;

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
    let mut key = thread_id * ops;
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

// ----- Criterion 入口 -----
fn bench_throughput(c: &mut Criterion) {
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

    let mut group = c.benchmark_group("cache_throughput");
    group.throughput(Throughput::Elements(OPS_PER_BENCH));
    group.sample_size(10); // 每个配置采样10次
    group.warm_up_time(Duration::from_secs(2));
    group.measurement_time(Duration::from_secs(5));

    for workload in workloads {
        let keys_to_use: &[u64] = match workload {
            "uniform" => &uniform_keys,
            "zipf" => &zipf_keys,
            "mixed" => &mixed_keys,
            _ => &[], // scan
        };

        // --- Moka measurement run for stats ---
        println!("\n=== Moka Workload: {} ===", workload);
        let moka_stat = Arc::new(MokaCache::builder().max_capacity(CAPACITY).build());
        for i in 0..10_000u64 {
            moka_stat.insert(i, i);
        }
        let m_start = std::time::Instant::now();
        let m_misses = bench_workload(Arc::clone(&moka_stat), workload, keys_to_use);
        let m_elapsed = m_start.elapsed();
        let m_throughput = OPS_PER_BENCH as f64 / m_elapsed.as_secs_f64();
        let m_hitrate = 100.0 * (1.0 - (m_misses as f64 / OPS_PER_BENCH as f64));
        println!("  - Throughput (引擎空轉吞吐): {:.2} ops/s", m_throughput);
        println!("  - DB Penetrates (潛在穿透次數): {}", m_misses);
        println!("  - Hit Rate (真實業務命中率): {:.2}%\n", m_hitrate);

        // 獨立建立 Moka Cache，確保不與其他 workload 共享狀態，同時事先熱機
        let moka_cache = Arc::new(MokaCache::builder().max_capacity(CAPACITY).build());
        for i in 0..10_000u64 {
            moka_cache.insert(i, i);
        }

        // 测试 Moka
        group.bench_with_input(BenchmarkId::new("Moka", workload), &workload, |b, &wl| {
            b.iter_custom(|iters| {
                let mut total = Duration::new(0, 0);
                for _ in 0..iters {
                    // 計時範圍：僅限 benchmark 執行，跨 iters 重用熱機實例
                    let start = std::time::Instant::now();
                    let _ = bench_workload(Arc::clone(&moka_cache), wl, keys_to_use);
                    total += start.elapsed();
                }
                total
            });
        });

        // --- DualCacheFF measurement run for stats ---
        println!("\n=== DualCacheFF Workload: {} ===", workload);
        let ff_stat = Arc::new(dualcache_ff::DualCacheFF::new(dualcache_ff::Config {
            capacity: CAPACITY as usize,
            duration: 60,
        }));
        for i in 0..10_000u64 {
            ff_stat.insert(i, i);
        }
        std::thread::sleep(Duration::from_millis(50));
        let f_start = std::time::Instant::now();
        let f_misses = bench_workload(Arc::clone(&ff_stat), workload, keys_to_use);
        let f_elapsed = f_start.elapsed();
        let f_throughput = OPS_PER_BENCH as f64 / f_elapsed.as_secs_f64();
        let f_hitrate = 100.0 * (1.0 - (f_misses as f64 / OPS_PER_BENCH as f64));
        println!("  - Throughput (引擎空轉吞吐): {:.2} ops/s", f_throughput);
        println!("  - DB Penetrates (潛在穿透次數): {}", f_misses);
        println!("  - Hit Rate (真實業務命中率): {:.2}%\n", f_hitrate);

        // 獨立建立 DualCacheFF 實例
        let my_cache = Arc::new(dualcache_ff::DualCacheFF::new(dualcache_ff::Config {
            capacity: CAPACITY as usize,
            duration: 60,
        }));

        // 提供充分熱機，並給予足夠時間讓 Daemon 進入 recv_timeout 的等候狀態
        for i in 0..10_000u64 {
            my_cache.insert(i, i);
        }
        std::thread::sleep(Duration::from_millis(50));

        // 測試 DualCacheFF
        group.bench_with_input(
            BenchmarkId::new("DualCacheFF", workload),
            &workload,
            |b, &wl| {
                b.iter_custom(|iters| {
                    let mut total = Duration::new(0, 0);
                    for _ in 0..iters {
                        let start = std::time::Instant::now();
                        let _ = bench_workload(Arc::clone(&my_cache), wl, keys_to_use);
                        total += start.elapsed();
                    }
                    total
                });
            },
        );

        // --- TinyUFO measurement run for stats ---
        println!("\n=== TinyUFO Workload: {} ===", workload);
        let ufo_stat = Arc::new(TinyUfo::new(CAPACITY as usize, CAPACITY as usize));
        for i in 0..10_000u64 {
            ufo_stat.insert(i, i);
        }
        let u_start = std::time::Instant::now();
        let u_misses = bench_workload(Arc::clone(&ufo_stat), workload, keys_to_use);
        let u_elapsed = u_start.elapsed();
        let u_throughput = OPS_PER_BENCH as f64 / u_elapsed.as_secs_f64();
        let u_hitrate = 100.0 * (1.0 - (u_misses as f64 / OPS_PER_BENCH as f64));
        println!("  - Throughput (引擎空轉吞吐): {:.2} ops/s", u_throughput);
        println!("  - DB Penetrates (潛在穿透次數): {}", u_misses);
        println!("  - Hit Rate (真實業務命中率): {:.2}%\n", u_hitrate);

        // 獨立建立 TinyUFO 實例
        let ufo_cache = Arc::new(TinyUfo::new(CAPACITY as usize, CAPACITY as usize));

        for i in 0..10_000u64 {
            ufo_cache.insert(i, i);
        }

        // 測試 TinyUFO
        group.bench_with_input(
            BenchmarkId::new("TinyUFO", workload),
            &workload,
            |b, &wl| {
                b.iter_custom(|iters| {
                    let mut total = Duration::new(0, 0);
                    for _ in 0..iters {
                        let start = std::time::Instant::now();
                        let _ = bench_workload(Arc::clone(&ufo_cache), wl, keys_to_use);
                        total += start.elapsed();
                    }
                    total
                });
            },
        );
    }
    group.finish();
}

criterion_group!(benches, bench_throughput);
criterion_main!(benches);
