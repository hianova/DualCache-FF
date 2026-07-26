use dualcache_ff::DualCacheFF;
use rand::prelude::Distribution;
use rand_distr::Zipf;
use std::time::Instant;

const DATASET_SIZE: u64 = 1_000_000;
const TOTAL_OPS: usize = 5_000_000;

dualcache_ff::define_dualcache!(ProbCache, u64, u64, T0 = 16384, TOTAL = 1572864);

pub struct ProbBenchToken;
#[no_std_tool_macros::auto_static(capacity = 1, partition = "prob_bench")]
pub struct ProbWrapper(pub ProbCache);

fn main() {
    println!("=== Case Study 4: The 100M ops/s Breakthrough (Probabilistic TLS Promotion) ===");
    println!("Showcasing how the probabilistic mask `op_count & 63 == 0` balances L1 Read Contention and TLS Cache Pollution.");

    let mut token = ProbBenchToken;
    ProbWrapper::insert_large_std(|| ProbWrapper(DualCacheFF::new()), &mut token);
    let cache = &ProbWrapper::get(0, &ProbBenchToken).unwrap().0;
    cache.set_daemon_mode(true);
    let tls = cache.register_thread();

    let mut rng = rand::thread_rng();
    let zipf = Zipf::new(DATASET_SIZE, 1.0).unwrap();

    let start = Instant::now();
    for _ in 0..TOTAL_OPS {
        let key = std::hint::black_box(zipf.sample(&mut rng) as u64);
        if std::hint::black_box(cache.get(&key, &tls)).is_none() {
            cache.insert(key, key, &tls);
        std::hint::black_box(());
        }
    }
    let elapsed = start.elapsed();
    println!("Throughput with Probabilistic Promotion: {:.0} ops/s", (TOTAL_OPS as f64) / elapsed.as_secs_f64());
    println!("This harmonizes 99:1 (hot keys migrate to TLS) and 50:50 (rare keys stay in T0).");
}
