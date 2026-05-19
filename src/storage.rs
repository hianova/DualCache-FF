#[cfg(not(feature = "std"))]
use alloc::{boxed::Box, vec::Vec};

use crate::sync::atomic::{AtomicU64, AtomicPtr, Ordering};
use core::ptr;

/// A single cached entry. Stored in the Arena node pool.
pub struct Node<K, V> {
    pub key: K,
    pub value: V,
    /// Epoch at which this node expires (0 = no expiry).
    pub expire_at: u32,
    /// Index into the Arena / Cache node arrays.
    pub g_idx: u32,
}

/// L3 lock-free hash index + node pointer array.
///
/// `index` is a flat open-addressed array of packed `u64` entries:
///   bits[63:48] = 16-bit tag (hash >> 48)
///   bits[47:0]  = Arena slot index
/// Sentinel values: 0 = empty, u64::MAX = tombstone.
pub struct Cache<K, V> {
    pub(crate) index_mask: usize,
    pub(crate) index: Box<[AtomicU64]>,
    pub(crate) nodes: Box<[AtomicPtr<Node<K, V>>]>,
}

unsafe impl<K: Send, V: Send> Send for Cache<K, V> {}
unsafe impl<K: Send + Sync, V: Send + Sync> Sync for Cache<K, V> {}

impl<K, V> Cache<K, V> {
    pub fn new(capacity: usize) -> Self {
        let index_size = (capacity * 2).next_power_of_two();
        let mut index = Vec::with_capacity(index_size);
        for _ in 0..index_size {
            index.push(AtomicU64::new(0));
        }

        let mut nodes = Vec::with_capacity(capacity);
        for _ in 0..capacity {
            nodes.push(AtomicPtr::new(ptr::null_mut()));
        }

        Self {
            index_mask: index_size - 1,
            index: index.into_boxed_slice(),
            nodes: nodes.into_boxed_slice(),
        }
    }

    #[inline(always)]
    pub fn index_probe(&self, hash: u64, tag: u16) -> Option<usize> {
        let mut idx = hash as usize & self.index_mask;
        for _ in 0..16 {
            let entry = self.index[idx].load(Ordering::Acquire);
            if entry == 0 {
                return None;
            }
            if entry != u64::MAX && (entry >> 48) as u16 == tag {
                return Some((entry & 0x0000_FFFF_FFFF_FFFF) as usize);
            }
            idx = (idx + 1) & self.index_mask;
        }
        None
    }

    #[inline(always)]
    pub fn index_store(&self, hash: u64, tag: u16, entry: u64) {
        let mut idx = hash as usize & self.index_mask;
        for i in 0..16 {
            let prev = self.index[idx].load(Ordering::Acquire);
            if prev == 0 || prev == u64::MAX || (prev >> 48) == (tag as u64) {
                self.index[idx].store(entry, Ordering::Release);
                return;
            }
            if i == 15 {
                self.index[hash as usize & self.index_mask].store(entry, Ordering::Release);
            }
            idx = (idx + 1) & self.index_mask;
        }
    }

    #[inline(always)]
    pub fn index_remove(&self, hash: u64, tag: u16, g_idx: usize) {
        let mut idx = hash as usize & self.index_mask;
        for _ in 0..16 {
            let entry = self.index[idx].load(Ordering::Acquire);
            if entry == 0 {
                return;
            }
            if entry != u64::MAX
                && (entry >> 48) as u16 == tag
                && (entry & 0x0000_FFFF_FFFF_FFFF) == (g_idx as u64)
            {
                self.index[idx].store(u64::MAX, Ordering::Release);
                return;
            }
            idx = (idx + 1) & self.index_mask;
        }
    }

    #[inline(always)]
    pub fn index_clear_at(&self, idx: usize) {
        self.index[idx].store(0, Ordering::Relaxed);
    }

    #[inline(always)]
    pub fn index_len(&self) -> usize {
        self.index.len()
    }

    #[inline(always)]
    pub fn node_get_full(&self, idx: usize, key: &K, current_epoch: u32) -> Option<V>
    where
        K: Eq,
        V: Clone,
    {
        let ptr = self.nodes[idx].load(Ordering::Acquire);
        if ptr.is_null() {
            return None;
        }
        // Safety: QSBR guarantees pointer is valid during check-in.
        let node = unsafe { &*ptr };
        if node.key == *key {
            if node.expire_at > 0 && node.expire_at < current_epoch {
                return None;
            }
            Some(node.value.clone())
        } else {
            None
        }
    }

    pub fn clear(&self) {
        for i in 0..self.index.len() {
            self.index[i].store(0, Ordering::Relaxed);
        }
        for i in 0..self.nodes.len() {
            self.nodes[i].store(ptr::null_mut(), Ordering::Release);
        }
    }
}

impl<K, V> Drop for Cache<K, V> {
    fn drop(&mut self) {
        for node_ptr in self.nodes.iter() {
            let ptr = node_ptr.swap(ptr::null_mut(), Ordering::Relaxed);
            if !ptr.is_null() {
                unsafe {
                    let _ = Box::from_raw(ptr);
                }
            }
        }
    }
}
