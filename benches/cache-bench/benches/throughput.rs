use cache_bench::Cache;
use criterion::{BenchmarkId, Criterion, Throughput, criterion_group, criterion_main};
use moka::sync::Cache as MokaCache;
use rand::distributions::Distribution;
use rand::prelude::*;
use rand_distr::Zipf;
use std::sync::Arc;
use std::time::Duration;

const CAPACITY: u64 = 100_000;
const KEY_SPACE: u64 = 1_000_000; // 键总数远大于容量，模拟真实场景
const THREADS: usize = 4;
const OPS_PER_BENCH: u64 = 1_000_000;

// ----- 统一测试函数 -----
fn bench_workload<C>(cache: Arc<C>, workload: &str)
where
    C: Cache<u64, u64> + 'static,
{
    match workload {
        "uniform" => run_uniform(cache),
        "zipf" => run_zipf(cache),
        "scan" => run_scan(cache),
        _ => panic!("unknown workload"),
    }
}
// fn bench_workload_parallel<C>(cache: Arc<C>, workload: &str, thread_count: usize)
// where
//     C: Cache<u64, u64> + 'static,
// {
//     let ops_per_thread = OPS_PER_BENCH / thread_count as u64;
//     std::thread::scope(|s| {
//         for _ in 0..thread_count {
//             let cache = Arc::clone(&cache);
//             s.spawn(move || {
//                 todo!("测量多线程并发吞吐量");
//                 match workload {
//                     "uniform" => run_uniform_ops(cache, ops_per_thread),
//                     // ... 类似实现带 ops 参数的版本
//                     _ => {}
//                 }
//             });
//         }
//     });
// }
// 均匀随机
fn run_uniform<C>(cache: Arc<C>)
where
    C: Cache<u64, u64> + 'static,
{
    let mut rng = rand::thread_rng();
    let dist = rand::distributions::Uniform::new(0, KEY_SPACE);
    for _ in 0..OPS_PER_BENCH {
        let key = dist.sample(&mut rng);
        if let Some(v) = cache.get(&key) {
            // 命中时什么也不做，只是防止编译器优化掉
            std::hint::black_box(v);
        } else {
            cache.insert(key, key);
        }
    }
}

// Zipf 热点访问
fn run_zipf<C>(cache: Arc<C>)
where
    C: Cache<u64, u64> + 'static,
{
    let mut rng = rand::thread_rng();
    let zipf = Zipf::new(KEY_SPACE, 1.0).unwrap(); // 参数：元素个数，指数
    for _ in 0..OPS_PER_BENCH {
        let key = zipf.sample(&mut rng) as u64;
        if let Some(v) = cache.get(&key) {
            std::hint::black_box(v);
        } else {
            cache.insert(key, key);
        }
    }
}

// 顺序扫描
fn run_scan<C>(cache: Arc<C>)
where
    C: Cache<u64, u64> + 'static,
{
    let mut key = 0;
    for _ in 0..OPS_PER_BENCH {
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

    // 初始化两种缓存（使用相同的容量）
    let moka_cache: MokaCache<u64, u64> = MokaCache::builder()
        .max_capacity(CAPACITY)
        .time_to_idle(Duration::from_secs(60))
        .build();
    let moka_cache = Arc::new(moka_cache);

    // TODO: 替换成你的缓存实例
    let my_cache = Arc::new(dualcache_ff::DualCacheFF::new(dualcache_ff::Config {
        capacity: CAPACITY as usize,
        duration: 60,
    }));

    let mut group = c.benchmark_group("cache_throughput");
    group.throughput(Throughput::Elements(OPS_PER_BENCH));
    group.sample_size(10); // 每个配置采样10次
    group.warm_up_time(Duration::from_secs(2));
    group.measurement_time(Duration::from_secs(5));

    for workload in workloads {
        // 测试 Moka
        group.bench_with_input(BenchmarkId::new("Moka", workload), &workload, |b, &wl| {
            b.iter_custom(|iters| {
                let start = std::time::Instant::now();
                for _ in 0..iters {
                    bench_workload(Arc::clone(&moka_cache), wl);
                }
                start.elapsed()
            });
        });

        // TODO: 實作dualcacheFF
        group.bench_with_input(
            BenchmarkId::new("DualCacheFF", workload),
            &workload,
            |b, &wl| {
                let my_cache = Arc::clone(&my_cache);
                b.iter_custom(move |iters| {
                    let start = std::time::Instant::now();
                    for _ in 0..iters {
                        bench_workload(Arc::clone(&my_cache), wl);
                    }
                    start.elapsed()
                });
            },
        );
    }
    group.finish();
}

criterion_group!(benches, bench_throughput);
criterion_main!(benches);
