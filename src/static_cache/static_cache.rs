use core::hash::{BuildHasher, Hash, Hasher};
use ahash::RandomState;

/// A single cache slot in the direct-mapped StaticDualCache.
/// Utilizes a lightweight spinlock and an UnsafeCell to manage
/// exclusive mutable access to the underlying optional key-value pair.
#[derive(Debug)]
pub struct CacheSlot<K, V> {
    lock: core::sync::atomic::AtomicBool,
    data: core::cell::UnsafeCell<Option<(K, V)>>,
}

// UnsafeCell is not Sync by default. We manually implement Send/Sync
// because the slot access is guarded by the atomic spinlock.
unsafe impl<K: Send, V: Send> Send for CacheSlot<K, V> {}
unsafe impl<K: Sync, V: Sync> Sync for CacheSlot<K, V> {}

impl<K, V> CacheSlot<K, V> {
    /// Create a new empty cache slot.
    #[inline]
    pub const fn new() -> Self {
        Self {
            lock: core::sync::atomic::AtomicBool::new(false),
            data: core::cell::UnsafeCell::new(None),
        }
    }
}

/// A zero-allocation, completely `alloc`-free static concurrent cache.
/// Suitable for ultra-constrained bare-metal environments (e.g. IoT, ESP32-C6).
///
/// Uses direct-mapped layout with const-generic capacity `N` and individual slot-level spinlocks.
#[derive(Debug)]
pub struct StaticDualCache<K, V, const N: usize, S = RandomState> {
    hasher: S,
    slots: [CacheSlot<K, V>; N],
}

// StaticDualCache implements Send/Sync if its components do.
unsafe impl<K: Send, V: Send, const N: usize, S: Send> Send for StaticDualCache<K, V, N, S> {}
unsafe impl<K: Sync, V: Sync, const N: usize, S: Sync> Sync for StaticDualCache<K, V, N, S> {}

impl<K, V, const N: usize> StaticDualCache<K, V, N, RandomState> {
    /// Create a new StaticDualCache instance with a default hasher.
    #[inline]
    pub fn new(_config: crate::Config) -> Self {
        Self {
            hasher: RandomState::new(),
            slots: [const { CacheSlot::new() }; N],
        }
    }

    /// Exposes API parity with `DualCacheFF::new_headless`
    #[inline]
    pub fn new_headless(_config: crate::Config) -> (Self, ()) {
        (
            Self::new(_config),
            (),
        )
    }
}

impl<K, V, const N: usize, S> StaticDualCache<K, V, N, S>
where
    K: Hash + Eq + Clone,
    V: Clone,
    S: BuildHasher,
{
    /// Create a new StaticDualCache instance with a custom hasher.
    #[inline]
    pub fn with_hasher(hasher: S) -> Self {
        Self {
            hasher,
            slots: [const { CacheSlot::new() }; N],
        }
    }

    #[inline(always)]
    fn get_slot_idx(&self, key: &K) -> usize {
        let mut s = self.hasher.build_hasher();
        key.hash(&mut s);
        (s.finish() as usize) % N
    }

    /// Retrieve a cloned value associated with the key if it exists in the cache slot.
    pub fn get(&self, key: &K) -> Option<V> {
        let idx = self.get_slot_idx(key);
        let slot = &self.slots[idx];

        // Spin-lock the slot
        while slot.lock.compare_exchange_weak(
            false,
            true,
            core::sync::atomic::Ordering::Acquire,
            core::sync::atomic::Ordering::Relaxed,
        ).is_err() {
            core::hint::spin_loop();
        }

        // Access UnsafeCell safely while holding the lock
        let data = unsafe { &*slot.data.get() };
        let res = match data {
            Some((k, v)) if k == key => Some(v.clone()),
            _ => None,
        };

        // Unlock
        slot.lock.store(false, core::sync::atomic::Ordering::Release);

        res
    }

    /// Insert or update a key-value pair in the mapped cache slot.
    pub fn insert(&self, key: K, value: V) {
        let idx = self.get_slot_idx(&key);
        let slot = &self.slots[idx];

        // Spin-lock the slot
        while slot.lock.compare_exchange_weak(
            false,
            true,
            core::sync::atomic::Ordering::Acquire,
            core::sync::atomic::Ordering::Relaxed,
        ).is_err() {
            core::hint::spin_loop();
        }

        // Access UnsafeCell safely while holding the lock
        let data = unsafe { &mut *slot.data.get() };
        *data = Some((key, value));

        // Unlock
        slot.lock.store(false, core::sync::atomic::Ordering::Release);
    }

    /// Remove a key-value pair if the key matches the mapped slot.
    pub fn remove(&self, key: &K) {
        let idx = self.get_slot_idx(key);
        let slot = &self.slots[idx];

        // Spin-lock the slot
        while slot.lock.compare_exchange_weak(
            false,
            true,
            core::sync::atomic::Ordering::Acquire,
            core::sync::atomic::Ordering::Relaxed,
        ).is_err() {
            core::hint::spin_loop();
        }

        // Access UnsafeCell safely while holding the lock
        let data = unsafe { &mut *slot.data.get() };
        if let Some((k, _)) = data {
            if k == key {
                *data = None;
            }
        }

        // Unlock
        slot.lock.store(false, core::sync::atomic::Ordering::Release);
    }

    /// Clear all cached slots.
    pub fn clear(&self) {
        for slot in &self.slots {
            // Spin-lock the slot
            while slot.lock.compare_exchange_weak(
                false,
                true,
                core::sync::atomic::Ordering::Acquire,
                core::sync::atomic::Ordering::Relaxed,
            ).is_err() {
                core::hint::spin_loop();
            }

            // Clear the data inside
            let data = unsafe { &mut *slot.data.get() };
            *data = None;

            // Unlock
            slot.lock.store(false, core::sync::atomic::Ordering::Release);
        }
    }

    /// Synchronize the cache (no-op for static cache parity).
    #[inline(always)]
    pub fn sync(&self) {}
}
