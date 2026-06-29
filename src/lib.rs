#![cfg_attr(not(any(feature = "std", feature = "daemon", test, loom)), no_std)]

extern crate alloc;

pub mod sync;
pub mod core;
pub mod tls;

#[cfg(feature = "std")]
pub mod daemon;

use crate::sync::arc::Arc;
use crate::sync::atomic::{AtomicBool, Ordering};
use crate::tls::{TlsRegistry, TlsHandle};

#[cfg(feature = "std")]
use crate::daemon::DaemonMessage;
#[cfg(feature = "std")]
use crossbeam_channel::Sender;

/// DualCacheFF is the global API entry point.
pub struct DualCacheFF<
    K, 
    V, 
    P, 
    const CAP2: usize, 
    const CAP1: usize, 
    const CAP0: usize, 
    const TOTAL_CAP: usize,
    const MAX_THREADS: usize,
    const TLS_CAP: usize,
    const TLS_INDEX_CAP: usize,
> 
where 
    P: crate::core::config::CachePolicy + Send + Sync,
{
    core: crate::core::DualCacheCore<K, V, P, CAP2, CAP1, CAP0, TOTAL_CAP>,
    daemon_mode: AtomicBool,
    tls_registry: TlsRegistry<K, V, MAX_THREADS, TLS_CAP, TLS_INDEX_CAP>,
    #[cfg(feature = "std")]
    global_tx: std::sync::RwLock<Option<Sender<DaemonMessage<K, V>>>>,
}

impl<
    K, 
    V, 
    P, 
    const CAP2: usize, 
    const CAP1: usize, 
    const CAP0: usize, 
    const TOTAL_CAP: usize,
    const MAX_THREADS: usize,
    const TLS_CAP: usize,
    const TLS_INDEX_CAP: usize,
> DualCacheFF<K, V, P, CAP2, CAP1, CAP0, TOTAL_CAP, MAX_THREADS, TLS_CAP, TLS_INDEX_CAP> 
where 
    K: Clone + Eq + ::core::hash::Hash + Send + Sync + 'static,
    V: Clone + Send + Sync + 'static,
    P: crate::core::config::CachePolicy + Send + Sync + 'static,
{
    pub const fn new() -> Self {
        Self {
            core: crate::core::DualCacheCore::new(),
            daemon_mode: AtomicBool::new(false),
            tls_registry: TlsRegistry::new(),
            #[cfg(feature = "std")]
            global_tx: std::sync::RwLock::new(None),
        }
    }

    /// Turn the Daemon on or off. 
    /// If turned on, a new daemon thread is automatically spawned and channel is established.
    #[cfg(feature = "std")]
    pub fn set_daemon_mode(&'static self, on: bool) {
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

            let daemon_node = {
                let node = std::boxed::Box::into_raw(std::boxed::Box::new(crate::core::qsbr::ThreadStateNode::new()));
                crate::core::qsbr::register_node(node);
                node
            };
            let _daemon = crate::daemon::Daemon::spawn(&self.core, rx, broadcast_txs, daemon_node);
            if let Ok(mut gtx) = self.global_tx.write() {
                *gtx = Some(tx.clone());
            }
        } else {
            if let Ok(mut gtx) = self.global_tx.write() {
                *gtx = None;
            }
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
        if let Ok(gtx) = self.global_tx.read() {
            if let Some(ref global_tx) = *gtx {
                let block = self.tls_registry.get_block_mut(&handle);
                block.tx = Some(global_tx.clone());
            }
        }
        
        handle
    }

    pub fn get(&self, key: &K, handle: &TlsHandle) -> Option<V> {
        let block: &mut crate::tls::TlsBlock<K, V, TLS_CAP, TLS_INDEX_CAP> = self.tls_registry.get_block_mut(handle);
        
        block.op_count = block.op_count.wrapping_add(1);
        if block.op_count.is_multiple_of(64) {
            self.core.try_reclaim(handle.qsbr_node);
        }

        let _hash = self.core.hash_key(key);
        let guard = crate::core::qsbr::pin(handle.qsbr_node);
        if let Some((val, _tier)) = self.core.get(key, &guard) {
            return Some(val.clone());
        }
        None
    }

    /// Insert a new value into the fast thread-local cache.
    /// The value will be promoted to the Core (L2) later when it reaches the promote_threshold.
    pub fn insert(&self, key: K, value: V, handle: &TlsHandle) {
        let block = self.tls_registry.get_block_mut(handle);
        block.op_count = block.op_count.wrapping_add(1);
        if block.op_count.is_multiple_of(64) {
            self.core.try_reclaim(handle.qsbr_node);
        }

        self.core.put(key, value, handle.qsbr_node);
    }
}

