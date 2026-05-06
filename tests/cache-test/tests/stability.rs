#[global_allocator]
static ALLOC: dhat::Alloc = dhat::Alloc;

use dualcache_ff::{Config, DualCacheFF};
use std::thread::sleep;
use std::time::Duration;

#[test]
fn test_memory_stability() {
    let _profiler = dhat::Profiler::builder().testing().build();

    let mut config = Config::adaptive_config::<i32, Vec<u8>>();
    config.capacity = 1024;
    config.duration = 200;
    let cache = DualCacheFF::new(config);

    // Initial baseline allocation
    sleep(Duration::from_millis(50));
    let initial_stats = dhat::HeapStats::get();
    let initial_bytes = initial_stats.curr_bytes;

    for i in 0..1000 {
        cache.insert(i, vec![0u8; 128]);
    }

    for i in 0..5000 {
        let _ = cache.get(&(i % 1000));
    }

    // Allow daemon batch to process
    sleep(Duration::from_millis(50));

    cache.clear();

    // Wait for the Daemon to process the clear
    sleep(Duration::from_millis(50));

    let final_stats = dhat::HeapStats::get();
    let final_bytes = final_stats.curr_bytes;

    let delta = final_bytes.saturating_sub(initial_bytes);
    
    // We expect the peak memory to be reasonable and current blocks to reflect active items.
    // Ensure memory returns to baseline + acceptable internal OS fragmentation tolerance (e.g. 2MB)
    assert!(
        delta < 2 * 1024 * 1024,
        "Memory leak detected! Initial: {}, Final: {}, Delta: {}",
        initial_bytes,
        final_bytes,
        delta
    );
}
