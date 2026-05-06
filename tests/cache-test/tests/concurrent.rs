use dualcache_ff::{Config, DualCacheFF};
use std::sync::Arc;

#[cfg(loom)]
use loom::thread;
#[cfg(not(loom))]
use std::thread;

#[cfg(loom)]
use loom::sync::atomic::{AtomicUsize, Ordering};
#[cfg(not(loom))]
use std::sync::atomic::{AtomicUsize, Ordering};

#[cfg(loom)]
use loom::sync::Mutex;
#[cfg(not(loom))]
use std::sync::Mutex;

use std::collections::HashMap;

#[cfg(loom)]
macro_rules! test_runner {
    ($name:ident, $body:expr) => {
        #[test]
        fn $name() {
            loom::model(|| {
                $body
            });
        }
    };
}

#[cfg(not(loom))]
macro_rules! test_runner {
    ($name:ident, $body:expr) => {
        #[test]
        fn $name() {
            $body
        }
    };
}

test_runner!(test_concurrent_ops, {
    let mut config = Config::adaptive_config::<i32, i32>();
    config.capacity = 128;
    config.duration = 200;
    let cache = DualCacheFF::new(config);
    
    let ops = Arc::new(AtomicUsize::new(0));
    let shadow = Arc::new(Mutex::new(HashMap::new()));

    let mut handles = vec![];
    
    for i in 0..2 {
        let c = cache.clone();
        let ops_clone = ops.clone();
        let shadow_clone = shadow.clone();
        let handle = thread::spawn(move || {
            let offset = i * 100;
            c.insert(offset, offset);
            shadow_clone.lock().unwrap().insert(offset, offset);
            
            c.insert(offset + 1, offset + 1);
            shadow_clone.lock().unwrap().insert(offset + 1, offset + 1);
            
            let _ = c.get(&offset);
            
            c.remove(&(offset + 1));
            shadow_clone.lock().unwrap().remove(&(offset + 1));
            
            ops_clone.fetch_add(4, Ordering::Relaxed);
        });
        handles.push(handle);
    }
    
    for handle in handles {
        handle.join().unwrap();
    }
    
    assert_eq!(ops.load(Ordering::Relaxed), 8);

    #[cfg(not(loom))]
    {
        // Wait for Daemon to converge in real execution
        cache.sync();
        let expected_map = shadow.lock().unwrap();
        for (k, expected_v) in expected_map.iter() {
            if let Some(actual_v) = cache.get(k) {
                assert_eq!(
                    actual_v, *expected_v,
                    "Concurrent Corruption! Key {} expected {}, got {}",
                    k, expected_v, actual_v
                );
            }
        }
    }
});

#[cfg(not(loom))]
#[test]
fn test_ttl_mechanic() {
    use std::time::Duration;
    
    let mut config = Config::adaptive_config::<i32, i32>();
    config.capacity = 128;
    config.duration = 1;
    let cache = DualCacheFF::new(config);
    
    cache.insert(1, 100);
    cache.insert(1, 100); // Second insert bypasses Ghost Set filter
    
    // Wait for insertion
    cache.sync();
    assert_eq!(cache.get(&1), Some(100));
    
    // Poll for TTL expiration instead of a hard 2-second sleep
    let mut expired = false;
    for _ in 0..25 {
        if cache.get(&1).is_none() {
            expired = true;
            break;
        }
        thread::sleep(Duration::from_millis(100));
    }
    
    assert!(expired, "TTL Mechanic failed: item did not expire within 2.5 seconds");
}
