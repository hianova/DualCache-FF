use super::cache_tier::CacheTier;
use super::arena::Arena;
use super::qsbr::Guard;
use super::config::{CachePolicy, DefaultExponentialPolicy};
use core::hash::Hash;
use ahash::RandomState;

/// The independent orchestrator that glues T0, T1, and T2 together.
/// Designed for `no_std` environments. 
pub struct DualCacheCore<
    K, V,
    P: CachePolicy = DefaultExponentialPolicy,
    const T0_CAP: usize = 64,
    const T1_CAP: usize = 4096,
    const T2_CAP: usize = 262144,
    const TOTAL_CAP: usize = { 64 + 4096 + 262144 }
> {
    arena: Arena<K, V, TOTAL_CAP>,
    pub t0: CacheTier<K, V, T0_CAP, 4>,
    pub t1: CacheTier<K, V, T1_CAP, 4>,
    pub t2: CacheTier<K, V, T2_CAP, 4>,
    hash_builder: RandomState,
    _marker: core::marker::PhantomData<P>,
}

/// A default configured Bottom-Up Anchoring DualCacheCore
pub type BottomUpCache<K, V> = DualCacheCore<K, V, DefaultExponentialPolicy, 64, 4096, 262144, { 64 + 4096 + 262144 }>;

impl<K, V, P: CachePolicy, const T0_CAP: usize, const T1_CAP: usize, const T2_CAP: usize, const TOTAL_CAP: usize> 
    DualCacheCore<K, V, P, T0_CAP, T1_CAP, T2_CAP, TOTAL_CAP>

where 
    K: Clone + Eq + Hash,
    V: Clone,
{
    pub fn new() -> Self {
        Self {
            arena: Arena::new(),
            t0: CacheTier::new(),
            t1: CacheTier::new(),
            t2: CacheTier::new(),
            hash_builder: RandomState::new(),
            _marker: core::marker::PhantomData,
        }
    }

    #[inline(always)]
    pub fn hash_key(&self, key: &K) -> usize {
        self.hash_builder.hash_one(key) as usize
    }

    /// Retrieve a value from the core, cascading through T0 -> T1 -> T2.
    /// Performs internal promotion synchronously if thresholds are reached.
    #[allow(path_statements)]
    pub fn get<'g>(&self, key: &K, guard: &'g Guard) -> Option<(&'g V, u8)> 
    where
        K: PartialEq + core::hash::Hash + Clone,
        V: Clone,
    {
        let hash = self.hash_key(key);
        
        // 1. Check T0 (Royal Class - 1ns)
        if let Some(slot) = self.t0.get_slot(&self.arena, hash, key, guard) {
            slot.record_hit();
            P::_ASSERT_POWER_OF_TWO; // Ensure compile-time checks

            let (_, node_idx) = slot.read(guard);
            if node_idx != super::arena::NULL_INDEX {
                let node = unsafe { self.arena.get(node_idx as usize) };
                let val_ptr = &node.value as *const V;
                return Some((unsafe { &*val_ptr }, 0));
            }
        }

        // 2. Check T1 (Elite Class - 5ns)
        if let Some(slot) = self.t1.get_slot(&self.arena, hash, key, guard) {
            let hits = slot.record_hit();
            let (_, node_idx) = slot.read(guard);
            if node_idx != super::arena::NULL_INDEX {
                let node = unsafe { self.arena.get(node_idx as usize) };
                if hits == P::T0_THRESHOLD {
                    // Internal Promotion to T0
                    self.t0.insert(&self.arena, hash, node.key.clone(), node.value.clone(), guard.node());
                }
                let val_ptr = &node.value as *const V;
                return Some((unsafe { &*val_ptr }, 1));
            }
        }

        // 3. Check T2 (Middle Class - 15ns)
        if let Some(slot) = self.t2.get_slot(&self.arena, hash, key, guard) {
            let hits = slot.record_hit();
            let (_, node_idx) = slot.read(guard);
            if node_idx != super::arena::NULL_INDEX {
                let node = unsafe { self.arena.get(node_idx as usize) };
                if hits == P::T1_THRESHOLD {
                    // Internal Promotion to T1
                    self.t1.insert(&self.arena, hash, node.key.clone(), node.value.clone(), guard.node());
                }
                let val_ptr = &node.value as *const V;
                return Some((unsafe { &*val_ptr }, 2));
            }
        }

        // Missed in all core tiers.
        None
    }

    /// Put directly into T0 (Fast Pass)
    pub fn put_t0(&self, key: K, value: V, node: *mut super::qsbr::ThreadStateNode) {
        let hash = self.hash_key(&key);
        self.t0.insert(&self.arena, hash, key, value, node);
    }

    /// Put a key-value pair directly into T2.
    /// This is typically called by the Daemon when promoting from TLS (LocalArena) to Core.
    pub fn put(&self, key: K, value: V, node: *mut super::qsbr::ThreadStateNode) {
        let hash = self.hash_key(&key);
        self.t2.insert(&self.arena, hash, key, value, node);
    }

    /// Try to reclaim retired nodes and push them back to the Arena's free list.
    /// Should be called periodically by a background daemon.
    pub fn try_reclaim(&self, node: *mut super::qsbr::ThreadStateNode) {
        super::qsbr::try_reclaim(node, |idx| {
            unsafe { self.arena.free(idx as usize) };
        });
    }
}

