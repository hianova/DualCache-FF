use super::arena::{self, Arena};
use super::policy::{DefaultEvictionPolicy, EvictionPolicy};
use super::qsbr;
use super::slot::Slot;
#[doc = " Represents a single cache tier (e.g., T0, T1, T2) using Set-Associative Lock-Free arrays."]
#[repr(C, align(64))]
pub struct CacheTier<
    K,
    V,
    P: EvictionPolicy = DefaultEvictionPolicy,
    const CAPACITY: usize = 0,
    const WAYS: usize = 8,
> {
    slots: [Slot<K, V>; CAPACITY],
    tags: alloc::boxed::Box<[::core::sync::atomic::AtomicU8]>,
    policy: P,
}
impl<K, V, P: EvictionPolicy, const CAPACITY: usize, const WAYS: usize>
    CacheTier<K, V, P, CAPACITY, WAYS>
{
    #[doc = " Create a new `CacheTier`."]
    #[must_use]
    pub fn new(policy: P) -> Self {
        assert!(CAPACITY > 0, "CAPACITY must be greater than 0");
        assert!(
            CAPACITY.is_multiple_of(WAYS),
            "CAPACITY must be a multiple of WAYS"
        );
        let mut tags = alloc::vec::Vec::with_capacity(CAPACITY);
        for _ in 0..CAPACITY {
            tags.push(::core::sync::atomic::AtomicU8::new(0));
        }
        Self {
            slots: [const { Slot::new() }; CAPACITY],
            tags: tags.into_boxed_slice(),
            policy,
        }
    }
    #[doc = " Retrieve the set of slots for a given hash."]
    #[inline(always)]
    pub fn get_set(&self, hash: usize) -> &[Slot<K, V>] {
        let num_sets = CAPACITY / WAYS;
        let index = hash % num_sets;
        let start = index * WAYS;
        unsafe { self.slots.get_unchecked(start..start + WAYS) }
    }
    #[doc = " Touch a slot by hash to prevent it from being evicted (Prefetch hint)"]
    #[inline(always)]
    pub fn fetch_hint<const N: usize>(
        &self,
        hash: usize,
        arena: &super::arena::Arena<K, V, N>,
        guard: &super::qsbr::Guard,
    ) -> Option<(K, V)>
    where
        K: Clone,
        V: Clone,
    {
        let set = self.get_set(hash);
        for slot in set {
            let (slot_hash, idx) = slot.read(guard);
            if slot_hash == hash && idx != super::arena::NULL_INDEX {
                let node = unsafe { arena.get(idx as usize) };
                return Some((node.key.clone(), node.value.clone()));
            }
        }
        None
    }
    #[doc = " Retrieve a slot if the key exists in this tier."]
    #[inline(always)]
    pub fn get_slot<const N: usize>(
        &self,
        arena: &Arena<K, V, N>,
        hash: usize,
        key: &K,
        guard: &qsbr::Guard,
    ) -> Option<&Slot<K, V>>
    where
        K: PartialEq,
    {
        let num_sets = CAPACITY / WAYS;
        let index = hash % num_sets;
        let start = index * WAYS;
        let expected_tag = ((hash >> 16) & 255) as u8;
        let mut match_mask = 0u8;
        for i in 0..WAYS {
            let tag = unsafe { self.tags.get_unchecked(start + i) }
                .load(::core::sync::atomic::Ordering::Relaxed);
            if tag == expected_tag {
                match_mask |= 1 << i;
            }
        }
        if match_mask == 0 {
            return None;
        }
        let set = self.get_set(hash);
        for (i, slot) in set.iter().enumerate() {
            if (match_mask & (1 << i)) != 0 {
                let (slot_hash, idx) = slot.read(guard);
                if slot_hash == hash && idx != arena::NULL_INDEX {
                    let node = unsafe { arena.get(idx as usize) };
                    if node.key == *key {
                        return Some(slot);
                    }
                }
            }
        }
        None
    }
    #[doc = " Insert a key and value into the tier using the provided eviction policy."]
    pub fn insert<const N: usize>(
        &self,
        arena: &Arena<K, V, N>,
        hash: usize,
        key: K,
        value: V,
        node: *mut super::qsbr::ThreadStateNode,
    ) where
        K: PartialEq,
    {
        let num_sets = CAPACITY / WAYS;
        let index = hash % num_sets;
        let start = index * WAYS;
        let set = self.get_set(hash);
        let guard = qsbr::pin(node);
        for (i, slot) in set.iter().enumerate() {
            let (slot_hash, idx) = slot.read(&guard);
            if idx == arena::NULL_INDEX {
                unsafe { self.tags.get_unchecked(start + i) }.store(
                    ((hash >> 16) & 255) as u8,
                    ::core::sync::atomic::Ordering::Relaxed,
                );
                slot.insert(arena, hash, key, value, node);
                return;
            }
            if slot_hash == hash {
                let node_data = unsafe { arena.get(idx as usize) };
                if node_data.key == key {
                    unsafe { self.tags.get_unchecked(start + i) }.store(
                        ((hash >> 16) & 255) as u8,
                        ::core::sync::atomic::Ordering::Relaxed,
                    );
                    slot.insert(arena, hash, key, value, node);
                    return;
                }
            }
        }
        let (victim_idx, victim_slot) = self.policy.find_victim_idx(set, hash);
        unsafe { self.tags.get_unchecked(start + victim_idx) }.store(
            ((hash >> 16) & 255) as u8,
            ::core::sync::atomic::Ordering::Relaxed,
        );
        victim_slot.insert(arena, hash, key, value, node);
    }
}
impl<K, V, const CAPACITY: usize, const WAYS: usize> Default
    for CacheTier<K, V, DefaultEvictionPolicy, CAPACITY, WAYS>
{
    fn default() -> Self {
        Self::new(DefaultEvictionPolicy::new())
    }
}
#[doc = " A direct-mapped (1-way) fast tier optimized for T0 zero-cost lookups."]
#[doc = " It uses exactly 1 atomic load for maximum throughput."]
#[repr(C, align(64))]
pub struct FastTier<const CAPACITY: usize> {
    slots: [AtomicU64; CAPACITY],
}
pub const NULL_PACKED: u64 = u64::MAX;
pub const IDX_MASK: u64 = 0x0000_0000_FFFF_FFFF;
impl<const CAPACITY: usize> Default for FastTier<CAPACITY> {
    fn default() -> Self {
        Self::new()
    }
}
use core::sync::atomic::AtomicU64;
impl<const CAPACITY: usize> FastTier<CAPACITY> {
    pub const fn new() -> Self {
        assert!(
            CAPACITY > 0 && CAPACITY.is_power_of_two(),
            "CAPACITY must be a power of two"
        );
        let slots = [const { AtomicU64::new(NULL_PACKED) }; CAPACITY];
        Self { slots }
    }
    #[doc = " Retrieve the slot index from the fast tier."]
    #[inline(always)]
    pub fn get_slot_idx(&self, hash: usize) -> u32 {
        let mask = CAPACITY - 1;
        let idx = hash & mask;
        let val = self.slots[idx].load(::core::sync::atomic::Ordering::Relaxed);
        let node_idx = val & IDX_MASK;
        let tag = val & 0xFFFFFFFF00000000;
        let expected_tag = (hash as u64) & 0xFFFFFFFF00000000;
        if node_idx == NULL_PACKED || tag != expected_tag {
            super::arena::NULL_INDEX
        } else {
            node_idx as u32
        }
    }
    #[inline(always)]
    pub fn insert_idx(&self, hash: usize, node_idx: u32) -> u32 {
        let mask = CAPACITY - 1;
        let idx = hash & mask;
        let new_val = if node_idx == super::arena::NULL_INDEX {
            NULL_PACKED
        } else {
            let tag = (hash as u64) & 0xFFFFFFFF00000000;
            tag | (node_idx as u64)
        };
        let old_val = self.slots[idx].swap(new_val, ::core::sync::atomic::Ordering::Release);
        let old_idx = old_val & IDX_MASK;
        if old_idx == NULL_PACKED {
            super::arena::NULL_INDEX
        } else {
            old_idx as u32
        }
    }
    #[doc = " # Safety"]
    #[doc = " The caller must ensure that `node` is a valid pointer to a ThreadStateNode"]
    #[doc = " and that the thread state is active."]
    pub unsafe fn insert_promote<K, V, const N: usize>(
        &self,
        arena: &super::arena::Arena<K, V, N>,
        hash: usize,
        key: K,
        value: V,
        node: *mut super::qsbr::ThreadStateNode,
    ) where
        K: PartialEq,
    {
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
            slot.store(NULL_PACKED, ::core::sync::atomic::Ordering::Relaxed);
        }
    }
}
#[cfg(test)]
mod tests {
    use super::*;
    use crate::core::arena::Arena;
    use crate::core::qsbr;
    #[test]
    fn test_cache_tier_eviction() {
        let tier = CacheTier::<u64, u64, crate::core::policy::DefaultEvictionPolicy, 8, 8>::new(
            crate::core::policy::DefaultEvictionPolicy::new(),
        );
        let arena = Arena::<u64, u64, 16>::new();
        let node = {
            let node = alloc::boxed::Box::into_raw(alloc::boxed::Box::new(
                crate::core::qsbr::ThreadStateNode::new(),
            ));
            crate::core::qsbr::register_node(node);
            node
        };
        let guard = qsbr::pin(node);
        for i in 0..8 {
            tier.insert(&arena, i as usize, i, i * 10, node);
        }
        tier.insert(&arena, 8, 8, 80, node);
        let mut count = 0;
        for i in 0..9 {
            if tier.get_slot(&arena, i as usize, &i, &guard).is_some() {
                count += 1;
            }
        }
        assert_eq!(count, 8);
    }
    #[test]
    fn test_cache_tier_default() {
        let tier: CacheTier<u64, u64, crate::core::policy::DefaultEvictionPolicy, 8, 8> =
            CacheTier::default();
        let set = tier.get_set(0);
        assert_eq!(set.len(), 8);
    }
    #[test]
    fn test_fast_tier_logic() {
        let t0: FastTier<64> = FastTier::new();
        let hash: usize = 0x123456789ABCDEF0;
        let old_idx = t0.insert_idx(hash, 42);
        assert_eq!(old_idx, super::super::arena::NULL_INDEX);
        let out_idx = t0.get_slot_idx(hash);
        assert_eq!(out_idx, 42);
        let bad_hash: usize = 0x876543219ABCDEF0;
        let out_miss = t0.get_slot_idx(bad_hash);
        assert_eq!(out_miss, super::super::arena::NULL_INDEX);
        t0.clear();
        assert_eq!(t0.get_slot_idx(hash), super::super::arena::NULL_INDEX);
    }
}
