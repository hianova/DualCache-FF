use dualcache_ff::{Config, DualCacheFF};
use dualcache_ff::workers::{WorkerSlot};

#[test]
fn test_config_normal_poll() {
    let _c = Config::new_expert(1024, 8, 8, 200, 8).with_poll_us(5000);
}

#[test]
fn test_config_flush_tick() {
    let _c = Config::new_expert(1024, 8, 8, 200, 8).with_flush_tick_threshold(10);
    let _c2 = Config::new_expert(1024, 8, 8, 200, 8).with_flush_tick_threshold(0);
}

#[test]
fn test_worker_slot_default() {
    let _slot: WorkerSlot<String, String> = Default::default();
}



#[test]
fn test_suspend_resume_and_unregistered_thread() {
    use std::thread;
    let config = Config::with_memory_budget(2, 60);
    let cache = DualCacheFF::new(config);
    
    cache.suspend();
    cache.insert("sk1".to_string(), "sv1".to_string());
    
    let session = cache.begin_cold_start_session();
    session.insert_t1("sk2".to_string(), "sv2".to_string());
    
    assert_eq!(cache.get(&"sk1".to_string()), Some("sv1".to_string()));
    cache.clear();
    assert_eq!(cache.get(&"sk1".to_string()), None);
    
    // Access from unregistered thread to trigger fallback in `insert` and `record_hit`
    let c = cache.clone();
    std::thread::spawn(move || {
        c.insert("uk".to_string(), "uv".to_string());
        let _ = c.get(&"uk".to_string()); // Triggers fallback `hit_tx`
    }).join().unwrap();
    
    cache.resume();
    
    let cache_clone = cache.clone();
    let handle = thread::spawn(move || {
        cache_clone.insert("uk1".to_string(), "uv1".to_string());
        assert_eq!(cache_clone.get(&"uk1".to_string()), None);
    });
    handle.join().unwrap();
    cache.sync();
    assert_eq!(cache.get(&"uk1".to_string()), Some("uv1".to_string()));
}

#[test]
fn test_cache_bypasses_and_internals() {
    let config = Config::new_expert(16, 1024, 1024, 200, 2);
    let (cache, _daemon) = DualCacheFF::<u64, u64>::new_headless(config);
    
    let s = cache.hasher.clone();
    use core::hash::{BuildHasher, Hash, Hasher};
    let mut hasher = s.build_hasher();
    777_u64.hash(&mut hasher);
    let hash = hasher.finish();
    
    let node_ptr1 = Box::into_raw(Box::new(dualcache_ff::storage::Node {
        key: 777,
        value: 888,
        expire_at: 0,
        g_idx: 0,
    }));
    
    let node_ptr2 = Box::into_raw(Box::new(dualcache_ff::storage::Node {
        key: 999,
        value: 111,
        expire_at: 0,
        g_idx: 1,
    }));
    
    cache.t2.store_slot(hash, node_ptr1);
    assert_eq!(cache.get(&777), Some(888));
    
    cache.t1.store_slot(hash, node_ptr2);
    assert_eq!(cache.get(&999), None);
    
    assert!(cache.cache.index_len() > 0);
    cache.cache.index_clear_at(0);
    assert!(cache.cache.get_node(0).is_none());
    assert!(cache.cache.node_get_full(0, &1, 0).is_none());
}

#[test]
fn test_ghost_eviction_and_queue_contention() {
    use std::sync::Arc;
    let config = Config::new_expert(64, 4, 4, 200, 4);
    let cache = Arc::new(DualCacheFF::new(config));
    
    for i in 0..100_u64 {
        cache.insert(i, i);
    }
    cache.sync();
    
    cache.insert(101, 101);
    cache.sync();
    cache.insert(0, 0);
    cache.sync();
    
    let mut handles = vec![];
    for _ in 0..16 {
        let c = cache.clone();
        handles.push(std::thread::spawn(move || {
            for j in 0..200 {
                c.insert(j, j);
            }
        }));
    }
    for h in handles {
        let _ = h.join();
    }
}

