use core::cell::UnsafeCell;
use crate::sync::atomic::{AtomicBool, Ordering};
use crate::core_cache::CoreCache;
#[cfg(feature = "std")]
use std::sync::Mutex;
#[cfg(feature = "std")]
use std::thread::Thread;

pub struct SharedCore<K, V> {
    pub lock: AtomicBool,
    pub core: UnsafeCell<CoreCache<K, V>>,
    pub is_suspended: AtomicBool,
    pub is_parked: AtomicBool,
    #[cfg(feature = "std")]
    pub daemon_thread: Mutex<Option<Thread>>,
}

unsafe impl<K: Send, V: Send> Send for SharedCore<K, V> {}
unsafe impl<K: Sync, V: Sync> Sync for SharedCore<K, V> {}

impl<K, V> SharedCore<K, V> {
    pub fn new(core: CoreCache<K, V>) -> Self {
        Self {
            lock: AtomicBool::new(false),
            core: UnsafeCell::new(core),
            is_suspended: AtomicBool::new(false),
            is_parked: AtomicBool::new(false),
            #[cfg(feature = "std")]
            daemon_thread: Mutex::new(None),
        }
    }

    #[inline(always)]
    pub fn acquire_lock(&self) -> SpinLockGuard<'_, K, V> {
        let mut backoff = 1;
        while self.lock.compare_exchange_weak(false, true, Ordering::Acquire, Ordering::Relaxed).is_err() {
            for _ in 0..backoff {
                core::hint::spin_loop();
            }
            backoff = (backoff << 1).min(128);
        }
        SpinLockGuard { shared_core: self }
    }
}

pub struct SpinLockGuard<'a, K, V> {
    shared_core: &'a SharedCore<K, V>,
}

impl<'a, K, V> core::ops::Deref for SpinLockGuard<'a, K, V> {
    type Target = CoreCache<K, V>;
    #[inline(always)]
    fn deref(&self) -> &Self::Target {
        unsafe { &*self.shared_core.core.get() }
    }
}

impl<'a, K, V> core::ops::DerefMut for SpinLockGuard<'a, K, V> {
    #[inline(always)]
    fn deref_mut(&mut self) -> &mut Self::Target {
        unsafe { &mut *self.shared_core.core.get() }
    }
}

impl<'a, K, V> Drop for SpinLockGuard<'a, K, V> {
    #[inline(always)]
    fn drop(&mut self) {
        self.shared_core.lock.store(false, Ordering::Release);
    }
}
