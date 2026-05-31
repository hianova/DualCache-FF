#[cfg(not(feature = "std"))]
use alloc::vec::Vec;

use crate::sync::cell::UnsafeCell;
use core::mem::MaybeUninit;

/// Zero-allocation batch buffer: fixed-size MaybeUninit array, reused in-place.
/// No Mutex, no Vec, no heap allocation on the hot path.
///
/// Cache-line aligned to prevent false sharing between worker slots.
#[cfg_attr(any(target_arch = "aarch64", target_arch = "arm"), repr(C, align(128)))]
#[cfg_attr(not(any(target_arch = "aarch64", target_arch = "arm")), repr(C, align(64)))]
pub struct BatchBuf<K, V> {
    items: [MaybeUninit<(K, V, u64)>; 32],
    len: usize,
}

impl<K, V> BatchBuf<K, V> {
    pub fn new() -> Self {
        Self {
            items: [const { MaybeUninit::uninit() }; 32],
            len: 0,
        }
    }

    /// Returns `true` when the buffer is full (32 items) and should be flushed.
    #[inline(always)]
    pub fn push(&mut self, item: (K, V, u64)) -> bool {
        self.items[self.len] = MaybeUninit::new(item);
        self.len += 1;
        self.len == 32
    }

    pub fn len(&self) -> usize {
        self.len
    }

    pub fn is_empty(&self) -> bool {
        self.len == 0
    }

    /// Drains all items into a `Vec`, resetting the buffer.
    pub fn drain_to_vec(&mut self) -> Vec<(K, V, u64)> {
        let mut batch = Vec::with_capacity(self.len);
        for i in 0..self.len {
            batch.push(unsafe { self.items[i].assume_init_read() });
        }
        self.len = 0;
        batch
    }
}

impl<K, V> Drop for BatchBuf<K, V> {
    fn drop(&mut self) {
        for i in 0..self.len {
            unsafe {
                self.items[i].assume_init_drop();
            }
        }
    }
}

unsafe impl<K: Send, V: Send> Send for BatchBuf<K, V> {}
unsafe impl<K: Sync, V: Sync> Sync for BatchBuf<K, V> {}

/// Per-worker exclusive slot holding a `BatchBuf` inside an `UnsafeCell`.
///
/// The WORKER_ID TLS invariant guarantees that only one thread ever accesses
/// any given slot, eliminating the need for any synchronisation primitive on
/// the insert hot-path (zero atomics, zero locks, pure memory write).
#[cfg_attr(any(target_arch = "aarch64", target_arch = "arm"), repr(C, align(128)))]
#[cfg_attr(not(any(target_arch = "aarch64", target_arch = "arm")), repr(C, align(64)))]
#[cfg(not(any(feature = "loom", loom)))]
pub struct WorkerSlot<K, V> {
    inner: UnsafeCell<BatchBuf<K, V>>,
}

#[cfg(any(feature = "loom", loom))]
pub struct WorkerSlot<K, V> {
    inner: UnsafeCell<Box<BatchBuf<K, V>>>,
}

impl<K, V> WorkerSlot<K, V> {
    #[cfg(not(any(feature = "loom", loom)))]
    pub fn new() -> Self {
        Self {
            inner: UnsafeCell::new(BatchBuf::new()),
        }
    }

    #[cfg(any(feature = "loom", loom))]
    pub fn new() -> Self {
        Self {
            inner: UnsafeCell::new(Box::new(BatchBuf::new())),
        }
    }

    /// Provides exclusive access to the underlying buffer.
    ///
    /// # Safety
    /// The caller must guarantee that only one thread accesses this slot at a time.
    /// In DualCache-FF this is enforced by the WORKER_ID TLS invariant.
    #[inline(always)]
    #[cfg(not(any(feature = "loom", loom)))]
    pub unsafe fn get_mut_unchecked(&self) -> &mut BatchBuf<K, V> {
        self.inner.with_mut(|ptr| unsafe { &mut *ptr })
    }

    /// Provides exclusive access to the underlying buffer.
    ///
    /// # Safety
    /// The caller must guarantee that only one thread accesses this slot at a time.
    /// In DualCache-FF this is enforced by the WORKER_ID TLS invariant.
    #[inline(always)]
    #[cfg(any(feature = "loom", loom))]
    pub unsafe fn get_mut_unchecked(&self) -> &mut BatchBuf<K, V> {
        self.inner.with_mut(|ptr| unsafe { &mut **ptr })
    }

    /// Safe accessor that encapsulates the `unsafe` block.
    /// In DualCache-FF this is safe because it's only called by the assigned worker thread.
    #[inline(always)]
    pub fn get_mut_safe(&self) -> &mut BatchBuf<K, V> {
        unsafe { self.get_mut_unchecked() }
    }
}

unsafe impl<K: Send, V: Send> Send for WorkerSlot<K, V> {}
unsafe impl<K: Send + Sync, V: Send + Sync> Sync for WorkerSlot<K, V> {}
