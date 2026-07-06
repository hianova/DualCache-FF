use crate::componant::arena::Arena;
use crate::componant::cache_tier::{CacheTier, FastTier};
use crate::componant::config::{CachePolicy, DefaultExponentialPolicy};
use crate::componant::qsbr::Guard;
use ahash::RandomState;
use core::hash::{BuildHasher, Hash};

/// The independent orchestrator that glues T0, T1, and T2 together.
/// Designed for `no_std` environments.
#[repr(align(64))]
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
    pub blackjack: crate::core::blackjack::PackedBlackjack,
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
            blackjack: crate::core::blackjack::PackedBlackjack::new(
                P::T0_THRESHOLD,
                P::T1_THRESHOLD,
                P::T2_THRESHOLD,
                256,
            ),
            hash_builder: ahash::RandomState::with_seeds(
                0x1234567890ABCDEF,
                0xFEDCBA0987654321,
                0x13579BDF02468ACE,
                0xECA86420FDB97531,
            ),
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
    pub fn get_t2<'g>(&'g self, hash: usize, key: &K, guard: &'g crate::componant::qsbr::Guard, op_count: u32) -> Option<(&'g V, u8, Option<(K, V)>)> {
        let (t0_thresh, t1_thresh, _, _) = self.blackjack.load_params();

        // T0
        if let Some(val) = self.get_t0(hash, key, guard, op_count) {
            return Some((val, 0, None));
        }

        // T1
        let t1_idx = self.t1.get_slot_idx(hash);
        if t1_idx != crate::componant::arena::NULL_INDEX {
            let node = unsafe { self.arena.get(t1_idx as usize) };
            if node.key == *key {
                return Some((unsafe { &*(&node.value as *const V) }, 1, None));
            }
        }

        // T2
        if let Some(slot) = self.t2.get_slot(&self.arena, hash, key, guard) {
            let (old_hits, new_hits) = slot.record_hit(op_count);
            let hint = slot.prefetch_hint.load(::core::sync::atomic::Ordering::Relaxed);
            let hint_kv = if hint != 0 {
                self.t2.fetch_hint(hint, &self.arena, guard)
            } else {
                None
            };
            
            let node = unsafe { self.arena.get(slot.read(guard).1 as usize) };
            if old_hits < t1_thresh as u16 && new_hits >= t1_thresh as u16 {
                // Promote to T1
                self.t1.insert_promote(&self.arena, hash, key.clone(), node.value.clone(), guard.node());
            }
            return Some((unsafe { &*(&node.value as *const V) }, 2, hint_kv));
        }
        None
    }

    #[inline(never)]
    pub fn get<'g>(&'g self, key: &K, guard: &'g Guard, op_count: u32) -> Option<(&'g V, u8, Option<(K, V)>)> {
        #[repr(align(64))]
        struct CachePadded;
        let _pad = CachePadded;

        mod core {
            pub mod intrinsics {
                pub use crate::utils::likely;
                pub use crate::utils::unlikely;
            }
        }

        let hash = self.hash_key(key);
        let res = self.get_t2(hash, key, guard, op_count);
        
        if core::intrinsics::likely(res.is_some()) {
            return res;
        }
        None
    }

    pub fn put_t0(&self, key: K, value: V, node: *mut crate::componant::qsbr::ThreadStateNode) {
        if crate::utils::likely(true) {
            let hash = self.hash_key(&key);
            self.t0.insert_promote(&self.arena, hash, key, value, node);
        }
    }

    pub fn put_t1(&self, key: K, value: V, node: *mut crate::componant::qsbr::ThreadStateNode) {
        if crate::utils::likely(true) {
            let hash = self.hash_key(&key);
            self.t1.insert_promote(&self.arena, hash, key, value, node);
        }
    }

    pub fn put(&self, key: K, value: V, node: *mut crate::componant::qsbr::ThreadStateNode) {
        if crate::utils::likely(true) {
            let hash = self.hash_key(&key);
            self.t2.insert(&self.arena, hash, key, value, node);
        }
    }

    pub fn try_reclaim(&self, _node: *mut crate::componant::qsbr::ThreadStateNode) {
        // Reclamation is now handled exclusively by the Daemon using daemon_reclaim closure
    }

    /// Record a remote hit for an item based on its hash.
    /// Used by the Daemon to propagate TLS hits into the global T2 cache.
    pub fn record_remote_hit(&self, hash: usize, _weight: u8) {
        let set = self.t2.get_set(hash);
        for i in 0..8 {
            let slot = unsafe { set.get_unchecked(i) };
            if slot.hash.load(::core::sync::atomic::Ordering::Relaxed) == hash {
                let old_hits = slot.hits.load(::core::sync::atomic::Ordering::Relaxed);
                let new_hits = old_hits.saturating_add(_weight as u16);
                slot.hits
                    .store(new_hits, ::core::sync::atomic::Ordering::Relaxed);
                break;
            }
        }
    }

    pub fn set_prefetch_hint(&self, hash: usize, next_hash: usize) {
        let set = self.t2.get_set(hash);
        for i in 0..8 {
            let slot = unsafe { set.get_unchecked(i) };
            if slot.hash.load(::core::sync::atomic::Ordering::Relaxed) == hash {
                slot.prefetch_hint.store(next_hash, ::core::sync::atomic::Ordering::Relaxed);
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
        static mut TEST_NODE: qsbr::ThreadStateNode = qsbr::ThreadStateNode::new();
        let thread_node = unsafe {
            qsbr::register_node(core::ptr::addr_of_mut!(TEST_NODE));
            core::ptr::addr_of_mut!(TEST_NODE)
        };
        let guard = qsbr::pin(thread_node);

        assert_eq!(core.get(&100, &guard, 0), None);

        core.put(100, 200, thread_node);
        assert_eq!(core.get(&100, &guard, 0), Some((&200, 2, None)));

        core.put_t1(300, 400, thread_node);
        assert_eq!(core.get(&300, &guard, 0), Some((&400, 1, None)));

        core.put_t0(500, 600, thread_node);
        assert_eq!(core.get(&500, &guard, 0), Some((&600, 0, None)));
    }

    #[test]
    fn test_t0_promotion_flow() {
        let core = DualCacheCore::<u64, u64, TestPolicy, 8, 8, 8, 24>::default();
        static mut TEST_NODE: qsbr::ThreadStateNode = qsbr::ThreadStateNode::new();
        let thread_node = unsafe {
            qsbr::register_node(core::ptr::addr_of_mut!(TEST_NODE));
            core::ptr::addr_of_mut!(TEST_NODE)
        };
        let guard = qsbr::pin(thread_node);

        assert_eq!(core.get(&99, &guard, 0), None);

        core.put(300, 400, thread_node);
        core.record_remote_hit(core.hash_key(&300), 10);
        assert_eq!(core.get(&300, &guard, 0), Some((&400, 2, None)));

        core.put_t0(500, 600, thread_node);
        assert_eq!(core.get(&500, &guard, 0), Some((&600, 0, None)));
    }

    #[test]
    fn test_tier_fallbacks() {
        let core = DualCacheCore::<u64, u64, TestPolicy, 8, 8, 8, 24>::default();
        static mut TEST_NODE: qsbr::ThreadStateNode = qsbr::ThreadStateNode::new();
        let thread_node = unsafe {
            qsbr::register_node(core::ptr::addr_of_mut!(TEST_NODE));
            core::ptr::addr_of_mut!(TEST_NODE)
        };
        let guard = qsbr::pin(thread_node);

        let hash1 = core.hash_key(&1000);
        core.t1.insert_promote(&core.arena, hash1, 1000, 2000, thread_node);
        assert_eq!(core.get(&1000, &guard, 0), Some((&2000, 1, None)));

        let hash0 = core.hash_key(&3000);
        core.t0.insert_promote(&core.arena, hash0, 3000, 4000, thread_node);
        assert_eq!(core.get(&3000, &guard, 0), Some((&4000, 0, None)));

        let idx = core.t1.get_slot_idx(hash1);
        assert_ne!(idx, crate::componant::arena::NULL_INDEX);
    }
}
