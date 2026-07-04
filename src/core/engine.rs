use crate::componant::arena::Arena;
use crate::componant::cache_tier::{CacheTier, FastTier};
use crate::componant::config::{CachePolicy, DefaultExponentialPolicy};
use crate::componant::qsbr::Guard;
use ahash::RandomState;
use core::hash::{BuildHasher, Hash};

/// The independent orchestrator that glues T0, T1, and T2 together.
/// Designed for `no_std` environments.
pub struct DualCacheCore<
    K,
    V,
    P: CachePolicy = DefaultExponentialPolicy,
    const T0_CAP: usize = 64,
    const T1_CAP: usize = 4096,
    const T2_CAP: usize = 262144,
    const TOTAL_CAP: usize = { 64 + 4096 + 262144 },
> {
    pub arena: Arena<K, V, TOTAL_CAP>,
    pub t0: FastTier<T0_CAP>,
    pub t1: FastTier<T1_CAP>,
    pub t2: CacheTier<K, V, crate::componant::policy::DefaultEvictionPolicy, T2_CAP, 8>,
    hash_builder: RandomState,
    _marker: core::marker::PhantomData<P>,
}

/// A default configured Bottom-Up Anchoring DualCacheCore
pub type BottomUpCache<K, V> =
    DualCacheCore<K, V, DefaultExponentialPolicy, 64, 4096, 262144, { 64 + 4096 + 262144 }>;

impl<
    K,
    V,
    P: CachePolicy,
    const T0_CAP: usize,
    const T1_CAP: usize,
    const T2_CAP: usize,
    const TOTAL_CAP: usize,
> DualCacheCore<K, V, P, T0_CAP, T1_CAP, T2_CAP, TOTAL_CAP>
where
    K: Clone + Eq + Hash,
    V: Clone,
{
    pub const fn new() -> Self {
        Self {
            arena: Arena::new(),
            t0: FastTier::new(),
            t1: FastTier::new(),
            t2: CacheTier::new(crate::componant::policy::DefaultEvictionPolicy),
            hash_builder: ahash::RandomState::with_seeds(1, 2, 3, 4),
            _marker: core::marker::PhantomData,
        }
    }

    #[inline(always)]
    pub fn hash_key(&self, key: &K) -> usize {
        self.hash_builder.hash_one(key) as usize
    }

    #[inline(always)]
    pub fn get_t0<'g>(&self, hash: usize, key: &K, _guard: &'g Guard, _op_count: u32) -> Option<&'g V> {
        let node_idx = self.t0.get_slot_idx(hash);
        if node_idx != crate::componant::arena::NULL_INDEX {
            let node = unsafe { self.arena.get(node_idx as usize) };
            if node.key == *key {
                return Some(unsafe { &*(&node.value as *const V) });
            }
        }
        None
    }

    #[inline(always)]
    pub fn get_t1<'g>(&self, hash: usize, key: &K, _guard: &'g Guard, _op_count: u32) -> Option<&'g V> {
        let node_idx = self.t1.get_slot_idx(hash);
        if node_idx != crate::componant::arena::NULL_INDEX {
            let node = unsafe { self.arena.get(node_idx as usize) };
            if node.key == *key {
                return Some(unsafe { &*(&node.value as *const V) });
            }
        }
        None
    }

    #[inline(always)]
    pub fn get_t2<'g>(&self, hash: usize, key: &K, guard: &'g Guard, _op_count: u32) -> Option<&'g V> {
        if let Some(slot) = self.t2.get_slot(&self.arena, hash, key, guard) {
            let hits = slot.hits.fetch_add(1, crate::sync::atomic::Ordering::Relaxed) + 1;
            let node = unsafe { self.arena.get(slot.read(guard).1 as usize) };
            return Some(unsafe { &*(&node.value as *const V) });
        }
        None
    }

    pub fn get<'g>(&self, key: &K, guard: &'g Guard, op_count: u32) -> Option<(&'g V, u8)> {
        let hash = self.hash_key(key);

        if let Some(v) = self.get_t0(hash, key, guard, op_count) {
            return Some((v, 0));
        }

        if let Some(v) = self.get_t1(hash, key, guard, op_count) {
            return Some((v, 1));
        }

        if let Some(v) = self.get_t2(hash, key, guard, op_count) {
            return Some((v, 2));
        }

        None
    }

    pub fn put_t0(&self, key: K, value: V, node: *mut crate::componant::qsbr::ThreadStateNode) {
        if crate::sync::likely(true) {
            let hash = self.hash_key(&key);
            self.t0.insert_promote(&self.arena, hash, key, value, node);
        }
    }

    pub fn put(&self, key: K, value: V, node: *mut crate::componant::qsbr::ThreadStateNode) {
        if crate::sync::likely(true) {
            let hash = self.hash_key(&key);
            self.t2.insert(&self.arena, hash, key, value, node);
        }
    }

    pub fn try_reclaim(&self, node: *mut crate::componant::qsbr::ThreadStateNode) {
        crate::componant::qsbr::try_reclaim(node, |idx| unsafe {
            let local_free = &mut *(*node).local_free.get();
            if !local_free.push(idx) {
                self.arena.free(idx as usize);
            }
        });
    }

    /// Record a remote hit for an item based on its hash.
    /// Used by the Daemon to propagate TLS hits into the global T2 cache.
    pub fn record_remote_hit(&self, hash: usize, _weight: u8) {
        let set = self.t2.get_set(hash);
        for i in 0..8 {
            let slot = unsafe { set.get_unchecked(i) };
            if slot.hash.load(crate::sync::atomic::Ordering::Relaxed) == hash {
                let new_hits = 8;
                slot.hits
                    .store(new_hits, crate::sync::atomic::Ordering::Relaxed);
                break;
            }
        }
    }
}

