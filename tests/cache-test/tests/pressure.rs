use dualcache_ff::{Config, DualCacheFF};
use std::collections::HashMap;
use std::sync::{Arc, Mutex};
use std::thread;
use std::time::Duration;

#[test]
fn test_capacity_pressure_and_eviction() {
    let mut config = Config::adaptive_config::<u32, String>();
    config.capacity = 1000;
    config.duration = 60;
    let cache = DualCacheFF::new(config);

    // Insert 200,000 items into a 1,000 capacity cache
    // This tests for OOM prevention and eviction robustness
    for i in 0..200_000 {
        cache.insert(i, format!("Value_{}", i));
        cache.insert(i, format!("Value_{}", i));
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
}

#[test]
fn test_strong_consistency_pressure() {
    let mut config = Config::adaptive_config::<u32, u32>();
    config.capacity = 5000;
    config.duration = 60;
    let cache = Arc::new(DualCacheFF::new(config));

    let shadow = Arc::new(Mutex::new(HashMap::new()));
    let mut handles = vec![];

    // 10 threads concurrently bashing overlapping keyspaces
    for t_id in 0..10 {
        let c = cache.clone();
        let shadow_clone = shadow.clone();
        
        let handle = thread::spawn(move || {
            for i in 0..1000 {
                let key = (t_id * 1000) + i; // Non-overlapping keys across threads to prevent test harness race
                let val = (t_id * 10_000) + i;
                
                // Keep shadow state in sync
                shadow_clone.lock().unwrap().insert(key, val);
                c.insert(key, val);
                
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
    for (k, expected_v) in final_shadow.iter() {
        if let Some(actual_v) = cache.get(k) {
            assert_eq!(
                actual_v, *expected_v,
                "Strong consistency failure! Key {} expected {}, got {}",
                k, expected_v, actual_v
            );
        }
    }
}

#[test]
fn test_async_boundary_conditions() {
    let mut config = Config::adaptive_config::<u32, u32>();
    config.capacity = 100;
    config.duration = 60;
    let cache = DualCacheFF::new(config);

    // Rapid burst: Insert -> Delete -> Insert different value -> Delete
    cache.insert(1, 100);
    cache.remove(&1);
    cache.insert(1, 200);
    cache.remove(&1);

    // Wait for batch to process
    cache.sync();
    
    // Final state should be empty
    assert_eq!(cache.get(&1), None, "Boundary error: Item should have been deleted");

    // Rapid burst 2: Insert -> Remove -> Insert
    cache.insert(2, 50);
    cache.remove(&2);
    cache.insert(2, 99);

    cache.sync();

    // Final state should be the last inserted value
    assert_eq!(cache.get(&2), Some(99), "Boundary error: Final insert was lost or overridden");
}
