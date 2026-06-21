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
    items: [MaybeUninit<(K, V, u64, bool)>; 32],
    len: usize,
}

impl<K, V> Default for BatchBuf<K, V> {
    fn default() -> Self {
        Self::new()
    }
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
    pub fn push(&mut self, item: (K, V, u64, bool)) -> bool {
        if self.len >= 32 {
            return true;
        }
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
    pub fn drain_to_vec(&mut self) -> Vec<(K, V, u64, bool)> {
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
pub struct WorkerSlot<K, V> {
    inner: UnsafeCell<BatchBuf<K, V>>,
}

impl<K, V> Default for WorkerSlot<K, V> {
    fn default() -> Self {
        Self::new()
    }
}

impl<K, V> WorkerSlot<K, V> {
    pub fn new() -> Self {
        Self {
            inner: UnsafeCell::new(BatchBuf::new()),
        }
    }

    /// Provides exclusive access to the underlying buffer.
    ///
    /// # Safety
    /// The caller must guarantee that only one thread accesses this slot at a time.
    /// In DualCache-FF this is enforced by the WORKER_ID TLS invariant.
    #[inline(always)]
    #[allow(clippy::mut_from_ref)]
    pub unsafe fn get_mut_unchecked(&self) -> &mut BatchBuf<K, V> {
        self.inner.with_mut(|ptr| unsafe { &mut *ptr })
    }

    /// Safe accessor that encapsulates the `unsafe` block.
    /// In DualCache-FF this is safe because it's only called by the assigned worker thread.
    #[inline(always)]
    #[allow(clippy::mut_from_ref)]
    pub fn get_mut_safe(&self) -> &mut BatchBuf<K, V> {
        unsafe { self.get_mut_unchecked() }
    }
}

unsafe impl<K: Send, V: Send> Send for WorkerSlot<K, V> {}
unsafe impl<K: Send + Sync, V: Send + Sync> Sync for WorkerSlot<K, V> {}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_worker_slot_default() {
        let _slot: WorkerSlot<String, String> = Default::default();
    }

    #[test]
    fn test_batch_buf_push_and_drain() {
        let mut buf = BatchBuf::<i32, String>::new();
        assert!(buf.is_empty());
        assert_eq!(buf.len(), 0);

        // Push 31 items
        for i in 0..31 {
            assert!(!buf.push((i, i.to_string(), i as u64, false)));
        }
        assert_eq!(buf.len(), 31);
        assert!(!buf.is_empty());

        // Push 32nd item should return true (full)
        assert!(buf.push((31, "31".to_string(), 31, false)));
        assert_eq!(buf.len(), 32);

        // Push 33rd item should be protected by the OOB guard and return true immediately
        assert!(buf.push((32, "32".to_string(), 32, false)));
        assert_eq!(buf.len(), 32); // Still 32!

        let batch = buf.drain_to_vec();
        assert_eq!(batch.len(), 32);
        assert!(buf.is_empty());
        
        for (i, item) in batch.into_iter().enumerate() {
            assert_eq!(item.0, i as i32);
        }
    }

    #[test]
    fn test_worker_slot_safe_access() {
        let slot: WorkerSlot<i32, i32> = WorkerSlot::new();
        let buf = slot.get_mut_safe();
        assert!(buf.is_empty());
        
        buf.push((1, 1, 1, false));
        assert_eq!(buf.len(), 1);
        
        let buf2 = unsafe { slot.get_mut_unchecked() };
        assert_eq!(buf2.len(), 1);
        buf2.drain_to_vec();
        assert!(buf2.is_empty());
    }

    #[test]
    fn test_batch_buf_drop() {
        use std::sync::atomic::{AtomicUsize, Ordering};
        static DROP_COUNT: AtomicUsize = AtomicUsize::new(0);

        struct DropItem;
        impl Drop for DropItem {
            fn drop(&mut self) {
                DROP_COUNT.fetch_add(1, Ordering::Relaxed);
            }
        }

        {
            let mut buf = BatchBuf::<i32, DropItem>::new();
            buf.push((1, DropItem, 1, false));
            buf.push((2, DropItem, 2, false));
            // buf dropped here
        }
        assert_eq!(DROP_COUNT.load(Ordering::Relaxed), 2);
    }
}
