use crate::core::config::CachePolicy;
use crate::core::engine::DualCacheCore;
#[cfg(not(feature = "std"))]
use crate::core::qsbr::{ThreadStateNode, pin};
use ::core::sync::atomic::{AtomicUsize, Ordering};
use core::hash::Hash;
use no_std_tool::sync::SpinMutex;

#[cfg(feature = "std")]
pub struct StaticDualCache<
    K,
    V,
    P: CachePolicy,
    const T0_CAP: usize,
    const T1_CAP: usize,
    const T2_CAP: usize,
    const TOTAL_CAP: usize,
> {
    core: DualCacheCore<K, V, P, T0_CAP, T1_CAP, T2_CAP, TOTAL_CAP>,
    tls_registry: crate::component::tls::TlsRegistry<K, V, 4096, 128>,
    reclaim_lock: SpinMutex<()>,
    insert_count: AtomicUsize,
}

#[cfg(feature = "std")]
impl<
    K,
    V,
    P: CachePolicy,
    const T0_CAP: usize,
    const T1_CAP: usize,
    const T2_CAP: usize,
    const TOTAL_CAP: usize,
> StaticDualCache<K, V, P, T0_CAP, T1_CAP, T2_CAP, TOTAL_CAP>
where
    K: Clone + Eq + Hash + Send + Sync + 'static,
    V: Clone + Send + Sync + 'static,
{
    pub fn new(eviction: P::Evict) -> Self {
        Self {
            core: DualCacheCore::new(eviction),
            tls_registry: crate::component::tls::TlsRegistry::default(),
            reclaim_lock: SpinMutex::new(()),
            insert_count: AtomicUsize::new(0),
        }
    }

    /// Retrieve a value from the cache lock-freely.
    pub fn get(&self, key: &K) -> Option<V> {
        thread_local! {
            static THREAD_HANDLE: std::cell::OnceCell<crate::component::tls::TlsHandle> = const { std::cell::OnceCell::new() };
        }

        let node_ptr = THREAD_HANDLE.with(|cell| {
            cell.get_or_init(|| self.tls_registry.register_thread())
                .qsbr_node
        });

        let guard = unsafe { crate::core::qsbr::Guard::unpinned(node_ptr) };
        self.core
            .get(key, &guard, 16)
            .map(|(v_ref, _tier, _hint)| v_ref.clone())
    }

    /// Insert a key-value pair into the cache. Handles inline reclamation synchronously.
    pub fn put(&self, key: K, value: V) {
        thread_local! {
            static THREAD_HANDLE: std::cell::OnceCell<crate::component::tls::TlsHandle> = const { std::cell::OnceCell::new() };
        }

        let node_ptr = THREAD_HANDLE.with(|cell| {
            cell.get_or_init(|| self.tls_registry.register_thread())
                .qsbr_node
        });

        self.core.put(key, value, node_ptr);

        let count = self.insert_count.fetch_add(1, Ordering::Relaxed);

        // Inline QSBR reclamation every 1024 inserts to prevent Arena OOM
        if count % 1024 == 1023 && self.reclaim_lock.lock().is_ok() {
            self.core.sync_reclaim();
        }
    }
}

#[cfg(not(feature = "std"))]
pub struct StaticDualCache<
    K,
    V,
    P: CachePolicy,
    const T0_CAP: usize,
    const T1_CAP: usize,
    const T2_CAP: usize,
    const TOTAL_CAP: usize,
> {
    inner: SpinMutex<(
        DualCacheCore<K, V, P, T0_CAP, T1_CAP, T2_CAP, TOTAL_CAP>,
        ThreadStateNode,
        bool,
    )>,
    insert_count: AtomicUsize,
}

#[cfg(not(feature = "std"))]
impl<
    K,
    V,
    P: CachePolicy,
    const T0_CAP: usize,
    const T1_CAP: usize,
    const T2_CAP: usize,
    const TOTAL_CAP: usize,
