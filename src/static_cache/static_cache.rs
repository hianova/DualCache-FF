#[cfg(not(feature = "std"))]
use alloc::vec::Vec;

use core::hash::{BuildHasher, Hash, Hasher};
use ahash::RandomState;
use core::cell::UnsafeCell;

use crate::sync::Arc;
use crate::sync::atomic::{AtomicBool, AtomicU32, Ordering};
use crate::filters::{T1, T2};
use crate::storage::Cache;
use crate::core_cache::CoreCache;
use crate::Config;

/// A synchronous, wait-free read / spin-locked write cache interface.
/// Serves as the standard `no_std` fallback when background Daemon processing is undesirable.
pub struct StaticDualCache<K, V, S = RandomState> {
    pub hasher: S,
    pub t1: Arc<T1<K, V>>,
    pub t2: Arc<T2<K, V>>,
    pub cache: Arc<Cache<K, V>>,
    pub epoch: Arc<AtomicU32>,
    pub registry: Arc<crate::registry::ThreadRegistry<K, V>>,
    pub is_cold_start: Arc<AtomicBool>,
    
    // Protects `core`
    lock: AtomicBool,
    core: UnsafeCell<CoreCache<K, V>>,
}

unsafe impl<K: Send, V: Send, S: Send> Send for StaticDualCache<K, V, S> {}
unsafe impl<K: Sync, V: Sync, S: Sync> Sync for StaticDualCache<K, V, S> {}

/// A dummy daemon struct for StaticDualCache to maintain API parity with DualCacheFF.
pub struct DummyDaemon;
impl DummyDaemon {
    /// No-op run loop.
    #[inline(always)]
    pub fn run(self) {}
}

/// A dummy cold start session for StaticDualCache to maintain API parity with DualCacheFF.
pub struct DummyColdStartSession;

impl<K, V> StaticDualCache<K, V, RandomState>
where
    K: Hash + Eq + Send + Sync + Clone + 'static,
    V: Send + Sync + Clone + 'static,
{
    /// Create a new `StaticDualCache` using standard settings.
    pub fn new(config: Config) -> Self {
        Self::with_hasher(config, RandomState::new())
    }

    /// Create a new `StaticDualCache` with eviction/promotion callbacks.
    pub fn new_with_callbacks(
        config: Config,
        on_evict: Option<Arc<dyn Fn(K, V) + Send + Sync>>,
        on_promote: Option<Arc<dyn Fn(K, V) + Send + Sync>>,
    ) -> Self {
        Self::with_hasher_and_callbacks(config, RandomState::new(), on_evict, on_promote)
    }

    /// Create a headless `StaticDualCache` and a `DummyDaemon` (for API symmetry).
    pub fn new_headless(config: Config) -> (Self, DummyDaemon) {
        (Self::new(config), DummyDaemon)
    }
}

