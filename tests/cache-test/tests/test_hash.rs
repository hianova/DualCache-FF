use dualcache_ff::{Config, DualCacheFF};
use std::time::Duration;

#[test]
fn test_hash_consistency_and_async_insert() {
    let config = Config::new_expert(1024, 256, 256, 60, 4);
    
    // Explicitly create the cache. The hasher is created once and cloned internally.
    let cache = DualCacheFF::new(config);

    // 1. Insert the key 64 times.
    //    - The L1 Lossy Filter requires >= 10 hits to pass through.
    //    - After >= 10 hits, the item lands in the sharded batch buffer.
    //    - sync() explicitly flushes any remaining items in the batch buffer to the Daemon.
    for _ in 0..64 {
        cache.insert(42, 100);
    }
    cache.sync(); // Flush remaining items in shard buffer → Daemon
    // 2. IMMEDIATE GET: This will almost certainly return `None` because the Daemon
    // has not yet processed the channel batch and updated the `ArcSwap` snapshot!
    // This is by design (Nagle's Cognitive Boundary), NOT a hash sync issue.
    let immediate_val = cache.get(&42);
    
    // We expect this to be None, demonstrating the async nature of the cache.
    // If it's Some(100), the daemon was insanely fast, but None is typical.
    println!("Immediate Get: {:?}", immediate_val);

    // 3. Poll for the Daemon to process the batch (timeout is 2000ms)
    let mut delayed_val = None;
    for _ in 0..2000 {
        delayed_val = cache.get(&42);
        if delayed_val.is_some() {
            break;
        }
        std::thread::sleep(Duration::from_millis(1));
    }
    
    println!("Delayed Get: {:?}", delayed_val);
    assert_eq!(delayed_val, Some(100), "Hash inconsistency or Daemon timeout! Item not found.");
}
