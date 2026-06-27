use core::marker::PhantomData;

/// A zero-overhead, completely compiled-away stub implementation of the DualCache API.
/// All methods are marked with `#[inline(always)]` and evaluate to no-ops.
/// Suitable for ultra-constrained bare-metal environments where caching is compiled out.
#[derive(Debug, Clone)]
pub struct DualCacheStub<K, V> {
    _marker: PhantomData<(K, V)>,
}

impl<K, V> DualCacheStub<K, V> {
    /// Create a new stub cache instance (which does nothing).
    #[inline(always)]
    pub fn new(_config: crate::Config) -> Self {
        Self {
            _marker: PhantomData,
        }
    }

    /// Exposes API parity with `DualCacheFF::new_headless`
    #[inline(always)]
    pub fn new_headless(_config: crate::Config) -> (Self, ()) {
        (
            Self {
                _marker: PhantomData,
            },
            (),
        )
    }

    /// Exposes API parity with `DualCacheFF::get`
    #[inline(always)]
    pub fn get(&self, _key: &K) -> Option<V> {
        None
    }

    /// Exposes API parity with `DualCacheFF::insert`
    #[inline(always)]
    pub fn insert(&self, _key: K, _value: V) {}

    /// Exposes API parity with `DualCacheFF::remove`
    #[inline(always)]
    pub fn remove(&self, _key: &K) {}

    /// Exposes API parity with `DualCacheFF::clear`
    #[inline(always)]
    pub fn clear(&self) {}

    /// Exposes API parity with `DualCacheFF::sync`
    #[inline(always)]
    pub fn sync(&self) {}

    /// Exposes API parity with `DualCacheFF::daemon_health`
    #[inline(always)]
    pub fn daemon_health(&self) -> crate::daemon::DaemonStatus {
        crate::daemon::DaemonStatus::Stopped
    }

    /// Exposes API parity with `DualCacheFF::shutdown_gracefully`
    #[inline(always)]
    pub fn shutdown_gracefully(&self, _timeout: Option<core::time::Duration>) {}

    /// Exposes API parity with `DualCacheFF::suspend`
    #[inline(always)]
    pub fn suspend(&self) {}

    /// Exposes API parity with `DualCacheFF::resume`
    #[inline(always)]
    pub fn resume(&self) {}
}
