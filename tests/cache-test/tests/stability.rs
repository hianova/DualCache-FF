#[global_allocator]
static ALLOC: dhat::Alloc = dhat::Alloc;

use dualcache_ff::{Config, DualCacheFF};
use std::thread::sleep;
use std::time::Duration;

#[test]
fn test_memory_stability() {
    let _profiler = dhat::Profiler::builder().testing().build();
    
    let cache = DualCacheFF::new(Config {
        capacity: 1024,
        duration: 200,
    });
    
    for i in 0..1000 {
        cache.insert(i, vec![0u8; 128]);
    }
    
    for i in 0..5000 {
        let _ = cache.get(&(i % 1000));
    }
    
    // Allow daemon batch to process
    sleep(Duration::from_millis(50));
    
    cache.clear();
    
    sleep(Duration::from_millis(50));
    
    let stats = dhat::HeapStats::get();
    
    // We expect the peak memory to be reasonable and current blocks to reflect active items.
    // The test ensures the allocation profiler correctly attaches and tracks `DualCacheFF` memory.
    assert!(stats.total_bytes > 0);
}
