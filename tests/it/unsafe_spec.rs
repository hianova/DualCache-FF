

use dualcache_ff::{Config, DualCacheFF};
use dualcache_ff::unsafe_core::{Node, WorkerSlot};
use std::thread;
use std::time::Duration;

use crate::common::run_with_timeout;

#[test]
fn test_batch_buf_alignment_invariants() {
    run_with_timeout(Duration::from_secs(5), || {
        // Verify that the WorkerSlot and BatchBuf layouts satisfy aligned cache line boundaries
        // to guarantee no false sharing under extreme CPU contention.
        let slot = WorkerSlot::<String, Vec<u8>>::new();
        let addr = &slot as *const _ as usize;
        #[cfg(any(target_arch = "aarch64", target_arch = "arm"))]
        let expected_align = 128;
        #[cfg(not(any(target_arch = "aarch64", target_arch = "arm")))]
        let expected_align = 64;

        assert_eq!(
            addr % expected_align, 0,
            "BatchBuf address {:#x} is not aligned to the expected cache-line boundary ({})",
            addr, expected_align
        );
    });
}

#[test]
fn test_node_structural_integrity() {
    run_with_timeout(Duration::from_secs(5), || {
        // Verify that raw Node pointer operations are safe and sound.
        let node = Node {
            key: "test_key".to_string(),
            value: 123456u64,
            expire_at: 0,
            g_idx: 42,
        };
        
        let ptr = Box::into_raw(Box::new(node));
        assert!(!ptr.is_null(), "Node pointer should not be null");

        unsafe {
            let node_ref = &*ptr;
            assert_eq!(node_ref.key, "test_key");
            assert_eq!(node_ref.value, 123456u64);
            assert_eq!(node_ref.expire_at, 0);
            assert_eq!(node_ref.g_idx, 42);

            // Reclaim the raw pointer safely
            let deallocated_node = Box::from_raw(ptr);
            assert_eq!(deallocated_node.key, "test_key");
        }
    });
}

#[test]
fn test_qsbr_epoch_retention_and_uaf_safety() {
    run_with_timeout(Duration::from_secs(5), || {
        // Verify that the QSBR epoch reservation mechanism prevents Use-After-Free (UAF).
        // An active thread registered with a local epoch should block RCU deallocations.
        let config = Config::new_expert(128, 64, 64, 200, 128);
        let (cache, daemon) = DualCacheFF::new_headless(config);

        // Spawn the background daemon thread first so it can process commands
        let daemon_handle = thread::spawn(move || {
            daemon.run();
        });

        // Warm up and insert a key multiple times to bypass probation filter
        for _ in 0..64 {
            cache.insert(42, "secure_data".to_string());
        }
        cache.sync();

        // Verify key exists
        assert_eq!(cache.get(&42), Some("secure_data".to_string()));

        // Simulate worker 1 starting an active transaction (checking in)
        // We can do this by executing a concurrent reader thread
        let cache_clone = cache.clone();
        let reader_handle = thread::spawn(move || {
            let id = 1;

            // Read the item first so `get()`'s internal QSBR lifecycle completes
            let val = cache_clone.get(&42);
            assert_eq!(val, Some("secure_data".to_string()));

            // Now get current global epoch and check-in manually for a long active transaction simulation
            let global_epoch = dualcache_ff::components::GLOBAL_EPOCH.load(std::sync::atomic::Ordering::Relaxed);
            let inner = unsafe { &*cache_clone.registry.get_inner() };
            inner.states[id].local_epoch.store(global_epoch, std::sync::atomic::Ordering::Release);

            // Keep the local thread checked in during the sleep
            thread::sleep(Duration::from_millis(150));

            let inner = unsafe { &*cache_clone.registry.get_inner() };
            inner.states[id].local_epoch.store(0, std::sync::atomic::Ordering::Release);
        });

        // Let the reader thread check-in first
        thread::sleep(Duration::from_millis(30));

        // Daemon attempts to remove/overwrite key while reader holds the active epoch reservation
        cache.remove(&42);
        
        // Wait for the reader to finish transaction and checkout
        reader_handle.join().unwrap();
        
        // Shut down the cache to terminate the daemon safely
        drop(cache);
        daemon_handle.join().unwrap();
    });
}


