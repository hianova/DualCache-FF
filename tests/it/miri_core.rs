// This file is designed for Miri testing.
// It avoids threading and timeouts which are hostile to Miri's slow execution.
// Run with: cargo miri test --test integration_tests it::miri_core

use dualcache_ff::unsafe_core::Node;
use dualcache_ff::static_cache::StaticDualCache;
use dualcache_ff::Config;

#[test]
fn miri_test_node_allocation() {
    let node = Node {
        key: "miri_test".to_string(),
        value: 100u64,
        expire_at: 0,
        g_idx: 1,
    };
    
    let ptr = Box::into_raw(Box::new(node));
    assert!(!ptr.is_null());
    
    unsafe {
        let node_ref = &*ptr;
        assert_eq!(node_ref.key, "miri_test");
        assert_eq!(node_ref.value, 100u64);
        
        let deallocated_node = Box::from_raw(ptr);
        assert_eq!(deallocated_node.key, "miri_test");
    }
}

#[test]
fn miri_test_static_cache_unsafecell() {
    let config = Config::new_expert(128, 64, 64, 200, 4);
    let cache: StaticDualCache<u32, u32> = StaticDualCache::new(config);
    cache.insert_t1(1, 100);
    cache.insert_t1(2, 200);
    assert_eq!(cache.get(&1), Some(100));
    assert_eq!(cache.get(&2), Some(200));
    cache.remove(&1);
    assert_eq!(cache.get(&1), None);
    
    // Test slot replacement
    cache.insert_t1(3, 300);
    assert_eq!(cache.get(&3), Some(300));
    
    // Clear to avoid Miri memory leak detection
    cache.clear();
}
