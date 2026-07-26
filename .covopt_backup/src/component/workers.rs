use core::cell::UnsafeCell;
use core::mem::MaybeUninit;
use std::vec::Vec;
#[doc = " Zero-allocation batch buffer: fixed-size MaybeUninit array, reused in-place."]
#[doc = " No Mutex, no Vec, no heap allocation on the hot path."]
#[doc = ""]
#[doc = " Cache-line aligned to prevent false sharing between worker slots."]
#[cfg_attr(any(target_arch = "aarch64", target_arch = "arm"), repr(C, align(128)))]
#[cfg_attr(
    not(any(target_arch = "aarch64", target_arch = "arm")),
    repr(C, align(64))
)]
pub struct BatchBuf<K, V> {
    items: [MaybeUninit<(K, V, u64)>; 32],
    len: usize,
}
impl<K, V> BatchBuf<K, V> {
    pub fn new() -> Self {
        Self {
            items: unsafe { MaybeUninit::uninit().assume_init() },
            len: 0,
        }
    }
}
impl<K, V> Default for BatchBuf<K, V> {
    fn default() -> Self {
        Self::new()
    }
}
impl<K, V> BatchBuf<K, V> {
    #[doc = " Returns `true` when the buffer is full (32 items) and should be flushed."]
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
    #[doc = " Drains all items into a `Vec`, resetting the buffer."]
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
#[doc = " Per-worker exclusive slot holding a `BatchBuf` inside an `UnsafeCell`."]
#[doc = ""]
#[doc = " The WORKER_ID TLS invariant guarantees that only one thread ever accesses"]
#[doc = " any given slot, eliminating the need for any synchronisation primitive on"]
#[doc = " the insert hot-path (zero atomics, zero locks, pure memory write)."]
#[cfg_attr(any(target_arch = "aarch64", target_arch = "arm"), repr(C, align(128)))]
#[cfg_attr(
    not(any(target_arch = "aarch64", target_arch = "arm")),
    repr(C, align(64))
)]
pub struct WorkerSlot<K, V> {
    inner: UnsafeCell<BatchBuf<K, V>>,
}
impl<K, V> WorkerSlot<K, V> {
    pub fn new() -> Self {
        Self {
            inner: UnsafeCell::new(BatchBuf::new()),
        }
    }
}
impl<K, V> Default for WorkerSlot<K, V> {
    fn default() -> Self {
        Self::new()
    }
}
impl<K, V> WorkerSlot<K, V> {
    #[doc = " Provides exclusive access to the underlying buffer."]
    #[doc = ""]
    #[doc = " # Safety"]
    #[doc = " The caller must guarantee that only one thread accesses this slot at a time."]
    #[doc = " In DualCache-FF this is enforced by the WORKER_ID TLS invariant."]
    #[inline(always)]
    pub unsafe fn get_mut_unchecked(&self) -> *mut BatchBuf<K, V> {
        self.inner.get()
    }
}
unsafe impl<K: Send, V: Send> Send for WorkerSlot<K, V> {}
unsafe impl<K: Send + Sync, V: Send + Sync> Sync for WorkerSlot<K, V> {}
