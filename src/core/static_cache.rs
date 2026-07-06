use crate::core::engine::DualCacheCore;
use crate::componant::qsbr::{ThreadStateNode, pin};
use crate::componant::config::CachePolicy;
use core::hash::Hash;
use no_std_tool::sync::SpinMutex;
use ::core::sync::atomic::{AtomicUsize, Ordering};

pub struct StaticDualCache<K, V, P: CachePolicy, const T0_CAP: usize, const T1_CAP: usize, const T2_CAP: usize, const TOTAL_CAP: usize> {
    inner: SpinMutex<(DualCacheCore<K, V, P, T0_CAP, T1_CAP, T2_CAP, TOTAL_CAP>, ThreadStateNode)>,
    insert_count: AtomicUsize,
}

impl<K, V, P: CachePolicy, const T0_CAP: usize, const T1_CAP: usize, const T2_CAP: usize, const TOTAL_CAP: usize> StaticDualCache<K, V, P, T0_CAP, T1_CAP, T2_CAP, TOTAL_CAP> 
where
    K: Clone + Eq + Hash,
    V: Clone,
{
    pub const fn new() -> Self {
        Self {
            inner: SpinMutex::new((DualCacheCore::new(), ThreadStateNode::new())),
            insert_count: AtomicUsize::new(0),
        }
    }

    /// Retrieve a value from the cache synchronously.
    pub fn get(&self, key: &K) -> Option<V> {
        let mut inner = self.inner.lock().unwrap();
        let (engine, qsbr_node) = &mut *inner;
        
        let guard = pin(qsbr_node as *mut ThreadStateNode);
        
        // Map the reference to an owned value to allow releasing the lock safely
        // Pass 16 to force record_hit for static cache which doesn't have a thread local op_count
        engine.get(key, &guard, 16).map(|(v_ref, _tier, _hint)| v_ref.clone())
    }

    /// Insert a key-value pair into the cache. Handles inline reclamation synchronously.
    pub fn put(&self, key: K, value: V) {
        let mut inner = self.inner.lock().unwrap();
        let (engine, qsbr_node) = &mut *inner;
        let node_ptr = qsbr_node as *mut ThreadStateNode;
        
        engine.put(key, value, node_ptr);
        
        let count = self.insert_count.fetch_add(1, Ordering::Relaxed);
        
        // Inline QSBR reclamation every 1024 inserts to prevent Arena OOM
        if count % 1024 == 1023 {
            engine.try_reclaim(node_ptr);
        }
    }
}

impl<K, V, P: CachePolicy, const T0_CAP: usize, const T1_CAP: usize, const T2_CAP: usize, const TOTAL_CAP: usize> Default for StaticDualCache<K, V, P, T0_CAP, T1_CAP, T2_CAP, TOTAL_CAP> 
where
    K: Clone + Eq + Hash,
    V: Clone,
{
    fn default() -> Self {
        Self::new()
    }
}

/// A default configured Bottom-Up Anchoring StaticDualCache
pub type StaticBottomUpCache<K, V> = StaticDualCache<K, V, crate::componant::config::DefaultExponentialPolicy, 64, 4096, 262144, { 64 + 4096 + 262144 }>;
