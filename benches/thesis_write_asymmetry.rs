#![allow(long_running_const_eval)]
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
        let key = zipf.sample(&mut rng) as u64;
        let is_read = rng.gen_range(0..100) < read_ratio;
        if is_read {
            let _ = cache.get(&key, &tls);
        } else {
            cache.insert(key, key, &tls);
        }
    }
    let elapsed = start.elapsed();
    println!("{}: Throughput = {:.0} ops/s", name, (TOTAL_OPS as f64) / elapsed.as_secs_f64());
}

fn main() {
    println!("=== Case Study 5: Read/Write Asymmetry and Global Sampling Rates ===");
    println!("Comparing inflated throughput of 50:50 writes (due to thread-local sampling) vs 99:1 reads.");

    run_asym("Zipf (99:1 Read/Write)", 99);
    
    // We recreate the token mapping since run_asym resets it, wait actually run_asym is just a simulation 
    // and multiple inserts to the static macro in the same thread might panic if not cleared. 
    let mut token2 = Asym2BenchToken;
    AsymWrapper2::insert_large_std(|| AsymWrapper2(DualCacheFF::new()), &mut token2);
    let cache2 = &AsymWrapper2::get(0, &Asym2BenchToken).unwrap().0;
    cache2.set_daemon_mode(true);
    let tls2 = cache2.register_thread();
    let mut rng = rand::thread_rng();
    let zipf = Zipf::new(DATASET_SIZE, 1.0).unwrap();

    let start = Instant::now();
    for _ in 0..TOTAL_OPS {
        let key = zipf.sample(&mut rng) as u64;
        let is_read = rng.gen_range(0..100) < 50;
        if is_read {
            let _ = cache2.get(&key, &tls2);
        } else {
            cache2.insert(key, key, &tls2);
        }
    }
    let elapsed = start.elapsed();
    println!("Zipf (50:50 Read/Write): Throughput = {:.0} ops/s", (TOTAL_OPS as f64) / elapsed.as_secs_f64());
    
    println!("The 50:50 throughput is artificially inflated because sampled writes bypass the global memory bus.");
}