> StaticDualCache<K, V, P, T0_CAP, T1_CAP, T2_CAP, TOTAL_CAP>
where
    K: Clone + Eq + Hash,
    V: Clone,
{
    pub const fn new(eviction: P::Evict) -> Self {
        Self {
            inner: SpinMutex::new((DualCacheCore::new(eviction), ThreadStateNode::new(), false)),
            insert_count: AtomicUsize::new(0),
        }
    }

    /// Retrieve a value from the cache synchronously.
    pub fn get(&self, key: &K) -> Option<V> {
        let mut inner = match self.inner.lock() {
            Ok(guard) => guard,
            Err(_) => return None, // Aerospace-grade: treat lock timeout as cache miss to guarantee bounded latency
        };
        let (engine, qsbr_node, registered) = &mut *inner;

        if !*registered {
            crate::core::qsbr::register_node(qsbr_node as *mut _);
            *registered = true;
        }

        let guard = pin(qsbr_node as *mut ThreadStateNode);

        // Map the reference to an owned value to allow releasing the lock safely
        // Pass 16 to force record_hit for static cache which doesn't have a thread local op_count
        engine
            .get(key, &guard, 16)
            .map(|(v_ref, _tier, _hint)| v_ref.clone())
    }

    /// Insert a key-value pair into the cache. Handles inline reclamation synchronously.
    pub fn put(&self, key: K, value: V) {
        let mut inner = match self.inner.lock() {
            Ok(guard) => guard,
            Err(_) => return, // Aerospace-grade: drop insert on lock timeout to guarantee bounded latency
        };
        let (engine, qsbr_node, registered) = &mut *inner;

        if !*registered {
            crate::core::qsbr::register_node(qsbr_node as *mut _);
            *registered = true;
        }

        let node_ptr = qsbr_node as *mut ThreadStateNode;

        engine.put(key, value, node_ptr);

        let count = self.insert_count.fetch_add(1, Ordering::Relaxed);

        // Inline QSBR reclamation every 1024 inserts to prevent Arena OOM
        if count % 1024 == 1023 {
            engine.sync_reclaim();
        }
    }
}

#[cfg(feature = "std")]
impl<
    K,
    V,
    P: CachePolicy,
    const T0_CAP: usize,
    const T1_CAP: usize,
    const T2_CAP: usize,
    const TOTAL_CAP: usize,
> Default for StaticDualCache<K, V, P, T0_CAP, T1_CAP, T2_CAP, TOTAL_CAP>
where
    K: Clone + Eq + Hash + Send + Sync + 'static,
    V: Clone + Send + Sync + 'static,
{
    fn default() -> Self {
        Self::new(P::Evict::default())
    }
}

#[cfg(not(feature = "std"))]
impl<
    K,
    V,
    P: CachePolicy,
    const T0_CAP: usize,
    const T1_CAP: usize,
    const T2_CAP: usize,
    const TOTAL_CAP: usize,
> Default for StaticDualCache<K, V, P, T0_CAP, T1_CAP, T2_CAP, TOTAL_CAP>
where
    K: Clone + Eq + Hash,
    V: Clone,
{
    fn default() -> Self {
        Self::new(P::Evict::default())
    }
}

/// A default configured Bottom-Up Anchoring StaticDualCache
pub type StaticBottomUpCache<K, V> = StaticDualCache<
    K,
    V,
    crate::core::config::DefaultExponentialPolicy,
    64,
    4096,
    262144,
    { 64 + 4096 + 262144 },
>;

impl<
    K: Clone + Eq + core::hash::Hash + Send + Sync + 'static,
    V: Clone + Send + Sync + 'static,
    P: crate::core::config::CachePolicy + Send + Sync + 'static,
    const T0_CAP: usize,
    const T1_CAP: usize,
    const T2_CAP: usize,
    const TOTAL_CAP: usize,
> crate::cache_trait::ConcurrentCache<K, V>
    for StaticDualCache<K, V, P, T0_CAP, T1_CAP, T2_CAP, TOTAL_CAP>
{
    fn get(&self, key: &K) -> Option<V> {
        self.get(key)
    }

    fn put(&self, key: K, value: V) {
        self.put(key, value)
    }
}
