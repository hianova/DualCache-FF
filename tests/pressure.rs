#![cfg(not(feature = "loom"))]

use dualcache_ff::{Config, DualCacheFF};
use std::collections::HashMap;
use std::sync::{Arc, Mutex};
use std::thread;
use std::time::Duration;

mod common;
use common::run_with_timeout;

#[test]
fn test_capacity_pressure_and_eviction() {
    run_with_timeout(Duration::from_secs(30), || {
        let config = Config::new_expert(1024, 256, 256, 60, 4);
        let cache = DualCacheFF::new(config);

        // Insert each item 12 times to satisfy the L1 Lossy Filter threshold (>= 10 hits).
        for i in 0..200_000 {
            for _ in 0..12 {
                cache.insert(i, format!("Value_{}", i));
            }
        }

        // Wait for the Daemon to catch up and process evictions
        cache.sync();

        // Verify eviction correctness:
        // We shouldn't get wrong values. If a value exists, it MUST match the expected string.
        let mut found = 0;
        for i in (0..200_000).step_by(100) {
            if let Some(val) = cache.get(&i) {
                assert_eq!(val, format!("Value_{}", i), "Data Corruption after eviction!");
                found += 1;
            }
        }

        // Ensure at least some recent items were kept
        assert!(found > 0, "All recently inserted items were lost");
    });
}

#[test]
fn test_strong_consistency_pressure() {
    run_with_timeout(Duration::from_secs(45), || {
        let config = Config::new_expert(8192, 1024, 1024, 60, 10);
        let cache = Arc::new(DualCacheFF::new(config));

        let shadow = Arc::new(Mutex::new(HashMap::new()));
        let mut handles = vec![];

        // 10 threads concurrently bashing overlapping keyspaces
        for t_id in 0..10 {
            let c = cache.clone();
            let shadow_clone = shadow.clone();
            
            let handle = thread::spawn(move || {
                for i in 0..1000 {
                    let key = (t_id * 1000) + i;
                    let val = (t_id * 10_000) + i;
                    
                    // Keep shadow state in sync
                    shadow_clone.lock().unwrap().insert(key, val);
                    // Insert 12 times to satisfy L1 Lossy Filter threshold (>= 10 hits)
                    for _ in 0..12 {
                        c.insert(key, val);
                    }
                    
                    // Some random deletes
                    if i % 10 == 0 {
                        shadow_clone.lock().unwrap().remove(&key);
                        c.remove(&key);
                    }
                }
            });
            handles.push(handle);
        }

        for h in handles {
            h.join().unwrap();
        }

        // Wait for daemon synchronization
        cache.sync();

        // Check strict consistency
        let final_shadow = shadow.lock().unwrap();
        let mut found = 0;
        for (k, expected_v) in final_shadow.iter() {
            if let Some(actual_v) = cache.get(k) {
                assert_eq!(
                    actual_v, *expected_v,
                    "Strong consistency failure! Key {} expected {}, got {}",
                    k, expected_v, actual_v
                );
                found += 1;
            }
        }
        assert!(found > 0, "Vacuous assertion: no items found after pressure");
    });
}

#[test]
fn test_async_boundary_conditions() {
    run_with_timeout(Duration::from_secs(10), || {
        let config = Config::new_expert(128, 64, 64, 60, 4);
        let cache = DualCacheFF::new(config);

        // Rapid burst: Insert x12 -> Delete -> Insert x12 different value -> Delete
        for _ in 0..12 { cache.insert(1, 100); }
        cache.remove(&1);
        for _ in 0..12 { cache.insert(1, 200); }
        cache.remove(&1);

        // Wait for batch to process
        cache.sync();
        
        // Final state should be empty
        assert_eq!(cache.get(&1), None, "Boundary error: Item should have been deleted");

        // Burst 2: fresh key (3) — Insert x12 to satisfy TLS probation, verify admission
        for _ in 0..12 { cache.insert(3, 99); }
        cache.sync();

        // Final state: key 3 should be present with value 99
        assert_eq!(cache.get(&3), Some(99), "Boundary error: Final insert was lost or overridden");
    });
}
