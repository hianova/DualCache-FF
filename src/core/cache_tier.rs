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
    pub const fn new() -> Self {
        assert!(CAPACITY > 0, "CAPACITY must be greater than 0");
        assert!(CAPACITY.is_multiple_of(WAYS), "CAPACITY must be a multiple of WAYS");

        Self { 
            slots: [const { Slot::new() }; CAPACITY] 
        }
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
        
        // If no matching key or empty slot was found, perform Pseudo-LFU Eviction
        let mut min_hits = u16::MAX;
        let mut candidates = [0; 8];
        let mut candidates_len = 0;
        
        for (i, slot) in set.iter().enumerate() {
            let hits = slot.hits.load(crate::sync::atomic::Ordering::Relaxed);
            if hits < min_hits {
                min_hits = hits;
                candidates_len = 0;
                candidates[candidates_len] = i;
                candidates_len += 1;
            } else if hits == min_hits && candidates_len < 8 {
                candidates[candidates_len] = i;
                candidates_len += 1;
            }
        }

        let victim_idx = if candidates_len > 1 {
            candidates[hash % candidates_len]
        } else {
            candidates[0]
        };

        // Clock-like decay
        if min_hits > 0 {
            for slot in set {
                let h = slot.hits.load(crate::sync::atomic::Ordering::Relaxed);
                slot.hits.store(h.saturating_sub(1), crate::sync::atomic::Ordering::Relaxed);
            }
        }

        // Evict the victim
        let victim_slot = unsafe { set.get_unchecked(victim_idx) };
        victim_slot.insert(arena, hash, key, value, node);
    }
}

impl<K, V, const CAPACITY: usize, const WAYS: usize> Default for CacheTier<K, V, CAPACITY, WAYS> {
    fn default() -> Self {
        Self::new()
    }
}


#[cfg(test)]
mod tests {
    use super::*;
    use crate::core::arena::Arena;
    use crate::core::qsbr;

    #[test]
    fn test_cache_tier_eviction() {
        // CAPACITY=8, WAYS=8 means 1 set, 8 slots.
        let tier = CacheTier::<u64, u64, 8, 8>::new();
        let arena = Arena::<u64, u64, 16>::new();
        let node = {
            let node = std::boxed::Box::into_raw(std::boxed::Box::new(crate::core::qsbr::ThreadStateNode::new()));
            crate::core::qsbr::register_node(node);
            node
        };
        let guard = qsbr::pin(node);

        // Fill all 8 slots
        for i in 0..8 {
            tier.insert(&arena, i as usize, i, i * 10, node);
        }

        // Insert 9th item to trigger eviction
        tier.insert(&arena, 8, 8, 80, node);

        // One of the first 8 should be evicted. Let's check how many remain.
        let mut count = 0;
        for i in 0..9 {
            if tier.get_slot(&arena, i as usize, &i, &guard).is_some() {
                count += 1;
            }
        }
        assert_eq!(count, 8); // One was evicted, leaving 8.
    }
    #[test]
    fn test_cache_tier_default() {
        let tier: CacheTier<u64, u64, 8, 8> = CacheTier::default();
        let set = tier.get_set(0);
        assert_eq!(set.len(), 8);
    }
}
