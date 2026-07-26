use dualcache_ff::DualCacheFF;
use rand::prelude::Distribution;
use rand_distr::Zipf;
use std::time::Instant;

const DATASET_SIZE: u64 = 1_000_000;
const TOTAL_OPS: usize = 5_000_000;

dualcache_ff::define_dualcache!(SmallCache, u64, u64, T0 = 1024, TOTAL = 6144);
dualcache_ff::define_dualcache!(LargeCache, u64, u64, T0 = 16384, TOTAL = 98304);

pub struct SmallBenchToken;
#[no_std_tool_macros::auto_static(capacity = 1, partition = "small_bench")]
pub struct SmallWrapper(pub SmallCache);

pub struct LargeBenchToken;
#[no_std_tool_macros::auto_static(capacity = 1, partition = "large_bench")]
pub struct LargeWrapper(pub LargeCache);

fn main() {
    println!("=== Thesis 1: Hit Rate — The Capacity and Thrashing Battle ===");
    println!("Demonstrating how Hit Rate is bounded by CAPEX Constraint (Capacity).");
    
    let mut small_token = SmallBenchToken;
    let mut large_token = LargeBenchToken;
    SmallWrapper::insert_large_std(|| SmallWrapper(DualCacheFF::new()), &mut small_token);
    LargeWrapper::insert_large_std(|| LargeWrapper(DualCacheFF::new()), &mut large_token);
    let cache_small = &SmallWrapper::get(0, &SmallBenchToken).unwrap().0;
    cache_small.set_daemon_mode(true);
    let tls_small = cache_small.register_thread();

    let mut rng = rand::thread_rng();
    let zipf = Zipf::new(DATASET_SIZE, 1.0).unwrap();

    let mut hits = 0;
    let mut reads = 0;

    println!("Benchmarking Small Cache (8K)...");
    let start = Instant::now();
    for _ in 0..TOTAL_OPS {
        let key = std::hint::black_box(zipf.sample(&mut rng) as u64);
        reads += 1;
        if std::hint::black_box(cache_small.get(&key, &tls_small)).is_some() {
            hits += 1;
        } else {
            cache_small.insert(key, key, &tls_small);
            std::hint::black_box(());
        }
    }
    let elapsed = start.elapsed();
    let hit_rate = (hits as f64 / reads as f64) * 100.0;
    println!("Small Cache: Hit Rate = {:.2}%, Throughput = {:.0} ops/s", hit_rate, (TOTAL_OPS as f64) / elapsed.as_secs_f64());
}
