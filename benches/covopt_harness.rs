#![allow(long_running_const_eval)]
use std::vec::Vec;
use crossbeam_utils::thread;
use dualcache_ff::DualCacheFF;
use rand::Rng;
use rand::prelude::Distribution;
use rand_distr::Zipf;
use std::sync::{Arc, Barrier};
use std::time::Instant;

const THREAD_COUNT: usize = 4;
const TOTAL_OPS: usize = 4_000_000;
const OPS_PER_THREAD: usize = TOTAL_OPS / THREAD_COUNT;
const DATASET_SIZE: u64 = 1_000_000;

dualcache_ff::define_dualcache!(BenchCache, u64, u64, T0 = 16_384, TOTAL = 1_572_864);

use no_std_tool::lazy_static;

lazy_static! {
    static ref GLOBAL_CACHE: BenchCache = DualCacheFF::new();
}

fn main() {
    std::thread::Builder::new()
        .stack_size(1024 * 1024 * 1024)
        .spawn(|| {
            let zipf = Zipf::new(DATASET_SIZE, 0.99).unwrap();

            let mut all_ops_data = Vec::new();
            for _thread_id in 0..THREAD_COUNT {
                let mut rng = rand::thread_rng();
                let mut ops_data = Vec::with_capacity(OPS_PER_THREAD);
                for _ in 0..OPS_PER_THREAD {
                    let key = zipf.sample(&mut rng) as u64;
                    let is_read = rng.gen_range(0..100) < 50;
                    ops_data.push((key, is_read));
                }
                all_ops_data.push(ops_data);
            }

            let cache = &*GLOBAL_CACHE;
            cache.set_daemon_mode(true);
            let warmup_handle = cache.register_thread();
            for &(key, _) in all_ops_data[0].iter().take(10_000) {
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
                                key_idx = if key_idx + 1 == ops_len { 0 } else { key_idx + 1 };

                                if is_read {
                                    if cache.get(&key, tls).is_none() {
                                        cache.insert(key, key, tls);
                                    }
                                } else {
                                    cache.insert(key, key, tls);
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
