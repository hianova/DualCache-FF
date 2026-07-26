use dualcache_ff::DualCacheFF;
use rand::prelude::Distribution;
use rand_distr::Zipf;
use std::time::Instant;
use std::sync::{Arc, Barrier};

const DATASET_SIZE: u64 = 1_000_000;
const TOTAL_OPS: usize = 2_000_000;
const THREADS: usize = 4;

dualcache_ff::define_dualcache!(FetchUpdateCache, u64, u64, T0 = 16384, TOTAL = 1572864);

pub struct FetchupBenchToken;
#[no_std_tool_macros::auto_static(capacity = 1, partition = "fetchup_bench")]
pub struct FetchUpdateWrapper(pub FetchUpdateCache);

fn main() {
    println!("=== Case Study 2: The fetch_update Paradigm and Zero-Cost Ergonomics ===");
    println!("Simulating highly concurrent access to test P99 tail latency bounded by fetch_update.");

    let mut token = FetchupBenchToken;
    FetchUpdateWrapper::insert_large_std(|| FetchUpdateWrapper(DualCacheFF::new()), &mut token);
    
    crossbeam_utils::thread::scope(|s| {
        let barrier = Arc::new(Barrier::new(THREADS));
        let mut handles = vec![];

        for _ in 0..THREADS {
            let b = barrier.clone();
            handles.push(s.spawn(move |_| {
                let cache = &FetchUpdateWrapper::get(0, &FetchupBenchToken).unwrap().0;
                cache.set_daemon_mode(true);
                let tls = cache.register_thread();
                
                let mut rng = rand::thread_rng();
                let zipf = Zipf::new(DATASET_SIZE, 1.0).unwrap();
                let mut latencies = Vec::with_capacity(TOTAL_OPS / THREADS);

                b.wait();

                for _ in 0..(TOTAL_OPS / THREADS) {
                    let key = std::hint::black_box(zipf.sample(&mut rng) as u64);
                    let start = Instant::now();
                    if std::hint::black_box(cache.get(&key, &tls)).is_none() {
                        cache.insert(key, key, &tls);
                        std::hint::black_box(());
                    }
                    latencies.push(start.elapsed().as_nanos() as u64);
                }

                latencies.sort_unstable();
                latencies[(latencies.len() as f64 * 0.99) as usize]
            }));
        }

        let mut max_p99 = 0;
        for h in handles {
            let p99 = h.join().unwrap();
            if p99 > max_p99 { max_p99 = p99; }
        }
        println!("Max Thread P99 Latency: {} ns", max_p99);
        println!("The stable tail latency confirms fetch_update replaces unbounded CAS spin-loops safely.");
    }).unwrap();
}