impl<
    K,
    V,
    P: CachePolicy,
    const T0_CAP: usize,
    const T1_CAP: usize,
    const T2_CAP: usize,
    const TOTAL_CAP: usize,
> Default for DualCacheCore<K, V, P, T0_CAP, T1_CAP, T2_CAP, TOTAL_CAP>
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
    use crate::componant::config::CachePolicy;
    use crate::componant::qsbr;

    // A test policy that forces 2^n thresholds but smaller values for quick testing
    struct TestPolicy;
    impl CachePolicy for TestPolicy {
        const T2_THRESHOLD: u16 = 2;
        const T1_THRESHOLD: u16 = 4;
        const T0_THRESHOLD: u16 = 8;
    }

    #[test]
    fn test_comprehensive_cache_flow() {
        let core = DualCacheCore::<u64, u64, TestPolicy, 8, 8, 8, 24>::default();
        let thread_node = {
            let node = std::boxed::Box::into_raw(std::boxed::Box::new(qsbr::ThreadStateNode::new()));
            qsbr::register_node(node);
            node
        };
        let guard = qsbr::pin(thread_node);

        assert_eq!(core.get(&100, &guard, 0), None);

        core.put(100, 200, thread_node);

        assert_eq!(core.get(&100, &guard, 0), Some((&200, 2)));
    }

    #[test]
    fn test_t0_promotion_flow() {
        let core = DualCacheCore::<u64, u64, TestPolicy, 8, 8, 8, 24>::default();
        let thread_node = {
            let node = std::boxed::Box::into_raw(std::boxed::Box::new(qsbr::ThreadStateNode::new()));
            qsbr::register_node(node);
            node
        };
        let guard = qsbr::pin(thread_node);

        assert_eq!(core.get(&99, &guard, 0), None);

        core.put(300, 400, thread_node);
        core.record_remote_hit(core.hash_key(&300), 10);
        assert_eq!(core.get(&300, &guard, 0), Some((&400, 2)));

        core.put_t0(500, 600, thread_node);
        assert_eq!(core.get(&500, &guard, 0), Some((&600, 0)));
    }

    #[test]
    fn test_tier_fallbacks() {
        let core = DualCacheCore::<u64, u64, TestPolicy, 8, 8, 8, 24>::default();
        let thread_node = {
            let node = std::boxed::Box::into_raw(std::boxed::Box::new(qsbr::ThreadStateNode::new()));
            qsbr::register_node(node);
            node
        };
        let guard = qsbr::pin(thread_node);

        let hash1 = core.hash_key(&1000);
        core.t1.insert_promote(&core.arena, hash1, 1000, 2000, thread_node);
        assert_eq!(core.get(&1000, &guard, 0), Some((&2000, 1)));

        let hash0 = core.hash_key(&3000);
        core.t0.insert_promote(&core.arena, hash0, 3000, 4000, thread_node);
        assert_eq!(core.get(&3000, &guard, 0), Some((&4000, 0)));

        let idx = core.t1.get_slot_idx(hash1);
        assert_ne!(idx, crate::componant::arena::NULL_INDEX);
    }
}
