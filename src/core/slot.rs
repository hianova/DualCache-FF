use crate::sync::atomic::{AtomicUsize, AtomicU16, Ordering};
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
    pub fn read(&self, _guard: &qsbr::Guard) -> (usize, u16) {
        let hash = self.hash.load(Ordering::Relaxed);
        let idx = self.node_idx.load(Ordering::Acquire);
        (hash, idx)
    }

    /// Record a cache hit atomically and return (old_hits, new_hits).
    #[inline(always)]
    pub fn record_hit(&self) -> (u16, u16) {
        let current = self.hits.load(Ordering::Relaxed);
        let bonus = 3u16.saturating_add(current >> 4);
        let new_hits = current.saturating_add(bonus);
        self.hits.store(new_hits, Ordering::Relaxed);
        (current, new_hits)
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


#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_slot_default() {
        let slot: Slot<u64, u64> = Slot::default();
        let node = crate::core::qsbr::register_thread();
        let guard = crate::core::qsbr::pin(node);
        assert_eq!(slot.read(&guard), (0, super::super::arena::NULL_INDEX));
    }
}