impl<K, V, P: CachePolicy, const T0_CAP: usize, const T1_CAP: usize, const T2_CAP: usize, const TOTAL_CAP: usize> 
    Default for DualCacheCore<K, V, P, T0_CAP, T1_CAP, T2_CAP, TOTAL_CAP> 
where 
    K: Clone + Eq + Hash,
    V: Clone,
{
    fn default() -> Self {
        Self::new()
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::core::qsbr;
    use crate::core::config::CachePolicy;
    
    // A test policy that forces 2^n thresholds but smaller values for quick testing
    struct TestPolicy;
    impl CachePolicy for TestPolicy {
        const T2_THRESHOLD: u16 = 2;
        const T1_THRESHOLD: u16 = 4;
        const T0_THRESHOLD: u16 = 8;
    }

    #[test]
    fn test_comprehensive_cache_flow() {
        // T0=4, T1=4, T2=4 (WAYS=4, so they must be multiples of 4)
        let core = DualCacheCore::<u64, u64, TestPolicy, 4, 4, 4, 12>::default();
        let thread_node = qsbr::register_thread();
        let guard = qsbr::pin(thread_node);

        assert_eq!(core.get(&100, &guard), None);

        // Put into T2
        core.put(100, 200, thread_node);

        // Hit 1: Should be in T2
        assert_eq!(core.get(&100, &guard), Some((&200, 2)));

        // Hit 2, 3: Should still be in T2
        assert_eq!(core.get(&100, &guard), Some((&200, 2)));
        assert_eq!(core.get(&100, &guard), Some((&200, 2)));

        // Hit 4: T1_THRESHOLD is 4, triggers T2 -> T1
        assert_eq!(core.get(&100, &guard), Some((&200, 2)));

        // Let's verify it promoted to T1
        let hash = core.hash_key(&100);
        let t1_slot = core.t1.get_slot(&core.arena, hash, &100, &guard);
        assert!(t1_slot.is_some());

        // Hit 5, 6, 7, 8 in T1 (T0_THRESHOLD is 8, but it's hit 8 times total?)
        // Wait, when inserted into T1, its hit count starts at 0!
        // T0_THRESHOLD is 8, so it needs 8 more hits in T1.
        for _ in 0..7 {
            assert_eq!(core.get(&100, &guard), Some((&200, 1)));
        }

        // 8th hit in T1 triggers T1 -> T0 promotion
        assert_eq!(core.get(&100, &guard), Some((&200, 1)));

        let t0_slot = core.t0.get_slot(&core.arena, hash, &100, &guard);
        assert!(t0_slot.is_some());

        // Test QSBR reclaim
        core.try_reclaim(thread_node); // Should execute without panicking
    }

    #[test]
    fn test_cache_miss_and_eviction() {
        let core = DualCacheCore::<u64, u64, TestPolicy, 4, 4, 4, 12>::default();
        let thread_node = qsbr::register_thread();
        let guard = qsbr::pin(thread_node);

        // Force evictions in T2 by filling the set
        core.put(1, 10, thread_node);
        core.put(2, 20, thread_node);
        core.put(3, 30, thread_node);
        core.put(4, 40, thread_node);
        core.put(5, 50, thread_node);

        // Test some gets to hit the miss logic
        assert_eq!(core.get(&99, &guard), None);
    }
}
