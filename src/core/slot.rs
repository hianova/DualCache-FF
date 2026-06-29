use crate::sync::atomic::{AtomicUsize, AtomicU16, Ordering};
use core::ptr;
use super::qsbr;
use super::arena::{self, Arena};

/// A Slot in the CacheTier.
pub struct Slot<K, V> {
    pub hash: AtomicUsize,
    pub hits: AtomicU16,
    pub node_idx: AtomicU16,
    _marker: core::marker::PhantomData<(K, V)>,
}

impl<K, V> Slot<K, V> {
    #[inline(always)]
    pub fn new() -> Self {
        Self {
            hash: AtomicUsize::new(0),
            hits: AtomicU16::new(0),
            node_idx: AtomicU16::new(arena::NULL_INDEX),
            _marker: core::marker::PhantomData,
        }
    }

    /// Read the slot. The caller MUST be holding a QSBR Guard.
    /// Returns the hash and the node index.
    #[inline(always)]
    pub fn read<'g>(&self, _guard: &'g qsbr::Guard) -> (usize, u16) {
        let hash = self.hash.load(Ordering::Relaxed);
        let idx = self.node_idx.load(Ordering::Acquire);
        (hash, idx)
    }

    /// Record a cache hit atomically and return the new hit count.
    #[inline(always)]
    pub fn record_hit(&self) -> u16 {
        let hits = self.hits.load(Ordering::Relaxed).wrapping_add(1);
        self.hits.store(hits, Ordering::Relaxed);
        hits
    }

    /// Insert a new node into the slot, retiring the old one safely using QSBR.
    pub fn insert<const N: usize>(&self, arena: &Arena<K, V, N>, hash: usize, key: K, value: V, node: *mut crate::core::qsbr::ThreadStateNode) {
        if let Some(new_idx) = arena.alloc(key, value) {
            self.hash.store(hash, Ordering::Relaxed);
            self.hits.store(0, Ordering::Relaxed);
            let old_idx = self.node_idx.swap(new_idx as u16, Ordering::Release);
            if old_idx != arena::NULL_INDEX {
                crate::core::qsbr::retire(old_idx as usize, node);
            }
        }
    }
}

impl<K, V> Default for Slot<K, V> {
    fn default() -> Self {
        Self::new()
    }
}

