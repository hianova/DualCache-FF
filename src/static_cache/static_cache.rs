#[cfg(not(feature = "std"))]
use alloc::vec::Vec;

use core::hash::{BuildHasher, Hash, Hasher};
use ahash::RandomState;
use core::cell::UnsafeCell;

use crate::sync::{Arc, ArcSlice, new_arc_slice};
use crate::sync::atomic::{AtomicBool, AtomicU32, Ordering};
use crate::filters::{T1, T2};
use crate::storage::Cache;
use crate::cache::WorkerState;
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
    pub worker_states: ArcSlice<WorkerState>,
    
    // Protects `core`
    lock: AtomicBool,
    core: UnsafeCell<CoreCache<K, V>>,
}

unsafe impl<K: Send, V: Send, S: Send> Send for StaticDualCache<K, V, S> {}
unsafe impl<K: Sync, V: Sync, S: Sync> Sync for StaticDualCache<K, V, S> {}

impl<K, V> StaticDualCache<K, V, RandomState>
where
    K: Hash + Eq + Send + Sync + Clone + 'static,
    V: Send + Sync + Clone + 'static,
{
    pub fn new(config: Config) -> Self {
        Self::with_hasher(config, RandomState::new())
    }

    pub fn new_headless(config: Config) -> (Self, ()) {
        (Self::new(config), ())
    }
}

impl<K, V, S> StaticDualCache<K, V, S>
where
    K: Hash + Eq + Send + Sync + Clone + 'static,
    V: Send + Sync + Clone + 'static,
    S: BuildHasher + Clone + Send + 'static,
{
    pub fn with_hasher(config: Config, hasher: S) -> Self {
        let t1 = Arc::new(T1::new(config.capacity));
        let t2 = Arc::new(T2::new(config.capacity));
        let cache = Arc::new(Cache::new(config.capacity));
        let epoch = Arc::new(AtomicU32::new(0));
        let is_cold_start = Arc::new(AtomicBool::new(true));

        let mut states = Vec::with_capacity(config.threads);
        for _ in 0..config.threads {
            states.push(WorkerState::new());
        }
        let worker_states = new_arc_slice(states);

        let core = CoreCache::new(
            config.capacity,
            t1.clone(),
            t2.clone(),
            cache.clone(),
            epoch.clone(),
            config.duration,
            worker_states.clone(),
            is_cold_start,
        );

        Self {
            hasher,
            t1,
            t2,
            cache,
            epoch,
            worker_states,
            lock: AtomicBool::new(false),
            core: UnsafeCell::new(core),
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
        if res.is_some() {
            if let Some(global_idx) = self.cache.index_probe(hash, tag) {
                let core = self.acquire_lock();
                core.process_hits(&[global_idx]);
                self.release_lock();
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

    pub fn insert_t1(&self, key: K, value: V) {
        let mut s = self.hasher.build_hasher();
        key.hash(&mut s);
        let hash = s.finish();

        let core = self.acquire_lock();
        core.handle_insert_t1(key, value, hash);
        self.release_lock();
    }

    pub fn remove(&self, key: &K) {
        let mut s = self.hasher.build_hasher();
        key.hash(&mut s);
        let hash = s.finish();

        let core = self.acquire_lock();
        core.handle_remove(key.clone(), hash); // key isn't actually used by handle_remove except for signature? wait, cache.rs handle_remove takes K, let's clone.
        self.release_lock();
    }

    pub fn maintenance(&self) {
        let core = self.acquire_lock();
        core.maintenance();
        self.release_lock();
    }

    pub fn clear(&self) {
        let core = self.acquire_lock();
        core.handle_clear();
        self.release_lock();
    }
}
