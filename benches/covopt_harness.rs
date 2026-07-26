use covopt_macro::covopt_param;
use crossbeam_utils::thread;
use dualcache_ff::DualCacheFF;
use rand::Rng;
use rand::prelude::Distribution;
use rand_distr::Zipf;
use std::sync::{Arc, Barrier};
use std::time::Instant;
use std::vec::Vec;

const THREAD_COUNT: usize = 4;
const TOTAL_OPS: usize = 4_000_000;
const OPS_PER_THREAD: usize = TOTAL_OPS / THREAD_COUNT;
const DATASET_SIZE: u64 = 1_000_000;

dualcache_ff::define_dualcache!(BenchCache, u64, u64, T0 = 16_384, TOTAL = 1_572_864);

pub struct CovBenchToken;

#[no_std_tool_macros::auto_static(capacity = 1, partition = "cov_bench")]
pub struct GlobalBenchCacheWrapper(pub BenchCache);

fn main() {
    std::thread::Builder::new()
        .stack_size(covopt_param!("M_24_20", 1024) * covopt_param!("M_24_27", 1024) * covopt_param!("M_24_34", 1024))
        .spawn(|| {
            let mut token = CovBenchToken;
            GlobalBenchCacheWrapper::insert(
                GlobalBenchCacheWrapper(DualCacheFF::new()),
                &mut token,
            );
            let zipf = Zipf::new(DATASET_SIZE, covopt_param!("M_31_47", 0.99)).unwrap();

            let mut all_ops_data = Vec::new();
            for _thread_id in 0..THREAD_COUNT {
                let mut rng = rand::thread_rng();
                let mut ops_data = Vec::with_capacity(OPS_PER_THREAD);
                for _ in 0..OPS_PER_THREAD {
                    let key = zipf.sample(&mut rng) as u64;
                    let is_read = rng.gen_range(0..covopt_param!("M_39_51", 100)) < covopt_param!("M_39_58", 50);
                    ops_data.push((key, is_read));
                }
                all_ops_data.push(ops_data);
            }

            let token: &'static CovBenchToken = &CovBenchToken;
            let cache = &GlobalBenchCacheWrapper::get(0, token).unwrap().0;
            cache.set_daemon_mode(true);
            let warmup_handle = cache.register_thread();
            for &(key, _) in all_ops_data[0].iter().take(covopt_param!("M_49_57", 10000)) {
                cache.insert(key, key, &warmup_handle);
            }

            let start_time = Instant::now();
            let barrier = Arc::new(Barrier::new(THREAD_COUNT));

            thread::scope(|s| {
                for (thread_id, ops_data) in all_ops_data.iter().enumerate().take(THREAD_COUNT) {
                    let ops_data = ops_data.clone();
                    let barrier_clone = barrier.clone();

                    s.builder()
                        .name(format!("Thread-{}", thread_id))
                        .spawn(move |_| {
                            let tls_handle = cache.register_thread();
                            let tls = &tls_handle;

                            barrier_clone.wait();

                            let mut local_ops = 0;
                            let mut key_idx = 0;
                            let ops_len = ops_data.len();

                            while local_ops < OPS_PER_THREAD {
                                let (key, is_read) = ops_data[key_idx];
                                let key = std::hint::black_box(key);
                                let is_read = std::hint::black_box(is_read);
                                key_idx = if key_idx + 1 == ops_len {
                                    0
                                } else {
                                    key_idx + 1
                                };

                                if is_read {
                                    if std::hint::black_box(cache.get(&key, tls)).is_none() {
                                        cache.insert(key, key, tls);
                                        std::hint::black_box(());
                                    }
                                } else {
                                    cache.insert(key, key, tls);
                                    std::hint::black_box(());
                                }
                                local_ops += 1;
                            }
                        })
                        .unwrap();
                }
            })
            .unwrap();

            let duration = start_time.elapsed();
            let throughput = (TOTAL_OPS as f64) / duration.as_secs_f64();
            println!("COVOPT_SCORE: {:.2}", throughput);
        })
        .unwrap()
        .join()
        .unwrap();
}
