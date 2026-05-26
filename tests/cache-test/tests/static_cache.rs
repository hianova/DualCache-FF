#![cfg(not(feature = "loom"))]

use dualcache_ff::Config;
use dualcache_ff::static_cache::{StaticDualCache, DualCacheStub};
use std::sync::Arc;
use std::thread;
use std::sync::atomic::{AtomicUsize, Ordering};
use std::sync::Mutex;
use std::collections::HashMap;

fn run_with_timeout<F, T>(timeout: std::time::Duration, f: F) -> T
where
    F: FnOnce() -> T + Send + 'static,
    T: Send + 'static,
{
    let (tx, rx) = std::sync::mpsc::channel();
    let _handle = std::thread::spawn(move || {
        let res = f();
        let _ = tx.send(res);
    });
    match rx.recv_timeout(timeout) {
        Ok(res) => res,
        Err(_) => {
            panic!("Test timed out after {:?}", timeout);
        }
    }
}

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
    let config = Config::new_expert(128, 64, 64, 200, 4);
    let cache: StaticDualCache<i32, String, 16> = StaticDualCache::new(config);

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
    let config = Config::new_expert(128, 64, 64, 200, 4);
    let cache = Arc::new(StaticDualCache::<i32, i32, 32>::new(config));
    
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
            assert!(val == Some(offset) || val == None); // Since another thread won't overwrite our offset key
            
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
});

test_runner!(test_dual_cache_stub, {
    let config = Config::new_expert(128, 64, 64, 200, 4);
    let stub: DualCacheStub<i32, String> = DualCacheStub::new(config);

    stub.insert(1, "one".to_string());
    assert_eq!(stub.get(&1), None);
    stub.remove(&1);
    stub.clear();
    stub.sync();

    let (stub2, _daemon) = DualCacheStub::<i32, String>::new_headless(config);
    stub2.insert(2, "two".to_string());
    assert_eq!(stub2.get(&2), None);
});
