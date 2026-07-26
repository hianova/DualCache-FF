use dualcache_ff::DualCacheFF;
use rand::distributions::Uniform;
use rand::prelude::Distribution;
use rand_distr::Zipf;
use std::time::Instant;

const DATASET_SIZE: u64 = 1_000_000;
const TOTAL_OPS: usize = 5_000_000;

dualcache_ff::define_dualcache!(ThroughputCache, u64, u64, T0 = 16384, TOTAL = 1572864);

pub struct ThroughputBenchToken;
#[no_std_tool_macros::auto_static(capacity = 1, partition = "throughput_bench")]
pub struct ThroughputWrapper(pub ThroughputCache);

fn main() {
    println!("=== Thesis 2: Throughput — The War on Contention and Miss-Path Penalties ===");
    println!("Comparing throughput on Wait-Free Fast Paths under Zipfian vs Uniform distributions.");

    let mut token = ThroughputBenchToken;
    ThroughputWrapper::insert_large_std(|| ThroughputWrapper(DualCacheFF::new()), &mut token);
    let cache = &ThroughputWrapper::get(0, &ThroughputBenchToken).unwrap().0;
    cache.set_daemon_mode(true);
    let tls = cache.register_thread();

    let mut rng = rand::thread_rng();
    let zipf = Zipf::new(DATASET_SIZE, 1.0).unwrap();
    let uniform = Uniform::new(0, DATASET_SIZE);

    // Warmup
    for _ in 0..10_000 {
        let key = std::hint::black_box(zipf.sample(&mut rng) as u64);
        cache.insert(key, key, &tls);
        std::hint::black_box(());
    }

    // Zipfian Test
    let start = Instant::now();
    for _ in 0..TOTAL_OPS {
        let key = std::hint::black_box(zipf.sample(&mut rng) as u64);
        if std::hint::black_box(cache.get(&key, &tls)).is_none() {
            cache.insert(key, key, &tls);
            std::hint::black_box(());
        }
    }
    let elapsed = start.elapsed();
    println!("Zipfian 99:1 Throughput: {:.0} ops/s", (TOTAL_OPS as f64) / elapsed.as_secs_f64());

    // Uniform Test
    let start = Instant::now();
    for _ in 0..TOTAL_OPS {
        let key = std::hint::black_box(uniform.sample(&mut rng));
        if std::hint::black_box(cache.get(&key, &tls)).is_none() {
            cache.insert(key, key, &tls);
            std::hint::black_box(());
        }
    }
    let elapsed = start.elapsed();
    println!("Uniform Throughput (Miss-Path Penalty): {:.0} ops/s", (TOTAL_OPS as f64) / elapsed.as_secs_f64());
}
