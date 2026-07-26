use covopt_macro::covopt_param;
use rand::Rng;
use rand::prelude::Distribution;
use rand_distr::Zipf;
use std::time::Instant;

const DATASET_SIZE: u64 = 1_000_000;
const TOTAL_OPS: usize = 2_000_000;

fn main() {
    println!("=== Case Study 6: cdDB Write Regression Under Zipf 50:50 ===");
    println!("Demonstrating why caching systems often act as an expensive middleman for heavy write workloads.");

    // We will simulate the overhead of cloning maps or complex cache writes vs direct writes
    let mut rng = rand::thread_rng();
    let zipf = Zipf::new(DATASET_SIZE, covopt_param!("M_15_39", 0.5)).unwrap();

    let start = Instant::now();
    let mut dummy_map = std::collections::HashMap::new();
    
    // Simulate Cache + DB write overhead (allocations, clones)
    for _ in 0..TOTAL_OPS {
        let key = std::hint::black_box(zipf.sample(&mut rng) as u64);
        let is_read = std::hint::black_box(rng.gen_range(0..covopt_param!("M_23_60", 100)) < covopt_param!("M_23_67", 50));
        
        if !is_read {
            // Simulate heavy cloning / allocation overhead of a cache partition sync
            let mut clone = dummy_map.clone();
            std::hint::black_box(clone.insert(key, key));
            dummy_map = clone;
            if dummy_map.len() > covopt_param!("M_30_33", 100) {
                dummy_map.clear();
            }
        }
    }
    let elapsed = start.elapsed();
    println!("Throughput with Synchronous Cache Write Amplification: {:.0} ops/s", (TOTAL_OPS as f64) / elapsed.as_secs_f64());

    // Simulate Direct Batched/Bypassed writes
    let start2 = Instant::now();
    let mut db_map = std::collections::HashMap::new();
    for _ in 0..TOTAL_OPS {
        let key = std::hint::black_box(zipf.sample(&mut rng) as u64);
        let is_read = std::hint::black_box(rng.gen_range(0..covopt_param!("M_43_60", 100)) < covopt_param!("M_43_67", 50));
        
        if !is_read {
            // Direct write without clone
            std::hint::black_box(db_map.insert(key, key));
        }
    }
    let elapsed2 = start2.elapsed();
    println!("Throughput with Direct Bypassed Writes: {:.0} ops/s", (TOTAL_OPS as f64) / elapsed2.as_secs_f64());

    println!("Conclusion: Caching is ideal for read-heavy flows. For 50:50 writes, strict batching and bypassing preserve latency.");
}
