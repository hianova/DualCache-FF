use cache_bench::Cache;
use criterion::{BenchmarkId, Criterion, Throughput, criterion_group, criterion_main};
use moka::sync::Cache as MokaCache;
use rand::distributions::Distribution;
use rand_distr::Zipf;
use std::sync::Arc;
use std::time::Duration;

const CAPACITY: u64 = 100_000;
const KEY_SPACE: u64 = 1_000_000; // 键总数远大于容量，模拟真实场景
const THREADS: usize = 4;
const OPS_PER_BENCH: u64 = 1_000_000;

// ----- 统一测试函数 -----
fn bench_workload<C>(cache: Arc<C>, workload: &str, keys: &[u64])
where
    C: Cache<u64, u64> + Send + Sync + 'static,
{
    let ops_per_thread = (OPS_PER_BENCH / (THREADS as u64)) as usize;
    std::thread::scope(|s| {
        for t_id in 0..THREADS {
            let cache = Arc::clone(&cache);
            let start_idx = t_id * ops_per_thread;
            let end_idx = start_idx + ops_per_thread;

            let thread_keys = if keys.is_empty() {
                &[] as &[u64]
            } else {
                &keys[start_idx..std::cmp::min(end_idx, keys.len())]
            };

            s.spawn(move || match workload {
                "uniform" | "zipf" => run_keys(cache, thread_keys),
                "scan" => run_scan(cache, ops_per_thread as u64, t_id as u64),
                _ => panic!("unknown workload"),
            });
        }
    });
}

// 预先生成好 key 的测试
fn run_keys<C>(cache: Arc<C>, keys: &[u64])
where
    C: Cache<u64, u64> + 'static,
{
    for &key in keys {
        if let Some(v) = cache.get(&key) {
            // 命中时什么也不做，只是防止编译器优化掉
            std::hint::black_box(v);
        } else {
            cache.insert(key, key);
        }
    }
}

// 顺序扫描
fn run_scan<C>(cache: Arc<C>, ops: u64, thread_id: u64)
where
    C: Cache<u64, u64> + 'static,
{
    let mut key = thread_id * ops;
    for _ in 0..ops {
        if let Some(v) = cache.get(&key) {
            std::hint::black_box(v);
        } else {
            cache.insert(key, key);
        }
        key = (key + 1) % KEY_SPACE;
    }
}

// ----- Criterion 入口 -----
fn bench_throughput(c: &mut Criterion) {
    // 创建工作负载列表
    let workloads = vec!["uniform", "zipf", "scan"];

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

    let mut group = c.benchmark_group("cache_throughput");
    group.throughput(Throughput::Elements(OPS_PER_BENCH));
    group.sample_size(10); // 每个配置采样10次
    group.warm_up_time(Duration::from_secs(2));
    group.measurement_time(Duration::from_secs(5));

    for workload in workloads {
        let keys_to_use: &[u64] = match workload {
            "uniform" => &uniform_keys,
            "zipf" => &zipf_keys,
            _ => &[], // scan
        };

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
                    bench_workload(Arc::clone(&moka_cache), wl, keys_to_use);
                    total += start.elapsed();
                }
                total
            });
        });

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
                        bench_workload(Arc::clone(&my_cache), wl, keys_to_use);
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
