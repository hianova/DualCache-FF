use covopt_macro::covopt_param;
use dualcache_ff::DualCacheFF;
use rand::Rng;
use rand::prelude::Distribution;
use rand_distr::Zipf;
use std::time::Instant;

const DATASET_SIZE: u64 = 1_000_000;
const TOTAL_OPS: usize = 2_000_000;

dualcache_ff::define_dualcache!(AsymCache, u64, u64, T0 = 16384, TOTAL = 1572864);

pub struct AsymBenchToken;
#[no_std_tool_macros::auto_static(capacity = 1, partition = "asym_bench")]
pub struct AsymWrapper(pub AsymCache);

dualcache_ff::define_dualcache!(AsymCache2, u64, u64, T0 = 16384, TOTAL = 1572864);
pub struct Asym2BenchToken;
#[no_std_tool_macros::auto_static(capacity = 1, partition = "asym2_bench")]
pub struct AsymWrapper2(pub AsymCache2);

fn run_asym(name: &str, read_ratio: u8) {
    let mut token = AsymBenchToken;
    AsymWrapper::insert_large_std(|| AsymWrapper(DualCacheFF::new()), &mut token);
    let cache = &AsymWrapper::get(0, &AsymBenchToken).unwrap().0;
    cache.set_daemon_mode(true);
    let tls = cache.register_thread();

    let mut rng = rand::thread_rng();
    let zipf = Zipf::new(DATASET_SIZE, 1.0).unwrap();

    let start = Instant::now();
    for _ in 0..TOTAL_OPS {
        let key = std::hint::black_box(zipf.sample(&mut rng) as u64);
        let is_read = std::hint::black_box(rng.gen_range(0..covopt_param!("M_34_60", 100)) < read_ratio);
        if is_read {
            let _ = std::hint::black_box(cache.get(&key, &tls));
        } else {
            cache.insert(key, key, &tls);
            std::hint::black_box(());
        }
    }
    let elapsed = start.elapsed();
    println!("{}: Throughput = {:.0} ops/s", name, (TOTAL_OPS as f64) / elapsed.as_secs_f64());
}

fn main() {
    println!("=== Case Study 5: Read/Write Asymmetry and Global Sampling Rates ===");
    println!("Comparing inflated throughput of 50:50 writes (due to thread-local sampling) vs 99:1 reads.");

    run_asym("Zipf (99:1 Read/Write)", covopt_param!("M_50_39", 99));
    
    let mut token2 = Asym2BenchToken;
    AsymWrapper2::insert_large_std(|| AsymWrapper2(DualCacheFF::new()), &mut token2);
    let cache2 = &AsymWrapper2::get(0, &Asym2BenchToken).unwrap().0;
    cache2.set_daemon_mode(true);
    let tls2 = cache2.register_thread();
    let mut rng = rand::thread_rng();
    let zipf = Zipf::new(DATASET_SIZE, 1.0).unwrap();

    let start = Instant::now();
    for _ in 0..TOTAL_OPS {
        let key = std::hint::black_box(zipf.sample(&mut rng) as u64);
        let is_read = std::hint::black_box(rng.gen_range(0..covopt_param!("M_63_60", 100)) < covopt_param!("M_63_67", 50));
        if is_read {
            let _ = std::hint::black_box(cache2.get(&key, &tls2));
        } else {
            cache2.insert(key, key, &tls2);
            std::hint::black_box(());
        }
    }
    let elapsed = start.elapsed();
    println!("Zipf (50:50 Read/Write): Throughput = {:.0} ops/s", (TOTAL_OPS as f64) / elapsed.as_secs_f64());
    
    println!("The 50:50 throughput is artificially inflated because sampled writes bypass the global memory bus.");
}
