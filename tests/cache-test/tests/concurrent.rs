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
    let cache = DualCacheFF::new(Config {
        capacity: 128,
        duration: 200,
    });
    
    let ops = Arc::new(AtomicUsize::new(0));

    let mut handles = vec![];
    
    for i in 0..2 {
        let c = cache.clone();
        let ops_clone = ops.clone();
        let handle = thread::spawn(move || {
            let offset = i * 100;
            c.insert(offset, offset);
            c.insert(offset + 1, offset + 1);
            
            let _ = c.get(&offset);
            c.remove(&(offset + 1));
            
            ops_clone.fetch_add(4, Ordering::Relaxed);
        });
        handles.push(handle);
    }
    
    for handle in handles {
        handle.join().unwrap();
    }
    
    assert_eq!(ops.load(Ordering::Relaxed), 8);
});