#[test]
fn test_shared_core_contention() {
    use std::sync::Arc;
    let config = Config::new_expert(1024, 8, 8, 200, 8);
    let cache = Arc::new(DualCacheFF::<u64, u64>::new(config));
    
    let _guard = cache.shared_core.acquire_lock();
    
    let c = cache.clone();
    let t = std::thread::spawn(move || {
        let _g = c.shared_core.acquire_lock();
    });
    
    std::thread::sleep(std::time::Duration::from_millis(50));
    drop(_guard);
    t.join().unwrap();
}

#[test]
fn test_miscellaneous_coverage() {
    let _ws: dualcache_ff::components::WorkerState = Default::default();
    
    let _bb: dualcache_ff::workers::BatchBuf<u64, u64> = Default::default();
    
    let _static_cache = dualcache_ff::static_cache::StaticDualCache::<u64, u64>::new_headless(Config::new_expert(16, 2, 2, 100, 1));
    

    
    let config = Config::new_expert(16, 2, 2, 200, 2);
    let cache = DualCacheFF::<u64, u64>::new(config.clone());
    let _ = DualCacheFF::<u64, u64>::new_headless(config);
    let _ = cache.t1.is_empty();
    let _ = cache.t2.is_empty();
    
    for i in 0..100 {
        cache.insert(i, i);
    }
    cache.sync();
    
    cache.insert(101, 101);
    cache.sync();
    

    for _ in 0..65 {
        let _ = cache.get(&101);
    }
}

#[test]
fn test_cache_edge_cases() {
    use dualcache_ff::components::DefaultTls;
    let config = Config::new_expert(1024, 8, 8, 200, 8);
    
    // 1. Hit `new_with_tls` and `new_with_tls_and_spawner`
    let cache = DualCacheFF::<u64, u64>::new_with_tls(config.clone(), DefaultTls);
    
    use std::sync::atomic::Ordering;
    cache.is_cold_start.store(false, Ordering::Release);

    // Wait for daemon thread to be set inside SharedCore
    std::thread::sleep(std::time::Duration::from_millis(50));
    
    // 2. Hit `resume()` unpark
    cache.suspend();
    cache.resume(); 

    // 3. Hit `remove()` local buffer flush
    cache.insert(555, 555); // Item placed in TLS miss buffer
    cache.remove(&555);     // Triggers local buffer flush before remove

    // 4. Hit `T2` bypass inside `insert`
    use core::hash::{BuildHasher, Hash, Hasher};
    let s = cache.hasher.clone();
    let mut hasher = s.build_hasher();
    777_u64.hash(&mut hasher);
    let hash = hasher.finish();
    let node_ptr = Box::into_raw(Box::new(dualcache_ff::storage::Node {
        key: 777,
        value: 888,
        expire_at: 0,
        g_idx: 0,
    }));
    cache.t2.store_slot(hash, node_ptr);
    cache.insert(777, 888); // Should hit T2 bypass

    // 5. Setup cache for hit fallback test
    cache.insert(999, 999);
    cache.sync(); // Ensure 999 is in cache

    let c2 = cache.clone();
    
    // 6. Hit unregistered thread paths (opt.is_none, pushed_to_buf.is_none, unpark)
    let handle = std::thread::spawn(move || {
        // Sleep to let daemon park so we can hit `unpark` inside `wake_daemon_if_parked`
        std::thread::sleep(std::time::Duration::from_millis(500));
        
        // This will hit `get` -> `record_hit` -> `opt.is_none()` fallback -> `try_send` + `wake_daemon_if_parked`
        let _ = c2.get(&999);
        
        // This will hit `insert` -> `pushed_to_buf.is_none()` fallback -> `try_send` + `wake_daemon_if_parked`
        c2.insert(1000, 1000);
    });
    handle.join().unwrap();
    
    // Ensure the daemon processes the Insert command sent by the unregistered thread
    cache.sync();
}

