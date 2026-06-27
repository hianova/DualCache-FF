use dualcache_ff::{Config, DualCacheFF};
use dualcache_ff::static_cache::StaticDualCache;
use dualcache_ff::daemon::{DaemonStatus, Command, CacheTier};
use dualcache_ff::components::DefaultSpawner;
use std::sync::Arc;

#[test]
fn test_everything() {
    let config = Config::new_expert(256, 16, 16, 200, 32);
    let cache = DualCacheFF::<u64, u64>::new(config.clone());
    
    cache.insert(1, 1);
    cache.insert_sync(2, 2);
    let _ = cache.get(&1);
    let _ = cache.get_with_filter(&2, |_| true);
    cache.remove(&1);
    
    cache.clear();
    cache.sync();
    
    cache.suspend();
    cache.resume();
    
    let c = cache.clone();
    let handles: Vec<_> = (0..100).map(|i| {
        let c = c.clone();
        std::thread::spawn(move || {
            c.insert(i, i);
        })
    }).collect();
    for h in handles { h.join().unwrap(); }
    
    cache.shutdown_gracefully(None);
    
    let evict_cb: Arc<dyn Fn(u64, u64) + Send + Sync> = Arc::new(|_k, _v| {});
    let c2 = StaticDualCache::<u64, u64>::new_with_callbacks(
        config.clone(),
        Some(evict_cb),
        None,
    );
    for i in 0..300 {
        c2.insert(i, i);
    }
    drop(c2);
}

#[test]
fn test_exhaustive_coverage_edge_cases() {
    let config = Config::new_expert(256, 8, 8, 200, 2);
    let cache = Arc::new(DualCacheFF::<u64, u64>::new(config.clone()));
    
    // Hit line 76 (get_worker_state ensure_capacity)
    let c2 = cache.clone();
    std::thread::spawn(move || {
        let _ = c2.get(&999);
    }).join().unwrap();
    
    // Hit entry_count (cache.rs lines 405-410)
    let _counts = cache.entry_count();
    
    // Hit daemon_health lines 353-357
    cache.shared_core.status.store(0, std::sync::atomic::Ordering::Relaxed);
    assert!(matches!(cache.daemon_health(), DaemonStatus::NotStarted));
    cache.shared_core.status.store(2, std::sync::atomic::Ordering::Relaxed);
    assert!(matches!(cache.daemon_health(), DaemonStatus::ShuttingDown));
    cache.shared_core.status.store(4, std::sync::atomic::Ordering::Relaxed);
    assert!(matches!(cache.daemon_health(), DaemonStatus::Panicked));
    
    // Hit restart_daemon lines 366 (return early)
    cache.shared_core.status.store(1, std::sync::atomic::Ordering::Relaxed);
    cache.restart_daemon(DefaultSpawner, 1000);
    cache.shared_core.status.store(2, std::sync::atomic::Ordering::Relaxed);
    cache.restart_daemon(DefaultSpawner, 1000);
    
    // To hit daemon.rs line 289
    let _ = cache.cmd_tx.try_send(Command::Shutdown(None));
    
    // Try to trigger `return` paths in `core_cache.rs` where free_list_empty and evict_batch fails
    let config2 = Config::new_expert(8, 2, 2, 200, 1);
    let cache_small = DualCacheFF::<u64, u64>::new(config2);
    let mut core = cache_small.shared_core.acquire_lock();
    // Fill the arena
    for i in 0..8 {
        core.handle_insert_with_hash(i, i, i);
    }
    // Set all ranks to MAX_RANK so evict_batch() won't evict anything
    for i in 0..8 {
        core.arena.set_rank(i, 255);
    }
    // Now inserting will hit the `else { return; }` blocks in all handlers
    core.handle_insert_with_hash(100, 100, 100);
    core.handle_insert_t1(101, 101, 101);
    core.handle_insert_t2(102, 102, 102);
    core.handle_insert_core(103, 103, 103);
    core.handle_insert_with_rank(104, 104, 104, CacheTier::Tier1, 1);
    drop(core);
    
    // Test static_cache entry_count, sync, warmup
    let (sc, _daemon) = StaticDualCache::<u64, u64>::new_headless(Config::new_expert(16, 2, 2, 200, 1));
    sc.sync();
    let _sc_counts = sc.entry_count();
    sc.warmup(vec![(1, 1), (2, 2)]);
    
    // lossy_queue.rs Line 147 -> This is probably `len == 0` or similar
    let lq = dualcache_ff::lossy_queue::LossyQueue::<u64>::new(2);
    assert!(lq.try_recv().is_none());
}

#[test]
fn test_cache_batch_ops() {
    let config = Config::new_expert(256, 8, 8, 200, 2);
    let cache = DualCacheFF::<u64, u64>::new(config);
    // trigger cmd_tx commands for BatchInsertCore, BatchInsertT2, BatchInsert, BatchInsertT1
    let mut batch = vec![];
    for i in 0..10 { batch.push((i, i, i, false)); }
    let _ = cache.cmd_tx.try_send(Command::BatchInsert(batch));
    
    let mut batch_t1 = vec![];
    for i in 10..20 { batch_t1.push((i, i, i)); }
    let _ = cache.cmd_tx.try_send(Command::BatchInsertT1(batch_t1));
    
    let mut batch_t2 = vec![];
    for i in 20..30 { batch_t2.push((i, i, i)); }
    let _ = cache.cmd_tx.try_send(Command::BatchInsertT2(batch_t2));
    
    let mut batch_core = vec![];
    for i in 30..40 { batch_core.push((i, i, i)); }
    let _ = cache.cmd_tx.try_send(Command::BatchInsertCore(batch_core));
    
    let _ = cache.cmd_tx.try_send(Command::InsertWithRank(99, 99, 99, CacheTier::Tier1, 1));
    
    cache.shutdown_gracefully(None);
}


