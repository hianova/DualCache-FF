use super::slot::Slot;
use super::qsbr;
use super::arena::{self, Arena};

/// Represents a single cache tier (e.g., T0, T1, T2) using Set-Associative Lock-Free arrays.
pub struct CacheTier<K, V, const CAPACITY: usize, const WAYS: usize> {
    slots: [Slot<K, V>; CAPACITY],
}

impl<K, V, const CAPACITY: usize, const WAYS: usize> CacheTier<K, V, CAPACITY, WAYS> {
    /// Create a new `CacheTier`.
    #[must_use]
    pub fn new() -> Self {
        assert!(CAPACITY > 0, "CAPACITY must be greater than 0");
        assert!(CAPACITY.is_multiple_of(WAYS), "CAPACITY must be a multiple of WAYS");

        let slots = core::array::from_fn(|_| Slot::new());

        Self { slots }
    }

    /// Retrieve the set of slots for a given hash.
    #[inline(always)]
    pub fn get_set(&self, hash: usize) -> &[Slot<K, V>] {
        let num_sets = CAPACITY / WAYS;
        let index = hash % num_sets;
        let start = index * WAYS;
        unsafe {
            self.slots.get_unchecked(start..start + WAYS)
        }
    }

    /// Retrieve a slot if the key exists in this tier.
    #[inline(always)]
    pub fn get_slot<const N: usize>(&self, arena: &Arena<K, V, N>, hash: usize, key: &K, guard: &qsbr::Guard) -> Option<&Slot<K, V>>
    where
        K: PartialEq,
    {
        let set = self.get_set(hash);
        for slot in set {
            let (slot_hash, idx) = slot.read(guard);
            if slot_hash == hash && idx != arena::NULL_INDEX {
                let node = unsafe { arena.get(idx as usize) };
                if node.key == *key {
                    return Some(slot);
                }
            }
        }
        None
    }

    /// Insert a key and value into the tier using a simple Lossy collision replacement.
    pub fn insert<const N: usize>(&self, arena: &Arena<K, V, N>, hash: usize, key: K, value: V, node: *mut super::qsbr::ThreadStateNode)
    where
        K: PartialEq,
    {
        let set = self.get_set(hash);
        let guard = qsbr::pin(node);
        
        // 1. Try to find an empty slot or overwrite the exact matching key
        for slot in set {
            let (slot_hash, idx) = slot.read(&guard);
            if idx == arena::NULL_INDEX {
                slot.insert(arena, hash, key, value, node);
                return;
            }
            if slot_hash == hash {
                let node_data = unsafe { arena.get(idx as usize) };
                if node_data.key == key {
                    slot.insert(arena, hash, key, value, node);
                    return;
                }
            }
        }
        
        // If no matching key or empty slot was found, perform Ring Clock + Pseudo-LFU Eviction
        let mut min_hits = u16::MAX;
        let mut replace_idx = 0;
        
        for i in 0..WAYS {
            let slot = unsafe { set.get_unchecked(i) };
            let hits = slot.hits.load(crate::sync::atomic::Ordering::Relaxed);
            
            if hits < min_hits {
                min_hits = hits;
                replace_idx = i;
            }
            // Ring Clock Decay: Shift count right (decay by half)
            slot.hits.store(hits >> 1, crate::sync::atomic::Ordering::Relaxed);
        }
        
        unsafe { set.get_unchecked(replace_idx) }.insert(arena, hash, key, value, node);
    }
}

impl<K, V, const CAPACITY: usize, const WAYS: usize> Default for CacheTier<K, V, CAPACITY, WAYS> {
    fn default() -> Self {
        Self::new()
    }
}