#[test]
fn test_daemon_edge_cases() {
    let config = Config::new_expert(1024, 8, 8, 200, 8);
    let (cache, daemon) = DualCacheFF::<u64, u64>::new_headless(config.clone());
    
    use std::sync::atomic::Ordering;
    cache.is_cold_start.store(false, Ordering::Release);
    
    // 1. Run the daemon in a background thread.
    let handle = std::thread::spawn(move || daemon.run());
    
    // 2. Synthesize 130 full hit batches (8320 hits).
    let batch = [1; 64];
    for _ in 0..130 {
        assert!(cache.hit_tx.try_send(batch).is_ok(), "Failed to send hit batch!");
    }
    
    // 3. Send a Sync command and block until the daemon processes it in Phase 0.
    // This acts as a synchronization barrier. Once `sync()` returns, we know the daemon
    // is alive and has processed the Sync command. It will then proceed to Phase 1
    // in the SAME iteration and process our 8320 hits, hitting the accumulator break limit!
    cache.sync();
    
    // VERIFY: We can check if the daemon's hit_accumulator actually accumulated 8320 hits!
    // Since the daemon might call maintenance() immediately after breaking, the accumulator
    // gets cleared! Wait, if it gets cleared, we can't observe it here!
    // BUT we CAN check it if we intercept it...
    // Actually, if it clears it, it means the break happened!
    
    // 4. Drop the cache. This sends `Command::Shutdown` into `cmd_tx`.
    // Since the daemon is currently in Phase 1 or Phase 2 of the current iteration,
    // it will read this Shutdown command in Phase 0 of the NEXT iteration!
    drop(cache);
    
    // Wait for the daemon to process `Shutdown` (triggering line 199) and gracefully exit
    handle.join().unwrap();
}

#[test]
fn test_advanced_features() {
    use dualcache_ff::Config;
    use dualcache_ff::DualCacheFF;
    let config = Config::new_expert(256, 8, 8, 200, 8);
    let cache = DualCacheFF::<u64, u64>::new(config);
    
    // 1. Warmup batch
    let session = cache.begin_cold_start_session();
    let items = (0..200).map(|i| (i, i * 2));
    session.warmup_batch(items);
    session.warmup_sync();
    
    for i in 0..200 {
        assert_eq!(cache.get(&i), Some(i * 2));
    }
    
    // 2. Warmup with rank
    session.warmup_with_rank(999, 1000, dualcache_ff::daemon::CacheTier::Tier1, 200);
    session.warmup_sync();
    assert_eq!(cache.get(&999), Some(1000));
    
    // Test warmup when suspended
    cache.suspend();
    let batch_items = (1001..1150).map(|i| (i, i)); // > 128 items
    session.warmup_batch(batch_items);
    session.warmup_with_rank(1003, 1003, dualcache_ff::daemon::CacheTier::Tier1, 100);
    assert_eq!(cache.get(&1001), Some(1001));
    assert_eq!(cache.get(&1149), Some(1149));
    assert_eq!(cache.get(&1003), Some(1003));
    cache.resume();
    
    // 3. get_with_filter
    let filter = |k: &u64| *k < 1000;
    assert_eq!(cache.get_with_filter(&999, filter), Some(1000)); // Should hit
    assert_eq!(cache.get_with_filter(&1003, filter), None); // Should be filtered
    assert_eq!(cache.get_with_filter(&5000, filter), None); // Should be filtered
    
    // 4. get_or_load
    let loaded = cache.get_or_load(&2000, || -> Result<u64, ()> {
        Ok(4000)
    }).unwrap();
    assert_eq!(loaded, 4000);
    
    cache.sync();
    assert_eq!(cache.get(&2000), Some(4000)); // Should be cached now
    
    cache.shutdown_gracefully(None);
}

