use super::arena::Arena;
use super::cache_tier::CacheTier;
use super::config::{CachePolicy, DefaultExponentialPolicy};
use super::qsbr::Guard;
use ahash::RandomState;
use core::hash::Hash;
#[doc = " The independent orchestrator that glues T0, T1, and T2 together."]
#[doc = " Designed for `no_std` environments."]
#[repr(C, align(64))]
pub struct DualCacheCore<
    K,
    V,
    P: CachePolicy = DefaultExponentialPolicy,
    const T0_CAP: usize = 64,
    const T1_CAP: usize = 4096,
    const T2_CAP: usize = 262144,
    const TOTAL_CAP: usize = { 64 + 4096 + 262144 },
> {
    arena: Arena<K, V, TOTAL_CAP>,
    pub t0: CacheTier<K, V, T0_CAP, 8>,
    pub t1: CacheTier<K, V, T1_CAP, 8>,
    pub t2: CacheTier<K, V, T2_CAP, 8>,
    hash_builder: RandomState,
    _marker: core::marker::PhantomData<P>,
}
#[doc = " A default configured Bottom-Up Anchoring DualCacheCore"]
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
            t0: CacheTier::new(),
            t1: CacheTier::new(),
            t2: CacheTier::new(),
            hash_builder: ahash::RandomState::with_seeds(1, 2, 3, 4),
            _marker: core::marker::PhantomData,
        }
    }
    #[inline(always)]
    pub fn hash_key(&self, key: &K) -> usize {
        self.hash_builder.hash_one(key) as usize
    }
    #[doc = " Retrieve a value from the core, cascading through T0 -> T1 -> T2."]
    #[doc = " Performs internal promotion synchronously if thresholds are reached."]
    #[allow(path_statements)]
    pub fn get<'g>(&self, key: &K, guard: &'g Guard) -> Option<(&'g V, u8)>
    where
        K: PartialEq + core::hash::Hash + Clone,
        V: Clone,
    {
        let hash = self.hash_key(key);
        if let Some(slot) = self.t0.get_slot(&self.arena, hash, key, guard) {
            slot.record_hit();
            P::_ASSERT_POWER_OF_TWO;
            let (_, node_idx) = slot.read(guard);
            if node_idx != super::arena::NULL_INDEX {
                let node = unsafe { self.arena.get(node_idx as usize) };
                let val_ptr = &node.value as *const V;
                return Some((unsafe { &*val_ptr }, 0));
            }
        }
        if let Some(slot) = self.t1.get_slot(&self.arena, hash, key, guard) {
            let (old_hits, new_hits) = slot.record_hit();
            let (_, node_idx) = slot.read(guard);
            if node_idx != super::arena::NULL_INDEX {
                let node = unsafe { self.arena.get(node_idx as usize) };
                if old_hits < P::T0_THRESHOLD && new_hits >= P::T0_THRESHOLD {
                    self.t0.insert(
                        &self.arena,
                        hash,
                        node.key.clone(),
                        node.value.clone(),
                        guard.node(),
                    );
                }
                let val_ptr = &node.value as *const V;
                return Some((unsafe { &*val_ptr }, 1));
            }
        }
        if let Some(slot) = self.t2.get_slot(&self.arena, hash, key, guard) {
            let (old_hits, new_hits) = slot.record_hit();
            let (_, node_idx) = slot.read(guard);
            if node_idx != super::arena::NULL_INDEX {
                let node = unsafe { self.arena.get(node_idx as usize) };
                if old_hits < P::T1_THRESHOLD && new_hits >= P::T1_THRESHOLD {
                    self.t1.insert(
                        &self.arena,
                        hash,
                        node.key.clone(),
                        node.value.clone(),
                        guard.node(),
                    );
                }
                let val_ptr = &node.value as *const V;
                return Some((unsafe { &*val_ptr }, 2));
            }
        }
        None
    }
    #[doc = " Put directly into T0 (Fast Pass)"]
    pub fn put_t0(&self, key: K, value: V, node: *mut super::qsbr::ThreadStateNode) {
        let hash = self.hash_key(&key);
        self.t0.insert(&self.arena, hash, key, value, node);
    }
    #[doc = " Put a key-value pair directly into T2."]
    #[doc = " This is typically called by the Daemon when promoting from TLS (LocalArena) to Core."]
    pub fn put(&self, key: K, value: V, node: *mut super::qsbr::ThreadStateNode) {
        let hash = self.hash_key(&key);
        self.t2.insert(&self.arena, hash, key, value, node);
    }
    pub fn try_reclaim(&self, node: *mut super::qsbr::ThreadStateNode) {
        super::qsbr::try_reclaim(node, |idx| unsafe {
            let local_free = &mut *(*node).local_free.get();
            if !local_free.push(idx) {
                self.arena.free(idx as usize);
            }
        });
    }
    #[doc = " Record a remote hit for an item based on its hash."]
    #[doc = " Used by the Daemon to propagate TLS hits into the global T2 cache."]
    pub fn record_remote_hit(&self, hash: usize, _weight: u8) {
        let set = self.t2.get_set(hash);
        for i in 0..8 {
            let slot = unsafe { set.get_unchecked(i) };
            if slot.hash.load(::core::sync::atomic::Ordering::Relaxed) == hash {
                let new_hits = 8;
                slot.hits
                    .store(new_hits, ::core::sync::atomic::Ordering::Relaxed);
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
    use crate::core::config::CachePolicy;
    use crate::core::qsbr;
    struct TestPolicy;
    impl CachePolicy for TestPolicy {
        type Evict = crate::core::policy::DefaultEvictionPolicy;
        const T2_THRESHOLD: u16 = 2;
        const T1_THRESHOLD: u16 = 4;
        const T0_THRESHOLD: u16 = 8;
    }
    #[test]
    fn test_comprehensive_cache_flow() {
        let core = DualCacheCore::<u64, u64, TestPolicy, 8, 8, 8, 24>::default();
        let thread_node = unsafe {
            static mut TEST_NODE: qsbr::ThreadStateNode = qsbr::ThreadStateNode::new();
            let node = &raw mut TEST_NODE as *mut _;
            qsbr::register_node(node);
            node
        };
        let guard = qsbr::pin(thread_node);
        assert_eq!(core.get(&100, &guard), None);
        core.put(100, 200, thread_node);
        assert_eq!(core.get(&100, &guard), Some((&200, 2)));
        assert_eq!(core.get(&100, &guard), Some((&200, 2)));
        core.try_reclaim(thread_node);
    }
    #[test]
    fn test_cache_miss_and_eviction() {
        let core = DualCacheCore::<u64, u64, TestPolicy, 8, 8, 8, 24>::default();
        let thread_node = unsafe {
            static mut TEST_NODE: qsbr::ThreadStateNode = qsbr::ThreadStateNode::new();
            let node = &raw mut TEST_NODE as *mut _;
            qsbr::register_node(node);
            node
        };
        let guard = qsbr::pin(thread_node);
        core.put(1, 10, thread_node);
        core.put(2, 20, thread_node);
        core.put(3, 30, thread_node);
        core.put(4, 40, thread_node);
        core.put(5, 50, thread_node);
        assert_eq!(core.get(&99, &guard), None);
    }
    #[test]
    fn test_put_t0_and_record_remote_hit() {
        let core = DualCacheCore::<u64, u64, TestPolicy, 8, 8, 8, 24>::default();
        let thread_node = unsafe {
            static mut TEST_NODE: qsbr::ThreadStateNode = qsbr::ThreadStateNode::new();
            let node = &raw mut TEST_NODE as *mut _;
            qsbr::register_node(node);
            node
        };
        let guard = qsbr::pin(thread_node);
        core.put_t0(300, 400, thread_node);
        assert_eq!(core.get(&300, &guard), Some((&400, 0)));
        core.put(500, 600, thread_node);
        let hash = core.hash_key(&500);
        core.record_remote_hit(hash, 5);
        assert_eq!(core.get(&500, &guard), Some((&600, 2)));
    }
    #[test]
    fn test_cache_core_t1_t0_hits() {
        let core = DualCacheCore::<u64, u64, TestPolicy, 8, 8, 8, 24>::default();
        let thread_node = unsafe {
            static mut TEST_NODE: qsbr::ThreadStateNode = qsbr::ThreadStateNode::new();
            let node = &raw mut TEST_NODE as *mut _;
            qsbr::register_node(node);
            node
        };
        let guard = qsbr::pin(thread_node);
        let hash1 = core.hash_key(&1000);
        core.t1.insert(&core.arena, hash1, 1000, 2000, thread_node);
        assert_eq!(core.get(&1000, &guard), Some((&2000, 1)));
        let hash0 = core.hash_key(&3000);
        core.t0.insert(&core.arena, hash0, 3000, 4000, thread_node);
        assert_eq!(core.get(&3000, &guard), Some((&4000, 0)));
        let _slot = core.t1.get_slot(&core.arena, hash1, &1000, &guard).unwrap();
    }
}
