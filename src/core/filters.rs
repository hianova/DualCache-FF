use crate::core::storage::Node;
use ::core::sync::atomic::{AtomicPtr, Ordering};
use alloc::boxed::Box;
use alloc::vec::Vec;
use core::ptr;
#[doc = " T1 — Global Fast Tier: direct-mapped L3 filter."]
#[doc = ""]
#[doc = " Each slot stores a raw pointer to the most recently seen node for"]
#[doc = " that hash bucket. Slot assignment is pure bitmask: `hash & mask`."]
#[doc = " Collisions simply overwrite; no chaining, no locks."]
#[repr(C, align(64))]
pub struct T1<K, V> {
    pub(crate) mask: usize,
    pub(crate) slots: Box<[AtomicPtr<Node<K, V>>]>,
}
unsafe impl<K: Send, V: Send> Send for T1<K, V> {}
unsafe impl<K: Send + Sync, V: Send + Sync> Sync for T1<K, V> {}
impl<K, V> T1<K, V> {
    pub fn new(slots_count: usize) -> Self {
        let mut slots = Vec::with_capacity(slots_count);
        for _ in 0..slots_count {
            slots.push(AtomicPtr::new(ptr::null_mut()));
        }
        Self {
            mask: slots_count - 1,
            slots: slots.into_boxed_slice(),
        }
    }
    #[inline(always)]
    pub fn load_slot(&self, hash: u64) -> *mut Node<K, V> {
        let idx = hash as usize & self.mask;
        self.slots[idx].load(Ordering::Acquire)
    }
    #[inline(always)]
    pub fn store_slot(&self, hash: u64, ptr: *mut Node<K, V>) {
        let idx = hash as usize & self.mask;
        self.slots[idx].store(ptr, Ordering::Release);
    }
    #[inline(always)]
    pub fn clear_if_matches(&self, hash: u64, expected_ptr: *mut Node<K, V>) {
        let idx = hash as usize & self.mask;
        let _ = self.slots[idx].compare_exchange(
            expected_ptr,
            ptr::null_mut(),
            Ordering::Release,
            Ordering::Relaxed,
        );
    }
    #[inline(always)]
    pub fn clear_at(&self, idx: usize) {
        self.slots[idx].store(ptr::null_mut(), Ordering::Relaxed);
    }
    #[inline(always)]
    pub fn len(&self) -> usize {
        self.slots.len()
    }
    #[inline(always)]
    pub fn is_empty(&self) -> bool {
        self.len() == 0
    }
}
#[doc = " T2 — Warm tier: direct-mapped L4 filter (intercepts warm data)."]
#[doc = ""]
#[doc = " Structurally identical to T1 but sized differently (20% of capacity)."]
#[doc = " Logically separated so future experiments can apply different policies"]
#[doc = " (e.g., T2 uses CLOCK-Pro promotion while T1 uses LRU-hot demotion)."]
#[repr(C, align(64))]
pub struct T2<K, V> {
    pub(crate) mask: usize,
    pub(crate) slots: Box<[AtomicPtr<Node<K, V>>]>,
}
unsafe impl<K: Send, V: Send> Send for T2<K, V> {}
unsafe impl<K: Send + Sync, V: Send + Sync> Sync for T2<K, V> {}
impl<K, V> T2<K, V> {
    pub fn new(slots_count: usize) -> Self {
        let mut slots = Vec::with_capacity(slots_count);
        for _ in 0..slots_count {
            slots.push(AtomicPtr::new(ptr::null_mut()));
        }
        Self {
            mask: slots_count - 1,
            slots: slots.into_boxed_slice(),
        }
    }
    #[inline(always)]
    pub fn load_slot(&self, hash: u64) -> *mut Node<K, V> {
        let idx = hash as usize & self.mask;
        self.slots[idx].load(Ordering::Acquire)
    }
    #[inline(always)]
    pub fn store_slot(&self, hash: u64, ptr: *mut Node<K, V>) {
        let idx = hash as usize & self.mask;
        self.slots[idx].store(ptr, Ordering::Release);
    }
    #[inline(always)]
    pub fn clear_if_matches(&self, hash: u64, expected_ptr: *mut Node<K, V>) {
        let idx = hash as usize & self.mask;
        let _ = self.slots[idx].compare_exchange(
            expected_ptr,
            ptr::null_mut(),
            Ordering::Release,
            Ordering::Relaxed,
        );
    }
    #[inline(always)]
    pub fn clear_at(&self, idx: usize) {
        self.slots[idx].store(ptr::null_mut(), Ordering::Relaxed);
    }
    #[inline(always)]
    pub fn len(&self) -> usize {
        self.slots.len()
    }
    #[inline(always)]
    pub fn is_empty(&self) -> bool {
        self.len() == 0
    }
}