unsafe impl<
    K, 
    V, 
    P, 
    const CAP2: usize, 
    const CAP1: usize, 
    const CAP0: usize, 
    const TOTAL_CAP: usize,
    const MAX_THREADS: usize,
    const TLS_CAP: usize,
    const TLS_INDEX_CAP: usize,
> Send for DualCacheFF<K, V, P, CAP2, CAP1, CAP0, TOTAL_CAP, MAX_THREADS, TLS_CAP, TLS_INDEX_CAP> 
where 
    P: crate::core::config::CachePolicy + Send + Sync,
{}

unsafe impl<
    K, 
    V, 
    P, 
    const CAP2: usize, 
    const CAP1: usize, 
    const CAP0: usize, 
    const TOTAL_CAP: usize,
    const MAX_THREADS: usize,
    const TLS_CAP: usize,
    const TLS_INDEX_CAP: usize,
> Sync for DualCacheFF<K, V, P, CAP2, CAP1, CAP0, TOTAL_CAP, MAX_THREADS, TLS_CAP, TLS_INDEX_CAP> 
where 
    P: crate::core::config::CachePolicy + Send + Sync,
{}

#[cfg(test)]
mod tests {
    use super::*;
    use std::thread;

    #[test]
    fn test_static_global_cache() {
        static GLOBAL_CACHE: DualCacheFF<u64, u64, crate::core::config::DefaultExponentialPolicy, 256, 1024, 2048, 4096, 10, 256, 512> = DualCacheFF::new();
        let handle = GLOBAL_CACHE.register_thread();
        GLOBAL_CACHE.insert(1, 100, &handle);
        GLOBAL_CACHE.insert(1, 100, &handle);
        assert_eq!(GLOBAL_CACHE.get(&1, &handle), Some(100));
    }

    #[test]
    fn test_daemon_off_sync() {
        static CACHE: DualCacheFF<u64, u64, crate::core::config::DefaultExponentialPolicy, 256, 1024, 2048, 4096, 10, 256, 512> = DualCacheFF::new();
        let handle = CACHE.register_thread();

        // Put twice to pass admission filter
        CACHE.insert(1, 100, &handle);
        CACHE.insert(1, 100, &handle);
        assert_eq!(CACHE.get(&1, &handle), Some(100));
        
        // Put twice, verify isolation
        CACHE.insert(2, 200, &handle);
        CACHE.insert(2, 200, &handle);
        assert_eq!(CACHE.get(&2, &handle), Some(200));
    }

    #[cfg(feature = "std")]
    #[test]
    fn test_daemon_on_async() {
        use std::time::Duration;
        
        static CACHE: DualCacheFF<u64, u64, crate::core::config::DefaultExponentialPolicy, 8, 16, 64, 88, 10, 256, 512> = DualCacheFF::new();
        
        // Turn ON Daemon (automatically spawns daemon)
        CACHE.set_daemon_mode(true);
        
        let handle = CACHE.register_thread();

        // Put twice to pass admission filter
        CACHE.insert(10, 1000, &handle);
        CACHE.insert(10, 1000, &handle);
        
        // Get multiple times to reach promote threshold
        for _ in 0..5 {
            let _ = CACHE.get(&10, &handle);
        }
        
        // Wait a bit for daemon to process the promote message
        thread::sleep(Duration::from_millis(50));
        
        // The value should be retrievable
        assert_eq!(CACHE.get(&10, &handle), Some(1000));
    }

