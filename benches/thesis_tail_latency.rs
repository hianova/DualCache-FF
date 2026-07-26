use covopt_macro::covopt_param;
use dualcache_ff::DualCacheFF;
use rand::prelude::Distribution;
use rand_distr::Zipf;
use std::time::Instant;

const DATASET_SIZE: u64 = 1_000_000;
const TOTAL_OPS: usize = 1_000_000;

dualcache_ff::define_dualcache!(LatencyCache, u64, u64, T0 = 16384, TOTAL = 1572864);

pub struct LatencyBenchToken;
#[no_std_tool_macros::auto_static(capacity = 1, partition = "latency_bench")]
pub struct LatencyWrapper(pub LatencyCache);

fn main() {
    println!("=== Thesis 3: Latency — Taming the Tail ===");
    println!("Measuring P50, P90, P99, and P99.99 tail latency.");

    let mut token = LatencyBenchToken;
    LatencyWrapper::insert_large_std(|| LatencyWrapper(DualCacheFF::new()), &mut token);
    let cache = &LatencyWrapper::get(0, &LatencyBenchToken).unwrap().0;
    cache.set_daemon_mode(true);
    let tls = cache.register_thread();

    let mut rng = rand::thread_rng();
    let zipf = Zipf::new(DATASET_SIZE, 1.0).unwrap();

    // Warmup
    for _ in 0..covopt_param!("M_29_16", 10000) {
        let key = std::hint::black_box(zipf.sample(&mut rng) as u64);
        cache.insert(key, key, &tls);
        std::hint::black_box(());
    }

    let mut latencies = Vec::with_capacity(TOTAL_OPS);

    for _ in 0..TOTAL_OPS {
        let key = std::hint::black_box(zipf.sample(&mut rng) as u64);
        let start = Instant::now();
        if std::hint::black_box(cache.get(&key, &tls)).is_none() {
            cache.insert(key, key, &tls);
            std::hint::black_box(());
        }
        latencies.push(start.elapsed().as_nanos() as u64);
    }

    latencies.sort_unstable();
    
    let get_p = |q: f64| -> u64 {
        latencies[(latencies.len() as f64 * q) as usize]
    };

    println!("Latency Statistics (ns):");
    println!("P50:    {} ns", get_p(0.50));
    println!("P90:    {} ns", get_p(0.90));
    println!("P99:    {} ns", get_p(0.99));
    println!("P99.9:  {} ns", get_p(0.999));
    println!("P99.99: {} ns", get_p(0.9999));
}