impl<K, V, S> StaticDualCache<K, V, S>
where
    K: Hash + Eq + Send + Sync + Clone + 'static,
    V: Send + Sync + Clone + 'static,
    S: BuildHasher + Clone + Send + 'static,
{
    /// Create a `StaticDualCache` with a custom hasher.
    pub fn with_hasher(config: Config, hasher: S) -> Self {
        Self::with_hasher_and_callbacks(config, hasher, None, None)
    }

    pub fn with_hasher_and_callbacks(
        mut config: Config,
        hasher: S,
        on_evict: Option<Arc<dyn Fn(K, V) + Send + Sync>>,
        on_promote: Option<Arc<dyn Fn(K, V) + Send + Sync>>,
    ) -> Self {
        config.threads = 0;
        let t1 = Arc::new(T1::new(config.capacity));
        let t2 = Arc::new(T2::new(config.capacity));
        let cache = Arc::new(Cache::new(config.capacity));
        let epoch = Arc::new(AtomicU32::new(0));
        let is_cold_start = Arc::new(AtomicBool::new(true));

        let registry = Arc::new(crate::registry::ThreadRegistry::new(config.threads));

        let core = CoreCache::new(
            config.capacity,
            t1.clone(),
            t2.clone(),
            cache.clone(),
            epoch.clone(),
            config.duration,
            registry.clone(),
            is_cold_start.clone(),
            on_evict,
            on_promote,
        );

        Self {
            hasher,
            t1,
            t2,
            cache,
            epoch,
            registry,
            is_cold_start: is_cold_start.clone(),
            lock: AtomicBool::new(false),
            core: UnsafeCell::new(core),
        }
    }

    /// No-op sync to maintain API symmetry with DualCacheFF.
    #[inline(always)]
    pub fn sync(&self) {}

    /// No-op quiescent to maintain API symmetry with DualCacheFF.
    #[inline(always)]
    pub fn quiescent(&self) {}

    /// Returns the number of active/occupied entries in (T1, T2, Core Cache)
    pub fn entry_count(&self) -> (usize, usize, usize) {
        let t1_count = self.t1.slots.iter().filter(|ptr| !ptr.load(Ordering::Relaxed).is_null()).count();
        let t2_count = self.t2.slots.iter().filter(|ptr| !ptr.load(Ordering::Relaxed).is_null()).count();
        let cache_count = self.cache.nodes.iter().filter(|ptr| !ptr.load(Ordering::Relaxed).is_null()).count();
        (t1_count, t2_count, cache_count)
    }

    /// Dummy cold start session to maintain API symmetry.
    #[inline(always)]
    pub fn begin_cold_start_session(&self) -> DummyColdStartSession {
        DummyColdStartSession
    }

    /// Iterative batch insert for warmups, bypassing probation.
    pub fn warmup<I: IntoIterator<Item = (K, V)>>(&self, iter: I) {
        for (k, v) in iter {
            self.insert_t1(k, v);
        }
    }

    #[inline(always)]
    fn acquire_lock(&self) -> &mut CoreCache<K, V> {
        while self.lock.compare_exchange_weak(
            false,
            true,
            Ordering::Acquire,
            Ordering::Relaxed,
        ).is_err() {
            core::hint::spin_loop();
        }
        unsafe { &mut *self.core.get() }
    }

    #[inline(always)]
    fn try_acquire_lock(&self) -> Option<&mut CoreCache<K, V>> {
        if self.lock.compare_exchange_weak(
            false,
            true,
            Ordering::Acquire,
            Ordering::Relaxed,
        ).is_ok() {
            Some(unsafe { &mut *self.core.get() })
        } else {
            None
        }
    }

    #[inline(always)]
    fn release_lock(&self) {
        self.lock.store(false, Ordering::Release);
    }

    /// Read operations are fully Lock-Free.
    pub fn get(&self, key: &K) -> Option<V> {
        let current_epoch = self.epoch.load(Ordering::Relaxed);
        let mut s = self.hasher.build_hasher();
        key.hash(&mut s);
        let hash = s.finish();
        let tag = (hash >> 48) as u16;

        let res = if let Some(node) = self.t1.get_node(hash) {
            if node.key == *key && (node.expire_at == 0 || node.expire_at >= current_epoch) {
                Some(node.value.clone())
            } else {
                None
            }
        } else if let Some(node) = self.t2.get_node(hash) {
            if node.key == *key && (node.expire_at == 0 || node.expire_at >= current_epoch) {
                Some(node.value.clone())
            } else {
                None
            }
        } else {
            let mut val = None;
            if let Some(global_idx) = self.cache.index_probe(hash, tag) {
                if let Some(v) = self.cache.node_get_full(global_idx, key, current_epoch) {
                    val = Some(v);
                }
            }
            val
        };

        // For StaticDualCache, we register hits synchronously.
        // We use try_lock to avoid deadlocks and preserve wait-free reads if another thread
        // is preempted or sleeping while holding the lock.
        if res.is_some() {
            if let Some(global_idx) = self.cache.index_probe(hash, tag) {
                if let Some(core) = self.try_acquire_lock() {
                    core.process_hits(&[global_idx]);
                    self.release_lock();
                }
            }
        }

        res
    }

    /// Insert synchronously acquires the lock and updates the core.
    pub fn insert(&self, key: K, value: V) {
        let mut s = self.hasher.build_hasher();
        key.hash(&mut s);
        let hash = s.finish();

        let core = self.acquire_lock();
        core.handle_admission_insert(key, value, hash, false);
        self.release_lock();
    }

    /// Insert an item directly into T1 (Hot Tier) synchronously.
    pub fn insert_t1(&self, key: K, value: V) {
        let mut s = self.hasher.build_hasher();
        key.hash(&mut s);
        let hash = s.finish();

        let core = self.acquire_lock();
        core.handle_insert_t1(key, value, hash);
        self.release_lock();
    }

    /// Remove a key from the cache synchronously.
    pub fn remove(&self, key: &K) {
        let mut s = self.hasher.build_hasher();
        key.hash(&mut s);
        let hash = s.finish();

        let core = self.acquire_lock();
        core.handle_remove(key.clone(), hash); // key isn't actually used by handle_remove except for signature? wait, cache.rs handle_remove takes K, let's clone.
        self.release_lock();
    }

    /// Trigger manual eviction and garbage reclamation synchronously.
    pub fn maintenance(&self) {
        let core = self.acquire_lock();
        core.maintenance();
        self.release_lock();
    }

    /// Clear all cache contents synchronously.
    pub fn clear(&self) {
        let core = self.acquire_lock();
        core.handle_clear();
        self.release_lock();
    }

    /// Returns the health status of the Daemon (always Stopped for StaticDualCache).
    #[inline(always)]
    pub fn daemon_health(&self) -> crate::daemon::DaemonStatus {
        crate::daemon::DaemonStatus::Stopped
    }

    /// Restart the daemon if it has panicked or stopped (no-op for StaticDualCache).
    #[cfg(feature = "std")]
    #[inline(always)]
    pub fn restart_daemon<Sp: crate::components::Spawner>(&self, _spawner: Sp, _poll_us: u64) {}

    /// Shutdown the daemon gracefully, waiting for queues to drain (no-op for StaticDualCache).
    #[inline(always)]
    pub fn shutdown_gracefully(&self, _timeout: Option<core::time::Duration>) {}

    /// Suspend the background Daemon thread (no-op for StaticDualCache).
    #[inline(always)]
    pub fn suspend(&self) {}

    /// Resume the background Daemon thread (no-op for StaticDualCache).
    #[inline(always)]
    pub fn resume(&self) {}
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::sync::Arc;
    use std::thread;
    use crate::config::Config;

    #[test]
    fn test_static_cache_coverage() {
        use std::sync::atomic::AtomicBool;
        let sc = Arc::new(StaticDualCache::<String, String>::new(Config::with_memory_budget(1024, 8)));
        
        // hit maintenance
        sc.maintenance();
        sc.clear();
        
        sc.insert_t1("k1".to_string(), "v1".to_string());
        sc.insert("k2".to_string(), "v2".to_string());
        
        let sc_clone = sc.clone();
        let ready = Arc::new(AtomicBool::new(false));
        let ready_clone = ready.clone();
        
        // Lock manually to force try_acquire_lock failure and spin_loop
        // This avoids creating a `&mut CoreCache` which would cause Aliasing UB across threads!
        sc.lock.store(true, Ordering::Release);
        
        let t = thread::spawn(move || {
            // this try_acquire_lock inside get() will fail and bypass telemetry safely
            assert_eq!(sc_clone.get(&"k1".to_string()), Some("v1".to_string()));
            
            ready_clone.store(true, Ordering::Release);
            
            // this acquire_lock inside maintenance will hit the spin loop until main releases
            sc_clone.maintenance();
        });
        
        // Wait until thread reaches the spin loop
        while !ready.load(Ordering::Acquire) {
            thread::yield_now();
        }
        
        sc.lock.store(false, Ordering::Release); // let thread continue
        t.join().unwrap();

        assert_eq!(sc.get(&"k2".to_string()), Some("v2".to_string()));
        sc.remove(&"k1".to_string());
        assert_eq!(sc.get(&"k1".to_string()), None);
    }
}