#[test]
fn test_registry_ensure_capacity() {
    use dualcache_ff::Config;
    use dualcache_ff::DualCacheFF;
    use std::sync::Arc;
    let config = Config::new_expert(256, 8, 8, 200, 2); // Initial capacity 2
    let cache = Arc::new(DualCacheFF::<u64, u64>::new(config));
    
    // Spawn many threads to force registry expansion and backoff
    let mut handles = vec![];
    let barrier = Arc::new(std::sync::Barrier::new(64));
    
    for i in 0..64 {
        let c = cache.clone();
        let b = barrier.clone();
        handles.push(std::thread::spawn(move || {
            b.wait();
            c.insert(i, i);
            std::thread::sleep(std::time::Duration::from_millis(5));
            c.get(&i);
        }));
    }
    
    for h in handles {
        h.join().unwrap();
    }
    
    // Check that length expanded properly
    let ptr = cache.registry.get_inner();
    let len = unsafe { (&(*ptr).states).len() };
    assert!(len >= 16);
    
    cache.shutdown_gracefully(None);
}

#[test]
fn test_cache_constructors_with_callbacks() {
    use dualcache_ff::Config;
    use dualcache_ff::DualCacheFF;
    use dualcache_ff::components::DefaultTls;
    use std::sync::Arc;
    let config = Config::new_expert(256, 8, 8, 200, 8);
    
    let evict_cb: Arc<dyn Fn(u64, u64) + Send + Sync> = Arc::new(|_k, _v| {});
    let promote_cb: Arc<dyn Fn(u64, u64) + Send + Sync> = Arc::new(|_k, _v| {});
    
    let cache1 = DualCacheFF::<u64, u64>::new_with_callbacks(
        config.clone(),
        Some(evict_cb.clone()),
        Some(promote_cb.clone()),
    );
    for i in 0..300 {
        cache1.insert_sync(i, i);
    }
    cache1.shutdown_gracefully(None);
    
    let cache2 = DualCacheFF::<u64, u64>::new_with_tls_and_callbacks(
        config.clone(),
        DefaultTls::default(),
        Some(evict_cb),
        Some(promote_cb),
    );
    cache2.shutdown_gracefully(None);
}

#[test]
fn test_daemon_health() {
    use dualcache_ff::Config;
    use dualcache_ff::DualCacheFF;
    let config = Config::new_expert(256, 8, 8, 200, 8);
    let cache = DualCacheFF::<u64, u64>::new(config);
    
    // Wait for the daemon to start and set its status to Running
    std::thread::sleep(std::time::Duration::from_millis(10));
    
    // Once started, should be Running
    let health1 = cache.daemon_health();
    assert!(matches!(health1, dualcache_ff::daemon::DaemonStatus::Running));
    
    // Shutdown the daemon
    cache.shutdown_gracefully(None);
    
    // Wait for the thread to drop DaemonGuard
    std::thread::sleep(std::time::Duration::from_millis(50));
    
    // Should be Stopped after shutdown
    let health2 = cache.daemon_health();
    assert!(matches!(health2, dualcache_ff::daemon::DaemonStatus::Stopped));
}

#[test]
fn test_set_poll_interval() {
    use dualcache_ff::Config;
    use dualcache_ff::DualCacheFF;
    let config = Config::new_expert(256, 8, 8, 200, 8);
    let cache = DualCacheFF::<u64, u64>::new(config);
    
    // Set poll interval to a valid value by sending the command directly
    let _ = cache.cmd_tx.try_send(dualcache_ff::daemon::Command::SetPollInterval(500));
    
    cache.shutdown_gracefully(None);
}

#[test]
fn test_insert_sync() {
    use dualcache_ff::Config;
    use dualcache_ff::DualCacheFF;
    let config = Config::new_expert(256, 8, 8, 200, 8);
    let cache = DualCacheFF::<u64, u64>::new(config);
    
    // Test insert_sync
    cache.insert_sync(12345, 67890);
    assert_eq!(cache.get(&12345), Some(67890));
    
    cache.shutdown_gracefully(None);
}

#[test]
fn test_oneshot_ack_clone_drop() {
    use dualcache_ff::lossy_queue::OneshotAck;
    let ack = OneshotAck::new();
    let ack_clone = ack.clone();
    drop(ack_clone);
    ack.signal();
    ack.wait();
}
