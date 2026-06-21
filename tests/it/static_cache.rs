

use dualcache_ff::Config;
use dualcache_ff::static_cache::{StaticDualCache, DualCacheStub};
use std::sync::Arc;
use std::thread;
use std::sync::atomic::{AtomicUsize, Ordering};
use std::sync::Mutex;
use std::collections::HashMap;

use crate::common::run_with_timeout;

macro_rules! test_runner {
    ($name:ident, $body:expr) => {
        #[test]
        fn $name() {
            run_with_timeout(std::time::Duration::from_secs(10), || {
                $body
            });
        }
    };
}

test_runner!(test_static_cache_basic, {
    let config = Config::new_expert(128, 64, 64, 200, 128);
    let cache: StaticDualCache<i32, String> = StaticDualCache::new(config);

    // Basic insertion and retrieval
    cache.insert(1, "one".to_string());
    cache.insert(2, "two".to_string());

    assert_eq!(cache.get(&1), Some("one".to_string()));
    assert_eq!(cache.get(&2), Some("two".to_string()));
    assert_eq!(cache.get(&3), None);

    // Update
    cache.insert(1, "one_updated".to_string());
    assert_eq!(cache.get(&1), Some("one_updated".to_string()));

    // Remove
    cache.remove(&1);
    assert_eq!(cache.get(&1), None);
    assert_eq!(cache.get(&2), Some("two".to_string()));

    // Clear
    cache.clear();
    assert_eq!(cache.get(&2), None);
});

test_runner!(test_static_cache_concurrent, {
    let config = Config::new_expert(128, 64, 64, 200, 128);
    let cache = Arc::new(StaticDualCache::<i32, i32>::new(config));
    
    let ops = Arc::new(AtomicUsize::new(0));
    let shadow = Arc::new(Mutex::new(HashMap::new()));
    let mut handles = vec![];
    
    for i in 0..4 {
        let c = cache.clone();
        let ops_clone = ops.clone();
        let shadow_clone = shadow.clone();
        let handle = thread::spawn(move || {
            let offset = i * 100;
            // Write unique keys
            c.insert(offset, offset);
            shadow_clone.lock().unwrap().insert(offset, offset);
            
            c.insert(offset + 1, offset + 1);
            shadow_clone.lock().unwrap().insert(offset + 1, offset + 1);
            
            // Read
            let val = c.get(&offset);
            assert!(val == Some(offset) || val.is_none()); // Since another thread won't overwrite our offset key
            
            // Remove
            c.remove(&(offset + 1));
            shadow_clone.lock().unwrap().remove(&(offset + 1));
            
            ops_clone.fetch_add(4, Ordering::Relaxed);
        });
        handles.push(handle);
    }
    
    for handle in handles {
        handle.join().unwrap();
    }
    
    assert_eq!(ops.load(Ordering::Relaxed), 16);

    let shadow_map = shadow.lock().unwrap();
    let mut found = 0;
    for (k, expected_v) in shadow_map.iter() {
        if let Some(actual_v) = cache.get(k) {
            assert_eq!(*expected_v, actual_v);
            found += 1;
        }
    }
    assert!(found > 0, "Vacuous assertion: no items found in static cache after concurrent inserts");
});

test_runner!(test_dual_cache_stub, {
    let config = Config::new_expert(128, 64, 64, 200, 128);
    let stub: DualCacheStub<i32, String> = DualCacheStub::new(config);

    stub.insert(1, "one".to_string());
    assert_eq!(stub.get(&1), None);
    stub.remove(&1);
    stub.clear();
    stub.sync();

    let (stub2, _daemon) = DualCacheStub::<i32, String>::new_headless(Config::new_expert(128, 64, 64, 200, 128));
    stub2.insert(2, "two".to_string());
    assert_eq!(stub2.get(&2), None);
});

test_runner!(test_static_cache_coverage_extras, {
    let config = Config::new_expert(128, 64, 64, 200, 128);
    let cache = StaticDualCache::<u64, u64>::new_with_callbacks(config.clone(), None, None);
    cache.insert(1, 1);
    
    let (cache2, daemon) = StaticDualCache::<u64, u64>::new_headless(config.clone());
    daemon.run(); // covers DummyDaemon::run
    
    let _session = cache2.begin_cold_start_session();
});
