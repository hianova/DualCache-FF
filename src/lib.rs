#![cfg_attr(not(any(feature = "std", feature = "daemon", test, loom)), no_std)]

extern crate alloc;

pub mod sync;
pub mod core;
pub mod tls;

#[cfg(feature = "std")]
pub mod daemon;

use crate::core::BottomUpCache;
use crate::sync::arc::Arc;
use crate::sync::atomic::{AtomicBool, Ordering};
use crate::tls::{TlsRegistry, TlsHandle};

#[cfg(feature = "std")]
use crate::daemon::{Daemon, DaemonMessage};
#[cfg(feature = "std")]
use crossbeam_channel::{bounded, Sender};

/// DualCacheFf is the global API entry point.
pub struct DualCacheFf<K, V, P, const CAP2: usize, const CAP1: usize, const CAP0: usize, const TOTAL_CAP: usize> 
where 
    P: crate::core::config::CachePolicy + Send + Sync,
{
    core: Arc<crate::core::DualCacheCore<K, V, P, CAP2, CAP1, CAP0, TOTAL_CAP>>,
    daemon_mode: AtomicBool,
    tls_registry: TlsRegistry<K, V>,
    #[cfg(feature = "std")]
    global_tx: Option<Sender<DaemonMessage<K, V>>>,
}

