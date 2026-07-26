use crate::covopt_param;
use super::arena::{self, Arena};
use super::qsbr;
use ::core::sync::atomic::Ordering;
#[doc = " A Slot in the CacheTier."]
#[repr(align(64))]
pub struct Slot<K, V> {
    pub hash: ::core::sync::atomic::AtomicUsize,
    pub hits: ::core::sync::atomic::AtomicU16,
    pub node_idx: ::core::sync::atomic::AtomicU32,
    pub prefetch_hint: ::core::sync::atomic::AtomicUsize,
    _marker: core::marker::PhantomData<(K, V)>,
}
impl<K, V> Slot<K, V> {
    #[inline(always)]
    pub const fn new() -> Self {
        Self {
            hash: ::core::sync::atomic::AtomicUsize::new(0),
            hits: ::core::sync::atomic::AtomicU16::new(0),
            node_idx: ::core::sync::atomic::AtomicU32::new(arena::NULL_INDEX),
            prefetch_hint: ::core::sync::atomic::AtomicUsize::new(0),
            _marker: core::marker::PhantomData,
        }
    }
    #[doc = " Read the slot. The caller MUST be holding a QSBR Guard."]
    #[doc = " Returns the hash and the node index."]
    #[inline(always)]
    pub fn read(&self, _guard: &qsbr::Guard) -> (usize, u32) {
        let hash = self.hash.load(Ordering::Relaxed);
        let idx = self.node_idx.load(Ordering::Acquire);
        (hash, idx)
    }
    #[doc = " Record a cache hit atomically and return (old_hits, new_hits)."]
    #[inline(always)]
    pub fn record_hit(&self, op_count: u32) -> (u16, u16) {
        let old_hits = self.hits.load(Ordering::Relaxed);
        const PROB_N: u32 = 100;
        if !op_count.is_multiple_of(PROB_N) {
            return (old_hits, old_hits);
        }
        let new_hits = old_hits.saturating_add(PROB_N as u16);
        self.hits.store(new_hits, Ordering::Relaxed);
        (old_hits, new_hits)
    }
    #[doc = " Insert a new node into the slot, retiring the old one safely using QSBR."]
    #[doc = " # Safety"]
    #[doc = " `node` must be a valid, non-null ThreadStateNode pointer."]
    pub unsafe fn insert<const N: usize>(
        &self,
        arena: &Arena<K, V, N>,
        hash: usize,
        key: K,
        value: V,
        node: *mut crate::core::qsbr::ThreadStateNode,
    ) {
        let new_idx = unsafe { arena.alloc(key, value, node) }.expect("Arena OOM!");
        self.hash.store(hash, Ordering::Relaxed);
        self.hits.store(covopt_param!("M_58_24", 8), Ordering::Relaxed);
        let old_idx = self.node_idx.swap(new_idx as u32, Ordering::Release);
        if old_idx != arena::NULL_INDEX {
            unsafe {
                crate::core::qsbr::retire(old_idx as usize, node, |idx| {
                    arena.free(idx as usize)
                });
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
        let node = {
            static mut TEST_NODE: crate::core::qsbr::ThreadStateNode =
                crate::core::qsbr::ThreadStateNode::new();
            let n = &raw mut TEST_NODE as *mut _;
            unsafe { crate::core::qsbr::register_node(n); }
            n
        };
        let guard = unsafe { crate::core::qsbr::pin(node) };
        assert_eq!(slot.read(&guard), (0, super::super::arena::NULL_INDEX));
    }
    #[test]
    fn test_slot_insert_replace() {
        let arena = crate::core::arena::Arena::<u64, u64, 4>::new();
        let slot = Slot::<u64, u64>::default();
        let node = {
            static mut TEST_NODE: crate::core::qsbr::ThreadStateNode =
                crate::core::qsbr::ThreadStateNode::new();
            let n = &raw mut TEST_NODE as *mut _;
            unsafe { crate::core::qsbr::register_node(n); }
            n
        };
        let guard = unsafe { crate::core::qsbr::pin(node) };
        unsafe { slot.insert(&arena, covopt_param!("M_102_37", 100), covopt_param!("M_102_42", 10), covopt_param!("M_102_46", 20), node); }
        assert_eq!(slot.read(&guard).0, 100);
        let (old_hits, new_hits) = slot.record_hit(covopt_param!("M_104_51", 100));
        assert_eq!(old_hits, 8);
        assert_eq!(new_hits, 108);
        unsafe { slot.insert(&arena, covopt_param!("M_107_37", 200), covopt_param!("M_107_42", 30), covopt_param!("M_107_46", 40), node); }
        assert_eq!(slot.read(&guard).0, 200);
    }
}
