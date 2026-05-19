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

#[cfg(not(loom))]
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
            run_with_timeout(std::time::Duration::from_secs(10), || {
                $body
            });
        }
    };
}

test_runner!(test_concurrent_ops, {
    let config = Config::new_expert(128, 64, 64, 200, 4);
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
    run_with_timeout(std::time::Duration::from_secs(10), || {
        use std::time::Duration;
        
        let config = Config::new_expert(128, 64, 64, 1, 4);
        let cache = DualCacheFF::new(config);
        
        // Insert 64 times to trigger L1 Lossy Filter (>=10 hits) and sharded batch flush (64 items)
        for _ in 0..64 {
            cache.insert(1, 100);
        }
        
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
    });
}
