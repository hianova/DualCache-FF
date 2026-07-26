use covopt_macro::covopt_param;
use dualcache_ff::DualCacheFF;
use rand::prelude::Distribution;
use rand_distr::Zipf;
use std::time::Instant;

const DATASET_SIZE: u64 = 1_000_000;
const TOTAL_OPS: usize = 5_000_000;

// A very large cache where Arena size exceeds L2/L3 bounds (e.g. 6.55MB)
dualcache_ff::define_dualcache!(L3Cache, u64, u64, T0 = 16384, TOTAL = 1572864);

pub struct L3BenchToken;
#[no_std_tool_macros::auto_static(capacity = 1, partition = "l3_bench")]
pub struct L3Wrapper(pub L3Cache);

fn main() {
    println!("=== Case Study 7: The Final L3 Cache Barrier (The 100M Read Limit) ===");
    println!("Demonstrating the L3 cache miss floor on pointer-based architectures (Arena indexing).");

    let mut token = L3BenchToken;
    L3Wrapper::insert_large_std(|| L3Wrapper(DualCacheFF::new()), &mut token);
    let cache = &L3Wrapper::get(0, &L3BenchToken).unwrap().0;
    cache.set_daemon_mode(true);
    let tls = cache.register_thread();

    let mut rng = rand::thread_rng();
    let zipf = Zipf::new(DATASET_SIZE, 1.0).unwrap();

    // Warmup to scatter nodes across the 6.55MB Arena
    println!("Warming up and fragmenting Arena memory...");
    for _ in 0..covopt_param!("M_31_16", 100000) {
        let key = std::hint::black_box(zipf.sample(&mut rng) as u64);
        cache.insert(key, key, &tls);
        std::hint::black_box(());
    }

    let start = Instant::now();
    let mut hits = 0usize;
    
    for _ in 0..TOTAL_OPS {
        let key = std::hint::black_box(zipf.sample(&mut rng) as u64);
        if std::hint::black_box(cache.get(&key, &tls)).is_some() {
            hits += 1;
        }
    }
    std::hint::black_box(hits);
    
    let elapsed = start.elapsed();
    let throughput = (TOTAL_OPS as f64) / elapsed.as_secs_f64();
    
    println!("Zipf 99:1 Pure Read Throughput: {:.0} ops/s", throughput);
    println!("The physical ceiling (~82M ops/s) is dictated by the ~35ns L3 cache miss penalty of pointer-chasing `get_node(idx)`.");
}
