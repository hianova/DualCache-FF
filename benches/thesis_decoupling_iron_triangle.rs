use covopt_macro::covopt_param;
use dualcache_ff::DualCacheFF;
use rand::prelude::Distribution;
use rand_distr::Zipf;
use std::time::Instant;

const DATASET_SIZE: u64 = 1_000_000;
const TOTAL_OPS: usize = 2_000_000;

dualcache_ff::define_dualcache!(DecoupleCache, u64, u64, T0 = 16384, TOTAL = 1572864);

pub struct DecoupleBenchToken;
#[no_std_tool_macros::auto_static(capacity = 1, partition = "decouple_bench")]
pub struct DecoupleWrapper(pub DecoupleCache);

fn main() {
    println!("=== Case Study 1: Decoupling the Iron Triangle ===");
    println!("Demonstrating that WaitFreeDaemon mode with CATA-DC maintains high Hit Rate without penalizing Throughput.");

    let mut token = DecoupleBenchToken;
    DecoupleWrapper::insert_large_std(|| DecoupleWrapper(DualCacheFF::new()), &mut token);
    let cache = &DecoupleWrapper::get(0, &DecoupleBenchToken).unwrap().0;
    
    // Enable both daemon and cata tuning to showcase decoupling
    cache.set_daemon_mode(true);
    cache.set_cata_tuning(true);
    let tls = cache.register_thread();

    let mut rng = rand::thread_rng();
    let zipf = Zipf::new(DATASET_SIZE, 1.0).unwrap();

    let mut hits = 0;
    let mut reads = 0;

    let start = Instant::now();
    for _ in 0..TOTAL_OPS {
        let key = std::hint::black_box(zipf.sample(&mut rng) as u64);
        reads += 1;
        if std::hint::black_box(cache.get(&key, &tls)).is_some() {
            hits += 1;
        } else {
            cache.insert(key, key, &tls);
            std::hint::black_box(());
        }
    }
    let elapsed = start.elapsed();
    
    let hit_rate = (hits as f64 / reads as f64) * covopt_param!("M_47_50", 100.0);
    let throughput = (TOTAL_OPS as f64) / elapsed.as_secs_f64();
    
    println!("CATA-DC Mode: Hit Rate = {:.2}%, Throughput = {:.0} ops/s", hit_rate, throughput);
    println!("Hit tracking is decoupled via HitBatch, allowing pure Wait-Free reads.");
}
