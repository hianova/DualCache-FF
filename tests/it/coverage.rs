

use dualcache_ff::{Config, DualCacheFF};
use dualcache_ff::workers::{BatchBuf};
use dualcache_ff::lossy_queue::LossyQueue;
use std::thread;
use std::time::Duration;

use crate::common::run_with_timeout;

#[test]
fn test_batch_buf_overflow() {
    let mut buf = BatchBuf::<u64, u64>::new();
    let mut flush_count = 0;
    
    // Push 40 items
    for i in 0..40 {
        if buf.push((i, i, i, false)) {
            buf.drain_to_vec();
            flush_count += 1;
        }
    }
    
    assert_eq!(flush_count, 1, "Should flush on exactly the 32nd item");
    assert_eq!(buf.len(), 8);
    
    let items = buf.drain_to_vec();
    assert_eq!(items.len(), 8);
    assert_eq!(buf.len(), 0);
    assert!(buf.is_empty());
}

#[test]
fn test_lossy_queue_drop() {
    let q = LossyQueue::<u64>::new(4);
    
    assert!(q.try_send(1).is_ok());
    assert!(q.try_send(2).is_ok());
    assert!(q.try_send(3).is_ok());
    assert!(q.try_send(4).is_ok());
    
    // 5th item should be dropped
    let res = q.try_send(5);
    assert!(res.is_err(), "Queue should reject when full");
    
    assert_eq!(q.try_recv(), Some(1));
    assert_eq!(q.try_recv(), Some(2));
    assert_eq!(q.try_recv(), Some(3));
    assert_eq!(q.try_recv(), Some(4));
    assert_eq!(q.try_recv(), None);
}

#[test]
fn test_daemon_shutdown_during_active() {
    run_with_timeout(Duration::from_secs(5), || {
        let config = Config::new_expert(128, 64, 64, 200, 128);
        let (cache, daemon) = DualCacheFF::new_headless(config);
        
        // Spawn daemon
        let handle = thread::spawn(move || {
            daemon.run();
        });
        
        // Flood cache
        for i in 0..1000 {
            cache.insert(i, i);
        }
        
        // Immediately drop cache, forcing shutdown signal while queue might have items
        drop(cache);
        
        // Daemon should exit cleanly
        handle.join().unwrap();
    });
}

#[test]
fn test_record_hit_out_of_bounds() {
    run_with_timeout(Duration::from_secs(5), || {
        let config = Config::new_expert(128, 64, 64, 200, 128);
        let (cache, daemon) = DualCacheFF::<u64, u64>::new_headless(config);
        
        let handle = thread::spawn(move || {
            daemon.run();
        });
        
        // Bypass TLS and directly inject a hit batch with an out of bounds global index
        // Capacity is 128, so 9999 is definitely out of bounds
        let mut bad_batch = [usize::MAX; 64];
        bad_batch[0] = 9999;
        
        // This should not panic the daemon
        let _ = cache.hit_tx.try_send(bad_batch);
        
        cache.sync();
        drop(cache);
        handle.join().unwrap();
    });
}

#[test]
fn test_hash_collision_t1_t2() {
    run_with_timeout(Duration::from_secs(5), || {
        let config = Config::new_expert(128, 2, 2, 200, 128); // Tiny T1/T2 slots to force collisions
        let cache = DualCacheFF::new(config);
        
        // Insert multiple keys that will definitely collide in a 2-slot array
        for i in 0..10 {
            let session = cache.begin_cold_start_session();
            session.insert_t1(i, i);
        }
        
        cache.sync();
        
        // Hit them to promote to T1/T2
        for i in 0..10 {
            let _ = cache.get(&i);
        }
        
        cache.sync();
        
        cache.sync();
        
        // No crash means collisions are handled correctly
        
        // Now, keys 0-9 are in L3. Because T1 and T2 are tiny (size 2), 
        // most of these keys have been evicted from T1/T2 but remain in L3.
        // If we insert one of these keys again, it should trigger the bypass = true logic!
        cache.insert(5, 5); // Should hit L3 but not T1/T2, setting bypass = true
        cache.sync();
    });
}

#[test]
fn test_cold_start_session_pressure() {
    run_with_timeout(Duration::from_secs(5), || {
        let config = Config::new_expert(128, 64, 64, 200, 1024);
        let cache = DualCacheFF::new(config);
        
        // Fill cache past capacity (128) using ColdStartSession
        for i in 0..200 {
            let session = cache.begin_cold_start_session();
            session.insert_t1(i, i * 10);
        }
        
        cache.sync();
        
        // The cache should be completely full and protected by "God mode" (rank 255).
        // The later inserts will be dropped because eviction couldn't find a 0-rank item.
        let mut found = 0;
        for i in 0..50 {
            if cache.get(&i).is_some() {
                found += 1;
            }
        }
        assert!(found > 0, "The earliest inserted cold start items should be heavily protected and survive");
    });
}

#[test]
fn test_config_memory_budget() {
    let budget_mb = 10;
    let config = Config::with_memory_budget(budget_mb, 60);
    
    assert!(config.capacity > 10_000);
    assert_eq!(config.capacity.count_ones(), 1, "Capacity must be a power of two");
    assert_eq!(config.poll_us, 1000, "Default memory budget constructor should use 1000us");
}

#[test]
fn test_config_poll_clamping() {
    let config1 = Config::with_memory_budget(1, 0).with_poll_us(0);
    assert_eq!(config1.poll_us, 1_000, "Should clamp to min 1000us");
    
    let config2 = Config::with_memory_budget(1, 0).with_poll_us(20000);
    assert_eq!(config2.poll_us, 10_000, "Should clamp to max 10000us");
}