impl<K, V, P, const CAP2: usize, const CAP1: usize, const CAP0: usize, const TOTAL_CAP: usize> DualCacheFf<K, V, P, CAP2, CAP1, CAP0, TOTAL_CAP> 
where 
    K: Clone + Eq + ::core::hash::Hash + Send + Sync + 'static,
    V: Clone + Send + Sync + 'static,
    P: crate::core::config::CachePolicy + Send + Sync + 'static,
{
    pub fn new(max_threads: usize, local_cache_size: usize) -> Self {
        Self {
            core: Arc::new(crate::core::DualCacheCore::new()),
            daemon_mode: AtomicBool::new(false),
            tls_registry: TlsRegistry::<K, V>::new(max_threads, local_cache_size),
            #[cfg(feature = "std")]
            global_tx: None,
        }
    }

    /// Turn the Daemon on or off. 
    /// If turned on, a new daemon thread is automatically spawned and channel is established.
    #[cfg(feature = "std")]
    pub fn set_daemon_mode(&mut self, on: bool) {
        self.daemon_mode.store(on, Ordering::SeqCst);
        
        if on {
            let (tx, rx) = crossbeam_channel::unbounded();
            let mut broadcast_txs = alloc::vec::Vec::with_capacity(self.tls_registry.max_threads());
            
            for i in 0..self.tls_registry.max_threads() {
                let dummy_handle = TlsHandle { id: i, qsbr_node: ::core::ptr::null_mut() };
                let block = self.tls_registry.get_block_mut(&dummy_handle);
                block.tx = Some(tx.clone());
                
                let (hit_tx, hit_rx) = crossbeam_channel::bounded::<(usize, u8)>(1024);
                block.hit_rx = Some(hit_rx);
                broadcast_txs.push(hit_tx);
            }

            let daemon_node = crate::core::qsbr::register_thread();
            let _daemon = crate::daemon::Daemon::spawn(self.core.clone(), rx, broadcast_txs, daemon_node);
            self.global_tx = Some(tx.clone());
        } else {
            self.global_tx = None;
            for i in 0..self.tls_registry.max_threads() {
                let dummy_handle = TlsHandle { id: i, qsbr_node: ::core::ptr::null_mut() };
                let block = self.tls_registry.get_block_mut(&dummy_handle);
                block.tx = None;
                block.hit_rx = None;
            }
        }
    }

    /// Register the current thread to get a fast TLS handle.
    pub fn register_thread(&self) -> TlsHandle {
        let handle = self.tls_registry.register_thread();
        
        #[cfg(feature = "std")]
        if let Some(ref global_tx) = self.global_tx {
            let block = self.tls_registry.get_block_mut(&handle);
            block.tx = Some(global_tx.clone());
        }
        
        handle
    }

    pub fn get(&self, key: &K, handle: &TlsHandle) -> Option<V> {
        let block: &mut crate::tls::TlsBlock<K, V> = self.tls_registry.get_block_mut(handle);
        
        // Drain broadcasts periodically (every 64 ops) to reduce channel contention overhead
        block.op_count = block.op_count.wrapping_add(1);
        #[cfg(feature = "std")]
        if block.op_count % 64 == 0 {
            if let Some(ref hit_rx) = block.hit_rx {
                while let Ok((msg_hash, weight)) = hit_rx.try_recv() {
                    block.cache.record_remote_hit(msg_hash, weight);
                }
            }
        }

        let hash = self.core.hash_key(key);
        
        // 1. Check TLS cache (L1)
        let (val_opt, promote, sync) = block.cache.get(hash, key);
        
        #[cfg(feature = "std")]
        if promote {
            if let Some(val) = val_opt {
                if let Some(ref tx) = block.tx {
                    let _ = tx.try_send(crate::daemon::DaemonMessage::Promote(hash, key.clone(), val.clone()));
                } else {
                    self.core.put(key.clone(), val.clone(), handle.qsbr_node);
                }
            }
        } else if sync {
            if let Some(ref tx) = block.tx {
                block.hit_batch[block.hit_batch_len as usize] = (hash, 1);
                block.hit_batch_len += 1;
                if block.hit_batch_len == 32 {
                    let _ = tx.try_send(crate::daemon::DaemonMessage::HitBatch(block.hit_batch, 32));
                    block.hit_batch_len = 0;
                }
            }
        }
        
        #[cfg(not(feature = "std"))]
        if promote {
            if let Some(val) = val_opt {
                self.core.put(key.clone(), val.clone(), handle.qsbr_node);
                self.core.try_reclaim(handle.qsbr_node);
            }
        }

        if let Some(val) = val_opt {
            return Some(val.clone());
        }

        // 2. Check Wait-Free Core (L2)
        let guard = crate::core::qsbr::pin(handle.qsbr_node);
        if let Some(val) = self.core.get(key, &guard) {
            let cloned_val = val.clone();
            block.cache.put(hash, key.clone(), cloned_val.clone());
            return Some(cloned_val);
        }

        None
    }

    /// Explicitly put a value into the TLS cache (L1).
    /// The value will be promoted to the Core (L2) later when it reaches the promote_threshold.
    pub fn put(&self, key: K, value: V, handle: &TlsHandle) {
        let block = self.tls_registry.get_block_mut(handle);
        
        block.op_count = block.op_count.wrapping_add(1);
        #[cfg(feature = "std")]
        if block.op_count % 64 == 0 {
            if let Some(ref hit_rx) = block.hit_rx {
                while let Ok((msg_hash, weight)) = hit_rx.try_recv() {
                    block.cache.record_remote_hit(msg_hash, weight);
                }
            }
        }

        let hash = self.core.hash_key(&key);
        block.cache.put(hash, key, value);
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::thread;

    #[test]
    fn test_daemon_off_sync() {
        let cache: DualCacheFf<u64, u64, crate::core::config::DefaultExponentialPolicy, 4, 16, 64, 84> = DualCacheFf::new(10, 16);
        let handle = cache.register_thread();

        // Put twice to pass admission filter
        cache.put(1, 100, &handle);
        cache.put(1, 100, &handle);
        assert_eq!(cache.get(&1, &handle), Some(100));
        
        // Put twice, verify isolation
        cache.put(2, 200, &handle);
        cache.put(2, 200, &handle);
        assert_eq!(cache.get(&2, &handle), Some(200));
    }

    #[cfg(feature = "std")]
    #[test]
    fn test_daemon_on_async() {
        use std::time::Duration;
        
        let mut cache: DualCacheFf<u64, u64, crate::core::config::DefaultExponentialPolicy, 4, 16, 64, 84> = DualCacheFf::new(10, 16);
        
        // Turn ON Daemon (automatically spawns daemon)
        cache.set_daemon_mode(true);
        
        let handle = cache.register_thread();

        // Put twice to pass admission filter
        cache.put(10, 1000, &handle);
        cache.put(10, 1000, &handle);
        
        // Get multiple times to reach promote threshold
        for _ in 0..5 {
            let _ = cache.get(&10, &handle);
        }
        
        // Wait a bit for daemon to process the promote message
        thread::sleep(Duration::from_millis(50));
        
        // The value should be retrievable
        assert_eq!(cache.get(&10, &handle), Some(1000));
    }

    #[cfg(feature = "std")]
    #[test]
    fn test_extensive_coverage() {
        use std::time::Duration;
        
        let mut cache: DualCacheFf<u64, u64, crate::core::config::DefaultExponentialPolicy, 4, 16, 64, 84> = DualCacheFf::new(10, 2);
        let handle = cache.register_thread();

        // Sync mode: insert many items to trigger evictions
        for i in 0..100 {
            cache.put(i, i * 10, &handle);
            cache.put(i, i * 10, &handle); // Admitted
            cache.get(&i, &handle);
        }

        // Hit item 10 many times to promote it through T2 -> T1 -> T0
        for _ in 0..300 {
            cache.get(&10, &handle);
        }

        // Turn on Daemon
        cache.set_daemon_mode(true);

        // Async mode: insert many items
        for i in 100..200 {
            cache.put(i, i * 10, &handle);
            cache.put(i, i * 10, &handle); // Admitted
            // Get multiple times to trigger promote messages
            for _ in 0..5 {
                cache.get(&i, &handle);
            }
        }

        let handle2 = cache.register_thread();
        for i in 100..200 {
            // handle2 TLS is empty, so it will hit core.get
            cache.get(&i, &handle2);
        }

        // Hit item 100 many times via handle2 to promote it through T2 -> T1 -> T0 in the core
        for _ in 0..300 {
            cache.get(&100, &handle2);
        }

        // Test over-capacity registration panic
        for _ in 1..9 {
            let _ = cache.register_thread();
        }
        let safe_cache = std::panic::AssertUnwindSafe(&cache);
        let res = std::panic::catch_unwind(move || {
            let _ = safe_cache.register_thread(); // Should panic
        });
        assert!(res.is_err());

        // Send a Promote message to Daemon directly
        if let Some(tx) = cache.global_tx.clone() {
            let _ = tx.send(crate::daemon::DaemonMessage::Promote(123, 123, 123));
        }

        // Wait for daemon to process
        thread::sleep(Duration::from_millis(50));

        // Turn off daemon
        cache.set_daemon_mode(false);
        
        // Wait for daemon to die
        thread::sleep(Duration::from_millis(50));
        
        // Explicitly reclaim to hit coverage
        cache.core.try_reclaim(handle.qsbr_node);
        cache.core.try_reclaim(handle.qsbr_node);
    }
}

