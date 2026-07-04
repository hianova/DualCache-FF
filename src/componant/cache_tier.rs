use super::slot::Slot;
use super::qsbr;
use super::arena::{self, Arena};
use super::policy::{EvictionPolicy, DefaultEvictionPolicy};

/// Represents a single cache tier (e.g., T0, T1, T2) using Set-Associative Lock-Free arrays.
#[repr(C, align(64))]
pub struct CacheTier<K, V, P: EvictionPolicy = DefaultEvictionPolicy, const CAPACITY: usize = 0, const WAYS: usize = 8> {
    slots: [Slot<K, V>; CAPACITY],
    policy: P,
}

impl<K, V, P: EvictionPolicy, const CAPACITY: usize, const WAYS: usize> CacheTier<K, V, P, CAPACITY, WAYS> {
    /// Create a new `CacheTier`.
    #[must_use]
    pub const fn new(policy: P) -> Self {
        assert!(CAPACITY > 0, "CAPACITY must be greater than 0");
        assert!(CAPACITY.is_multiple_of(WAYS), "CAPACITY must be a multiple of WAYS");

        Self { 
            slots: [const { Slot::new() }; CAPACITY],
            policy,
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

    /// Insert a key and value into the tier using the provided eviction policy.
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
        
        // 2. Use EvictionPolicy to find victim and perform decay
        let victim_slot = self.policy.find_victim(set, hash);

        // 3. Evict the victim
        victim_slot.insert(arena, hash, key, value, node);
    }
}

impl<K, V, const CAPACITY: usize, const WAYS: usize> Default for CacheTier<K, V, DefaultEvictionPolicy, CAPACITY, WAYS> {
    fn default() -> Self {
        Self::new(DefaultEvictionPolicy::new())
    }
}


#[cfg(test)]
mod tests {
    use super::*;
    use crate::componant::arena::Arena;
    use crate::componant::qsbr;

    #[test]
    fn test_cache_tier_eviction() {
        // CAPACITY=8, WAYS=8 means 1 set, 8 slots.
        let tier = CacheTier::<u64, u64, crate::componant::policy::DefaultEvictionPolicy, 8, 8>::new(crate::componant::policy::DefaultEvictionPolicy::new());
        let arena = Arena::<u64, u64, 16>::new();
        let node = {
            let node = std::boxed::Box::into_raw(std::boxed::Box::new(crate::componant::qsbr::ThreadStateNode::new()));
            crate::componant::qsbr::register_node(node);
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
        let tier: CacheTier<u64, u64, crate::componant::policy::DefaultEvictionPolicy, 8, 8> = CacheTier::default();
        let set = tier.get_set(0);
        assert_eq!(set.len(), 8);
    }
}

/// A direct-mapped (1-way) fast tier optimized for T0 zero-cost lookups.
/// It uses exactly 1 atomic load for maximum throughput.
#[repr(C, align(64))]
pub struct FastTier<const CAPACITY: usize> {
    slots: [core::sync::atomic::AtomicU32; CAPACITY],
}

impl<const CAPACITY: usize> FastTier<CAPACITY> {
    pub const fn new() -> Self {
        assert!(CAPACITY > 0 && CAPACITY.is_power_of_two(), "CAPACITY must be a power of two");
        let mut slots = [const { core::sync::atomic::AtomicU32::new(super::arena::NULL_INDEX) }; CAPACITY];
        Self { slots }
    }

    #[inline(always)]
    pub fn get_slot_idx(&self, hash: usize) -> u32 {
        let mask = CAPACITY - 1;
        let idx = hash & mask;
        self.slots[idx].load(core::sync::atomic::Ordering::Acquire)
    }

    #[inline(always)]
    pub fn insert_idx(&self, hash: usize, node_idx: u32) -> u32 {
        let mask = CAPACITY - 1;
        let idx = hash & mask;
        self.slots[idx].swap(node_idx, core::sync::atomic::Ordering::Release)
    }

    pub fn insert_promote<K, V, const N: usize>(&self, arena: &super::arena::Arena<K, V, N>, hash: usize, key: K, value: V, node: *mut super::qsbr::ThreadStateNode) {
        if let Some(new_idx) = arena.alloc(key, value, node) {
            let old_idx = self.insert_idx(hash, new_idx as u32);
            if old_idx != super::arena::NULL_INDEX {
                unsafe {
                    let local_free = &mut *(*node).local_free.get();
                    if !local_free.push(old_idx) {
                        arena.free(old_idx as usize);
                    }
                }
            }
        }
    }
    
    pub fn clear(&self) {
        for slot in self.slots.iter() {
            slot.store(super::arena::NULL_INDEX, core::sync::atomic::Ordering::Relaxed);
        }
    }
}