    #[cfg(feature = "std")]
    #[test]
    fn test_extensive_coverage() {
        use std::time::Duration;
        
        static CACHE: DualCacheFF<u64, u64, crate::core::config::DefaultExponentialPolicy, 256, 1024, 2048, 4096, 10, 256, 512> = DualCacheFF::new();
        let handle = CACHE.register_thread();

        // Sync mode: insert many items to trigger evictions
        for i in 0..100 {
            CACHE.insert(i, i * 10, &handle);
            CACHE.insert(i, i * 10, &handle); // Admitted
            CACHE.get(&i, &handle);
        }

        // Hit item 10 many times to promote it through T2 -> T1 -> T0
        for _ in 0..300 {
            CACHE.get(&10, &handle);
        }

        // Turn on Daemon
        CACHE.set_daemon_mode(true);

        // Async mode: insert many items
        for i in 100..200 {
            CACHE.insert(i, i * 10, &handle);
            CACHE.insert(i, i * 10, &handle); // Admitted
            // Get multiple times to trigger promote messages and hit batches
            for _ in 0..100 {
                CACHE.get(&i, &handle);
            }
        }
        // Wait for daemon to process
        std::thread::sleep(Duration::from_millis(50));

        // Test manual Promote to T0 and T2 via global_tx
        if let Ok(gtx) = CACHE.global_tx.read() {
            if let Some(ref tx) = *gtx {
                let _ = tx.send(crate::daemon::DaemonMessage::Promote(999, 999, 9990, 0));
                let _ = tx.send(crate::daemon::DaemonMessage::Promote(888, 888, 8880, 2));
            
            // Test HitBatch manual injection
            let mut arr = [(0usize, 0u8); 32];
            arr[0] = (123, 10);
            arr[1] = (123, 5); // Duplicate hash to trigger `found = true`
            arr[2] = (456, 1);
                let _ = tx.send(crate::daemon::DaemonMessage::HitBatch(arr, 3));
            }
        }
        std::thread::sleep(Duration::from_millis(50));

        let handle2 = CACHE.register_thread();
        for i in 100..200 {
            // handle2 TLS is empty, so it will hit core.get
            CACHE.get(&i, &handle2);
        }

        // Insert many items via handle
        for i in 1000..2000 {
            CACHE.insert(i, i * 10, &handle);
        }

        // Get them via handle2. Since handle2 TLS is empty, they will miss TLS and hit Core.
        // Each hit increments warmup_state by 10.
        // Since there are 1000 items, all blocks will easily reach warmup_state > 100.
        for i in 1000..2000 {
            CACHE.get(&i, &handle2);
        }
        
        let warmup = CACHE.tls_registry.get_block_mut(&handle2).warmup_state;
        println!("Warmup state for handle2 after 1000 gets: {}", warmup);
        
        // Now warmup_state of all blocks is > 100.
        // Insert will hit normal insert branch (not fast pass).
        for i in 2000..3000 {
            CACHE.insert(i, i * 10, &handle2);
            CACHE.insert(i, i * 10, &handle2); // second time to pass probation filter
        }

        // Test over-capacity registration panic
        for _ in 1..9 {
            let _ = CACHE.register_thread();
        }
        // Since CACHE is static, catching unwind around its reference requires AssertUnwindSafe.
        let res = std::panic::catch_unwind(|| {
            let _ = CACHE.register_thread(); // Should panic
        });
        assert!(res.is_err());

        // Send a Promote message to Daemon directly
        if let Ok(gtx) = CACHE.global_tx.read() {
            if let Some(ref tx) = *gtx {
                let _ = tx.send(crate::daemon::DaemonMessage::Promote(123, 123, 123, 0));
            }
        }

        // Wait for daemon to process
        thread::sleep(Duration::from_millis(50));

        // Turn off daemon
        CACHE.set_daemon_mode(false);
        
        // Wait for daemon to die
        thread::sleep(Duration::from_millis(50));
        
        // Explicitly reclaim to hit coverage
        CACHE.core.try_reclaim(handle.qsbr_node);
        CACHE.core.try_reclaim(handle.qsbr_node);
    }
}
