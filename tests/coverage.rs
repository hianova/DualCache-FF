#![cfg(not(feature = "loom"))]

use dualcache_ff::{Config, DualCacheFF};
use dualcache_ff::unsafe_core::{BatchBuf};
use std::sync::atomic::Ordering;
use dualcache_ff::lossy_queue::{LossyQueue, OneshotAck};
use dualcache_ff::tls::TlsProvider;
use dualcache_ff::daemon::Command;
use std::sync::Arc;
use std::thread;
use std::time::Duration;

mod common;
use common::run_with_timeout;

#[test]
fn test_batch_buf_overflow() {
    let mut buf = BatchBuf::<u64, u64>::new();
    let mut flush_count = 0;
    
    // Push 32 items
    for i in 0..32 {
        if buf.push((i, i, i)) {
            flush_count += 1;
        }
    }
    
    assert_eq!(flush_count, 1, "Should flush on exactly the 32nd item");
    assert_eq!(buf.len(), 32);
    
    let items = buf.drain_to_vec();
    assert_eq!(items.len(), 32);
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
        let config = Config::new_expert(128, 64, 64, 200, 2);
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
        let config = Config::new_expert(128, 64, 64, 200, 2);
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
        let config = Config::new_expert(128, 2, 2, 200, 2); // Tiny T1/T2 slots to force collisions
        let cache = DualCacheFF::new(config);
        
        // Insert multiple keys that will definitely collide in a 2-slot array
        for i in 0..10 {
            let session = cache.begin_cold_start_session();
            session.warmup(i, i);
        }
        
        cache.sync();
        
        // Hit them to promote to T1/T2
        for i in 0..10 {
            let _ = cache.get(&i);
        }
        
        cache.sync();
        
        // No crash means collisions are handled correctly
    });
}

struct DummyTls {
    allow_read: std::sync::atomic::AtomicBool,
}
impl TlsProvider for DummyTls {
    fn get_worker_id(&self) -> Option<usize> {
        if self.allow_read.load(Ordering::Relaxed) { Some(0) } else { None }
    }
    fn with_hit_buf(&self, _f: &mut dyn FnMut(&mut ([usize; 64], usize))) {}
    fn with_l1_filter(&self, _f: &mut dyn FnMut(&mut ([u8; 4096], usize))) {}
    fn with_last_flush_tick(&self, _f: &mut dyn FnMut(&mut u64)) {}
}

#[test]
fn test_no_std_tls_fallback() {
    run_with_timeout(Duration::from_secs(5), || {
        let config = Config::new_expert(128, 64, 64, 200, 2);
        let tls = DummyTls { allow_read: std::sync::atomic::AtomicBool::new(false) };
        let (cache, daemon) = DualCacheFF::<u64, u64, ahash::RandomState, DummyTls>::new_headless_with_tls(config, tls);
        
        let handle = thread::spawn(move || {
            daemon.run();
        });
        
        // This will bypass TLS and send directly to cmd_tx
        cache.insert(1, 100);
        cache.sync();
        
        // Allow read to get an epoch checkout in std mode
        cache.tls.allow_read.store(true, Ordering::Relaxed);
        
        // Get should find the item
        assert_eq!(cache.get(&1), Some(100));
        cache.sync();
        
        drop(cache);
        handle.join().unwrap();
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
            session.warmup(i, i * 10);
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
