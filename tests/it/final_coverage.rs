use dualcache_ff::{Config, DualCacheFF};
use dualcache_ff::static_cache::StaticDualCache;
use std::sync::Arc;

#[test]
fn test_everything() {
    let config = Config::new_expert(256, 16, 16, 200, 32);
    let cache = DualCacheFF::<u64, u64>::new(config.clone());
    
    // hit wake_daemon_if_parked when thread is None by artificially setting parked state
    // But since `is_parked` and `wake_daemon_if_parked` are crate-private, we can't directly manipulate them here.
    // Instead, we just let `DualCacheFF` do its normal workflow.
    
    // Test APIs
    cache.insert(1, 1);
    cache.insert_sync(2, 2);
    let _ = cache.get(&1);
    let _ = cache.get_with_filter(&2, |_| true);
    cache.remove(&1);
    
    cache.clear();
    cache.sync();
    
    cache.suspend();
    cache.resume();
    
    // Ensure capacity
    let c = cache.clone();
    let handles: Vec<_> = (0..100).map(|i| {
        let c = c.clone();
        std::thread::spawn(move || {
            c.insert(i, i);
        })
    }).collect();
    for h in handles { h.join().unwrap(); }
    
    cache.shutdown_gracefully(None);
    
    // Core drop test (dropping while items are in garbage_queue)
    let evict_cb: Arc<dyn Fn(u64, u64) + Send + Sync> = Arc::new(|_k, _v| {});
    let c2 = StaticDualCache::<u64, u64>::new_with_callbacks(
        config.clone(),
        Some(evict_cb),
        None,
    );
    
    // Fill to capacity to trigger eviction and put nodes in garbage_queue
    // Because it's StaticDualCache, inserts are synchronous and bypass the daemon.
    for i in 0..300 {
        c2.insert(i, i);
    }
    // Now garbage queue has items. Dropping c2 will drop them inside CoreCache::drop.
    drop(c2);
}
