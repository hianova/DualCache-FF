use dualcache_ff::{Config, DualCacheFF};
use std::time::Duration;

#[test]
fn test_hash_consistency_and_async_insert() {
    let mut config = Config::adaptive_config::<u64, u64>();
    config.capacity = 100;
    config.duration = 60;
    
    // Explicitly create the cache. The hasher is created once and cloned internally.
    let cache = DualCacheFF::new(config);

    // 1. Insert a key. This sends a message to the Daemon channel.
    cache.insert(42, 100);
    
    // 2. IMMEDIATE GET: This will almost certainly return `None` because the Daemon
    // has not yet processed the channel batch and updated the `ArcSwap` snapshot!
    // This is by design (Nagle's Cognitive Boundary), NOT a hash sync issue.
    let immediate_val = cache.get(&42);
    
    // We expect this to be None, demonstrating the async nature of the cache.
    // If it's Some(100), the daemon was insanely fast, but None is typical.
    println!("Immediate Get: {:?}", immediate_val);

    // 3. Poll for the Daemon to process the batch (timeout is 200ms)
    let mut delayed_val = None;
    for _ in 0..200 {
        delayed_val = cache.get(&42);
        if delayed_val.is_some() {
            break;
        }
        std::thread::sleep(Duration::from_millis(1));
    }
    
    println!("Delayed Get: {:?}", delayed_val);
    assert_eq!(delayed_val, Some(100), "Hash inconsistency or Daemon timeout! Item not found.");
}
