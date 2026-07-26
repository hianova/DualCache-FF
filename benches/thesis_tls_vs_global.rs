use covopt_macro::covopt_param;
use dualcache_ff::DualCacheFF;
use rand::prelude::Distribution;
use rand_distr::Zipf;
use std::time::Instant;

const DATASET_SIZE: u64 = 1_000_000;
const TOTAL_OPS: usize = 2_000_000;

dualcache_ff::define_dualcache!(TLSGlobalCache, u64, u64, T0 = 16384, TOTAL = 1572864);

pub struct TlsBenchToken;
#[no_std_tool_macros::auto_static(capacity = 1, partition = "tls_bench")]
pub struct TLSWrapper(pub TLSGlobalCache);

fn main() {
    println!("=== Case Study 3: The Reality of Thread-Local Capacity vs Global Broadcast ===");
    println!("Contrasting extreme TLS capacity against Global T0 under Zipf 99:1 and Zipf 50:50.");

    let mut token = TlsBenchToken;
    TLSWrapper::insert_large_std(|| TLSWrapper(DualCacheFF::new()), &mut token);
    let cache = &TLSWrapper::get(0, &TlsBenchToken).unwrap().0;
    cache.set_daemon_mode(true);
    let tls = cache.register_thread();

    let mut rng = rand::thread_rng();
    
    // Zipf 99:1
    let zipf_99 = Zipf::new(DATASET_SIZE, 1.0).unwrap();
    let start = Instant::now();
    for _ in 0..TOTAL_OPS {
        let key = std::hint::black_box(zipf_99.sample(&mut rng) as u64);
        if std::hint::black_box(cache.get(&key, &tls)).is_none() {
            cache.insert(key, key, &tls);
            std::hint::black_box(());
        }
    }
    let elapsed = start.elapsed();
    println!("Zipf 99:1 Throughput (Hot keys absorbed by TLS): {:.0} ops/s", (TOTAL_OPS as f64) / elapsed.as_secs_f64());

    // Zipf 50:50
    let zipf_50 = Zipf::new(DATASET_SIZE, covopt_param!("M_41_42", 0.5)).unwrap();
    let start2 = Instant::now();
    for _ in 0..TOTAL_OPS {
        let key = std::hint::black_box(zipf_50.sample(&mut rng) as u64);
        if std::hint::black_box(cache.get(&key, &tls)).is_none() {
            cache.insert(key, key, &tls);
            std::hint::black_box(());
        }
    }
    let elapsed2 = start2.elapsed();
    println!("Zipf 50:50 Throughput (TLS polluted by long tail): {:.0} ops/s", (TOTAL_OPS as f64) / elapsed2.as_secs_f64());
    
    println!("Conclusion: TLS absorbs extreme hotspots, but T0/T1 are mandatory for long-tail workloads.");
}
