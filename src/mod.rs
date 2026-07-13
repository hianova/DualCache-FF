extern crate alloc;

pub mod utils;
pub mod component;
pub mod core;
#[cfg(feature = "std")]
pub mod bench_cata;

use ::core::sync::atomic::{AtomicBool, Ordering};
use crate::component::tls::{TlsRegistry, TlsHandle};

#[cfg(feature = "std")]
use crate::component::daemon::DaemonMessage;


/// `DualCacheFF` is the main entry point for the cache, providing standard API operations and managing the 
/// background daemon for garbage collection and memory reclamation.
#[repr(C, align(64))]
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
    global_tx: std::sync::RwLock<Option<std::sync::Arc<no_std_tool::collections::mpsc_queue::BoundedQueue<DaemonMessage<K, V>, 65536>>>>,
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
> Default for DualCacheFF<K, V, P, CAP2, CAP1, CAP0, TOTAL_CAP, MAX_THREADS, TLS_CAP, TLS_INDEX_CAP>
where 
    K: Clone + Eq + ::core::hash::Hash + Send + Sync + 'static,
    V: Clone + Send + Sync + 'static,
    P: crate::core::config::CachePolicy + Send + Sync + 'static,
 {
    fn default() -> Self {
        Self::new()
    }
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
            let tx = unsafe { std::sync::Arc::<no_std_tool::collections::mpsc_queue::BoundedQueue<DaemonMessage<K, V>, 65536>>::new_zeroed().assume_init() };
            let rx = tx.clone();
            let mut broadcast_txs = std::vec::Vec::with_capacity(self.tls_registry.max_threads());
            
            for i in 0..self.tls_registry.max_threads() {
                let dummy_handle = TlsHandle { id: i, qsbr_node: ::core::ptr::null_mut() };
                let block = self.tls_registry.get_block_mut(&dummy_handle);
                block.tx = Some(tx.clone());
                
                let hit_queue = unsafe { std::sync::Arc::<no_std_tool::collections::mpsc_queue::BoundedQueue<(usize, u8), 1024>>::new_zeroed().assume_init() };
                block.hit_rx = Some(hit_queue.clone());
                broadcast_txs.push(hit_queue);
            }

            let daemon_node = {
                let node = std::boxed::Box::into_raw(std::boxed::Box::new(crate::core::qsbr::ThreadStateNode::new()));
                crate::core::qsbr::register_node(node);
                node
            };
            let _daemon = crate::component::daemon::Daemon::spawn(&self.core, rx, broadcast_txs, daemon_node);
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
        if let Ok(gtx) = self.global_tx.read()
            && let Some(ref global_tx) = *gtx {
                let block = self.tls_registry.get_block_mut(&handle);
                block.tx = Some(global_tx.clone());
            }
        
        handle
    }

    pub fn get(&self, key: &K, handle: &TlsHandle) -> Option<V> {
        let block = self.tls_registry.get_block_mut(handle);
        block.op_count = block.op_count.wrapping_add(1);
        
        let op_count = block.op_count as u32;

        #[cfg(feature = "std")]
        if op_count & 63 == 0 {
            let global = crate::core::qsbr::get_global_epoch();
            unsafe {
                let node = &mut *handle.qsbr_node;
                node.epoch.store(global, ::core::sync::atomic::Ordering::Relaxed);
                node.active.store(true, ::core::sync::atomic::Ordering::Relaxed);
            }
        }
        
        let guard = ::core::mem::ManuallyDrop::new(unsafe { crate::core::qsbr::Guard::unpinned(handle.qsbr_node) });
        let hash = self.core.hash_key(key);
        
        // 1. TLS (Thread Local)
        let (val_opt, promote, sync) = block.cache.get(hash, key);
        if let Some(val) = val_opt {
            block.hit_count = block.hit_count.wrapping_add(1);
            if promote {
                self.core.put_t0(key.clone(), val.clone(), handle.qsbr_node);
            }
            #[cfg(feature = "std")]
            if sync > 0 {
                if block.hit_batch_len < 32 {
                    block.hit_batch[block.hit_batch_len as usize] = (hash, sync);
                    block.hit_batch_len += 1;
                }
                if block.hit_batch_len == 32 {
                    if let Some(ref tx) = block.tx {
                        let mut batch = [(0, 0); 32];
                        batch.copy_from_slice(&block.hit_batch);
                        let _ = tx.push(crate::component::daemon::DaemonMessage::HitBatch(batch, 32));
                    }
                    block.hit_batch_len = 0;
                }
            }
            return Some(val.clone());
        }

        if let Some((val, tier, hint_kv)) = self.core.get(key, &guard, op_count) {
            block.hit_count = block.hit_count.wrapping_add(1);
            match tier {
                0 => {
                    block.warmup_state = block.warmup_state.saturating_add(10);
                    block.cache.insert_fast_pass(hash, key.clone(), val.clone());
                }
                1 => {
                    block.cache.insert(hash, key.clone(), val.clone());
                }
                2 => {
                    block.warmup_state = block.warmup_state.saturating_sub(10);
                    block.cache.insert(hash, key.clone(), val.clone());
                }
                _ => {}
            }
            if let Some((hint_key, hint_val)) = hint_kv {
                // Prefetch the hint directly into TlsCache for instant access next time!
                let hint_hash = self.core.hash_key(&hint_key);
                block.cache.insert_fast_pass(hint_hash, hint_key, hint_val);
            }
            return Some(val.clone());
        }
        None
    }

    pub fn insert(&self, key: K, value: V, handle: &TlsHandle) {
        let block = self.tls_registry.get_block_mut(handle);
        let _guard = crate::core::qsbr::pin(handle.qsbr_node);
        block.op_count = block.op_count.wrapping_add(1);

        let hash = self.core.hash_key(&key);
        let (_, _, _, warmup_thresh) = self.core.blackjack.load_params();

        if block.warmup_state > warmup_thresh {
            block.cache.insert_fast_pass(hash, key.clone(), value.clone());
            self.core.put_t0(key, value, handle.qsbr_node);
            block.warmup_state = block.warmup_state.saturating_sub(20);
        } else {
            if block.cache.insert(hash, key.clone(), value.clone()) {
                self.core.put(key, value, handle.qsbr_node);
            }
        }
    }

    /// Insert a key-value pair directly as a high-priority "genius" item.
    /// This bypasses normal promotion and pins the item directly in the hottest tier (T0).
    /// Equivalent to 'insert_t1' or 'warmup' from v0.4.0.
    pub fn warmup(&self, key: K, value: V, handle: &TlsHandle) {
        let block = self.tls_registry.get_block_mut(handle);
        let _guard = crate::core::qsbr::pin(handle.qsbr_node);
        block.op_count = block.op_count.wrapping_add(1);

        let hash = self.core.hash_key(&key);
        block.cache.insert_fast_pass(hash, key.clone(), value.clone());
        self.core.put_t0(key, value, handle.qsbr_node);
    }

    pub fn get_metrics(&self) -> (u64, u64) {
        self.tls_registry.get_metrics()
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
        static GLOBAL_CACHE: DualCacheFF<u64, u64, crate::core::config::DefaultExponentialPolicy, 256, 1024, 2048, 1024, 10, 256, 512> = DualCacheFF::new();
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
                let _ = tx.push(crate::component::daemon::DaemonMessage::Promote(999, 999, 9990, 0));
                let _ = tx.push(crate::component::daemon::DaemonMessage::Promote(888, 888, 8880, 2));
            
            // Test HitBatch manual injection
            let mut arr = [(0usize, 0u8); 32];
            arr[0] = (123, 10);
            arr[1] = (123, 5); // Duplicate hash to trigger `found = true`
            arr[2] = (456, 1);
                let _ = tx.push(crate::component::daemon::DaemonMessage::HitBatch(arr, 3));
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
                let _ = tx.push(crate::component::daemon::DaemonMessage::Promote(123, 123, 123, 0));
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
