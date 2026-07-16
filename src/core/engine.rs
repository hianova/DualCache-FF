use crate::core::arena::Arena;
use crate::core::cache_tier::{CacheTier, FastTier};
use crate::core::config::{CachePolicy, DefaultExponentialPolicy};
use crate::core::qsbr::Guard;
use ahash::RandomState;
use core::hash::Hash;

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
    pub t2: CacheTier<K, V, P::Evict, T2_CAP, 8>,
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
    pub fn new(eviction: P::Evict) -> Self {
        Self {
            arena: Arena::new(),
            t0: FastTier::new(),
            t1: FastTier::new(),
            t2: CacheTier::new(eviction),
            blackjack: crate::core::blackjack::PackedBlackjack::new(
                crate::covopt_param!("T0_THRESH", P::T0_THRESHOLD, 1..1000),
                crate::covopt_param!("T1_THRESH", P::T1_THRESHOLD, 1..100),
                crate::covopt_param!("T2_THRESH", P::T2_THRESHOLD, 1..50),
                crate::covopt_param!("WARMUP_THRESH", 256, 1..2000),
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
    pub fn get_t0<'g>(
        &self,
        hash: usize,
        key: &K,
        _guard: &'g Guard,
        _op_count: u32,
    ) -> Option<&'g V> {
        let node_idx = self.t0.get_slot_idx(hash);
        if node_idx != crate::core::arena::NULL_INDEX {
            let node = unsafe { self.arena.get(node_idx as usize) };
            if node.key == *key {
                return Some(unsafe { &*(&node.value as *const V) });
            }
        }
        None
    }

    #[inline(always)]
    pub fn get_t1<'g>(
        &self,
        hash: usize,
        key: &K,
        _guard: &'g Guard,
        _op_count: u32,
    ) -> Option<&'g V> {
        let node_idx = self.t1.get_slot_idx(hash);
        if node_idx != crate::core::arena::NULL_INDEX {
            let node = unsafe { self.arena.get(node_idx as usize) };
            if node.key == *key {
                return Some(unsafe { &*(&node.value as *const V) });
            }
        }
        None
    }

    #[inline(always)]
    #[allow(clippy::type_complexity)]
    pub fn get_t2<'g>(
        &'g self,
        hash: usize,
        key: &K,
        guard: &'g crate::core::qsbr::Guard,
        op_count: u32,
    ) -> Option<(&'g V, u8, Option<(K, V)>)> {
        let (_t0_thresh, t1_thresh, _, _) = self.blackjack.load_params();

        // T0
        if let Some(val) = self.get_t0(hash, key, guard, op_count) {
            return Some((val, 0, None));
        }

        // T1
        let t1_idx = self.t1.get_slot_idx(hash);
        if t1_idx != crate::core::arena::NULL_INDEX {
            let node = unsafe { self.arena.get(t1_idx as usize) };
            if node.key == *key {
                return Some((unsafe { &*(&node.value as *const V) }, 1, None));
            }
        }

        // T2
        if let Some(slot) = self.t2.get_slot(&self.arena, hash, key, guard) {
            let (old_hits, new_hits) = slot.record_hit(op_count);
            let hint = slot
                .prefetch_hint
                .load(::core::sync::atomic::Ordering::Relaxed);
            let hint_kv = if hint != 0 {
                self.t2.fetch_hint(hint, &self.arena, guard)
            } else {
                None
            };

            let node = unsafe { self.arena.get(slot.read(guard).1 as usize) };
            if old_hits < t1_thresh && new_hits >= t1_thresh {
                // Promote to T1
                unsafe {
                    self.t1.insert_promote(
                        &self.arena,
                        hash,
                        key.clone(),
                        node.value.clone(),
                        guard.node(),
                    );
                }
            }
            return Some((unsafe { &*(&node.value as *const V) }, 2, hint_kv));
        }
        None
    }

    #[inline(never)]
    #[allow(clippy::type_complexity)]
    pub fn get<'g>(
        &'g self,
        key: &K,
        guard: &'g Guard,
        op_count: u32,
    ) -> Option<(&'g V, u8, Option<(K, V)>)> {
        #[repr(align(64))]
        struct CachePadded;
        let _pad = CachePadded;

        mod core {
            pub mod intrinsics {
                pub use crate::utils::likely;
            }
        }

        let hash = self.hash_key(key);
        let res = self.get_t2(hash, key, guard, op_count);

        if core::intrinsics::likely(res.is_some()) {
            return res;
        }
        None
    }

    #[allow(clippy::not_unsafe_ptr_arg_deref)]
    pub fn put_t0(&self, key: K, value: V, node: *mut crate::core::qsbr::ThreadStateNode) {
        if crate::utils::likely(true) {
            let hash = self.hash_key(&key);
            unsafe {
                self.t0.insert_promote(&self.arena, hash, key, value, node);
            }
        }
    }

    #[allow(clippy::not_unsafe_ptr_arg_deref)]
    pub fn put_t1(&self, key: K, value: V, node: *mut crate::core::qsbr::ThreadStateNode) {
        if crate::utils::likely(true) {
            let hash = self.hash_key(&key);
            unsafe {
                self.t1.insert_promote(&self.arena, hash, key, value, node);
            }
        }
    }

    #[inline(never)]
    pub fn put(&self, key: K, value: V, node: *mut crate::core::qsbr::ThreadStateNode, _op_count: u32) {
        let hash = self.hash_key(&key);
        self.t2.insert(&self.arena, hash, key, value, node);
    }

    pub fn try_reclaim(&self, _node: *mut crate::core::qsbr::ThreadStateNode) {
        // Reclamation is now handled exclusively by the Daemon using daemon_reclaim closure
    }

    /// Synchronous inline reclamation for Lock-based caches (e.g., StaticDualCache)
    /// that do not have a background daemon thread. MUST ONLY be called when protected
    /// by a Mutex to avoid data races on the single-consumer QSBR garbage queues.
    pub fn sync_reclaim(&self) {
        crate::core::qsbr::daemon_reclaim(|batch| {
            if batch.is_empty() {
                return;
            }
            unsafe {
                for i in 0..batch.len() {
                    let idx = batch[i];
                    self.arena.drop_node(idx as usize);
                    if i < batch.len() - 1 {
                        self.arena.set_next_free(idx, batch[i + 1]);
                    }
                }
                self.arena.free_batch(batch[0], batch[batch.len() - 1]);
            }
        });
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
                slot.prefetch_hint
                    .store(next_hash, ::core::sync::atomic::Ordering::Relaxed);
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
        Self::new(P::Evict::default())
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::core::config::CachePolicy;
    use crate::core::qsbr;

    // A test policy that forces 2^n thresholds but smaller values for quick testing
    struct TestPolicy;
    impl CachePolicy for TestPolicy {
        type Evict = crate::core::policy::DefaultEvictionPolicy;
        const T2_THRESHOLD: u16 = 2;
        const T1_THRESHOLD: u16 = 4;
        const T0_THRESHOLD: u16 = 8;
    }

    #[test]
    fn test_comprehensive_cache_flow() {
        let core = DualCacheCore::<
            u64,
            u64,
            crate::core::config::DefaultExponentialPolicy,
            8,
            8,
            8,
            24,
        >::default();
        static mut TEST_NODE: qsbr::ThreadStateNode = qsbr::ThreadStateNode::new();
        let thread_node = {
            let node = &raw mut TEST_NODE as *mut _;
            qsbr::register_node(node);
            node
        };
        let guard = qsbr::pin(thread_node);

        core.put(100, 200, thread_node, 0);
        core.put_t1(300, 400, thread_node);
        assert_eq!(core.get(&300, &guard, 0), Some((&400, 1, None)));

        core.put_t0(500, 600, thread_node);
        assert_eq!(core.get(&500, &guard, 0), Some((&600, 0, None)));
    }

    #[test]
    fn test_t0_promotion_flow() {
        let core = DualCacheCore::<u64, u64, TestPolicy, 8, 8, 8, 24>::default();
        static mut TEST_NODE: qsbr::ThreadStateNode = qsbr::ThreadStateNode::new();
        let thread_node = {
            let node = &raw mut TEST_NODE as *mut _;
            qsbr::register_node(node);
            node
        };
        let guard = qsbr::pin(thread_node);

        assert_eq!(core.get(&99, &guard, 0), None);

        core.put(300, 400, thread_node, 0);
        core.record_remote_hit(core.hash_key(&300), 10);
        assert_eq!(core.get(&300, &guard, 0), Some((&400, 2, None)));

        core.put_t0(500, 600, thread_node);
        assert_eq!(core.get(&500, &guard, 0), Some((&600, 0, None)));
    }

    #[test]
    fn test_tier_fallbacks() {
        let core = DualCacheCore::<u64, u64, TestPolicy, 8, 8, 8, 24>::default();
        static mut TEST_NODE: qsbr::ThreadStateNode = qsbr::ThreadStateNode::new();
        let thread_node = {
            let node = &raw mut TEST_NODE as *mut _;
            qsbr::register_node(node);
            node
        };
        let guard = qsbr::pin(thread_node);

        let hash1 = core.hash_key(&1000);
        unsafe {
            core.t1
                .insert_promote(&core.arena, hash1, 1000, 2000, thread_node);
        }
        assert_eq!(core.get(&1000, &guard, 0), Some((&2000, 1, None)));

        let hash0 = core.hash_key(&3000);
        unsafe {
            core.t0
                .insert_promote(&core.arena, hash0, 3000, 4000, thread_node);
        }
        assert_eq!(core.get(&3000, &guard, 0), Some((&4000, 0, None)));

        let idx = core.t1.get_slot_idx(hash1);
        assert_ne!(idx, crate::core::arena::NULL_INDEX);
    }
}
