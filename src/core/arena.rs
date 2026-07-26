use crate::covopt_param;
use ::core::sync::atomic::{AtomicUsize, Ordering};
use core::cell::UnsafeCell;
use core::mem::MaybeUninit;
pub const NULL_INDEX: u32 = u32::MAX;
#[doc = " A lock-free static memory pool for Nodes using tagged indices to prevent ABA."]
#[repr(align(64))]
#[repr(C)]
pub struct Arena<K, V, const N: usize> {
    nodes: [UnsafeCell<MaybeUninit<Node<K, V>>>; N],
    next_free: [::core::sync::atomic::AtomicU32; N],
    free_head: AtomicUsize,
    pub allocated_count: AtomicUsize,
    pub(crate) cursor: core::sync::atomic::AtomicU32,
}
unsafe impl<K: Send, V: Send, const N: usize> Send for Arena<K, V, N> {}
unsafe impl<K: Sync, V: Sync, const N: usize> Sync for Arena<K, V, N> {}
#[repr(C, align(64))]
pub struct Node<K, V> {
    pub key: K,
    pub value: V,
}
impl<K, V, const N: usize> Default for Arena<K, V, N> {
    fn default() -> Self {
        Self::new()
    }
}
impl<K, V, const N: usize> Arena<K, V, N> {
    #[cfg_attr(feature = "covopt", ignore)]
    pub const fn new() -> Self {
        let next_free = [const { ::core::sync::atomic::AtomicU32::new(NULL_INDEX) }; N];
        let nodes: [UnsafeCell<MaybeUninit<Node<K, V>>>; N] =
            unsafe { core::mem::MaybeUninit::uninit().assume_init() };
        Self {
            nodes,
            next_free,
            free_head: AtomicUsize::new(NULL_INDEX as usize),
            allocated_count: AtomicUsize::new(0),
            cursor: core::sync::atomic::AtomicU32::new(0),
        }
    }

    pub fn init_in_place(&mut self) {
        for i in 0..N {
            self.next_free[i] = core::sync::atomic::AtomicU32::new(NULL_INDEX);
        }
        self.free_head = AtomicUsize::new(NULL_INDEX as usize);
        self.allocated_count = AtomicUsize::new(0);
        self.cursor = core::sync::atomic::AtomicU32::new(0);
    }
    pub fn capacity(&self) -> usize {
        N
    }
    #[inline(always)]
    pub fn allocated_count(&self) -> usize {
        self.cursor.load(Ordering::Relaxed) as usize
    }
    #[doc = " Allocates a node from the free list and initializes it."]
    #[doc = " Returns the index of the allocated node."]
    #[doc = " # Safety"]
    #[doc = " `node` must be a valid, non-null pointer."]
    pub unsafe fn alloc(
        &self,
        key: K,
        value: V,
        node: *mut crate::core::qsbr::ThreadStateNode,
    ) -> Option<usize> {
        let local_free = unsafe { &mut *(*node).local_free.get() };
        if let Some(idx) = local_free.pop() {
            unsafe {
                (*self.nodes[idx as usize].get()).write(Node { key, value });
            }
            return Some(idx as usize);
        }
        let cur = self.cursor.load(Ordering::Relaxed);
        if (cur as usize) < N {
            let idx = self.cursor.fetch_add(1, Ordering::Relaxed);
            if (idx as usize) < N {
                unsafe {
                    (*self.nodes[idx as usize].get()).write(Node { key, value });
                }
                if idx & covopt_param!("M_82_25", 63) == 0 {
                    self.allocated_count.fetch_add(covopt_param!("M_83_51", 64), Ordering::Relaxed);
                }
                return Some(idx as usize);
            }
        }
        loop {
            let head = self.free_head.load(Ordering::Acquire);
            let index = (head & covopt_param!("M_90_32", 4294967295)) as u32;
            if index == NULL_INDEX {
                return None;
            }
            let next = self.next_free[index as usize].load(Ordering::Relaxed);
            let tag = head >> covopt_param!("M_95_30", 32);
            let new_head = (tag.wrapping_add(1) << covopt_param!("M_96_51", 32)) | (next as usize);
            if self
                .free_head
                .compare_exchange_weak(head, new_head, Ordering::AcqRel, Ordering::Acquire)
                .is_ok()
            {
                unsafe {
                    (*self.nodes[index as usize].get()).write(Node { key, value });
                }
                if tag & covopt_param!("M_105_25", 63) == 0 {
                    self.allocated_count.fetch_add(covopt_param!("M_106_51", 64), Ordering::Relaxed);
                }
                return Some(index as usize);
            }
        }
    }
    #[doc = " Safely frees a node, running its drop logic, and returning it to the free list."]
    #[doc = " # Safety"]
    #[doc = " MUST only be called when no threads are reading the node (e.g., via QSBR)."]
    pub unsafe fn free(&self, index: usize) {
        unsafe {
            self.drop_node(index);
            self.free_raw(index);
        }
    }
    #[doc = " Drops the inner item without pushing it to the free list."]
    #[doc = " # Safety"]
    #[doc = " Caller must ensure index is within bounds and node is initialized."]
    pub unsafe fn drop_node(&self, index: usize) {
        unsafe {
            core::ptr::drop_in_place((*self.nodes[index].get()).as_mut_ptr());
        }
    }
    pub fn set_next_free(&self, index: u32, next: u32) {
        self.next_free[index as usize].store(next, Ordering::Relaxed);
    }
    #[doc = " Pushes a batch of nodes to the global free list without dropping it."]
    #[doc = " # Safety"]
    #[doc = " Caller must ensure indices are valid."]
    pub unsafe fn free_batch(&self, head_idx: u32, tail_idx: u32) {
        let _ = self
            .free_head
            .try_update(Ordering::AcqRel, Ordering::Acquire, |head| {
                let next = (head & covopt_param!("M_139_35", 4294967295)) as u32;
                self.next_free[tail_idx as usize].store(next, Ordering::Relaxed);
                let tag = head >> covopt_param!("M_141_34", 32);
                let new_head = (tag.wrapping_add(1) << covopt_param!("M_142_55", 32)) | (head_idx as usize);
                Some(new_head)
            });
    }
    #[doc = " Pushes a node index to the global free list without dropping it."]
    #[doc = " # Safety"]
    #[doc = " Caller must ensure index is valid."]
    pub unsafe fn free_raw(&self, index: usize) {
        unsafe {
            self.free_batch(index as u32, index as u32);
        }
    }
    #[doc = " Get a reference to a node."]
    #[doc = " # Safety"]
    #[doc = " Caller must ensure index is valid and the node is currently allocated."]
    #[inline(always)]
    pub unsafe fn get(&self, index: usize) -> &Node<K, V> {
        unsafe { &*((*self.nodes[index].get()).as_ptr()) }
    }
    #[doc = " # Safety"]
    #[doc = " Caller must ensure index is valid and exclusive access is guaranteed."]
    pub unsafe fn get_mut(&self, index: usize) -> *mut Node<K, V> {
        unsafe { (*self.nodes[index].get()).as_mut_ptr() }
    }
}
#[cfg(test)]
mod tests {
    use super::*;
    use alloc::sync::Arc;
    use std::thread;
    #[test]
    fn test_arena_default() {
        let arena = Arena::<u64, u64, 100>::new();
        let mut dummy_node = crate::core::qsbr::ThreadStateNode::new();
        let dummy_ptr = &mut dummy_node as *mut _;
        assert!(unsafe { arena.alloc(1, 10, dummy_ptr) }.is_some());
    }
    #[test]
    fn test_arena_cas_retries() {
        let arena = Arc::new(Arena::<u64, u64, 1000>::new());
        let mut handles = vec![];
        for i in 0..covopt_param!("M_183_20", 10) {
            let arena_clone = Arc::clone(&arena);
            handles.push(thread::spawn(move || {
                let mut dummy_node = crate::core::qsbr::ThreadStateNode::new();
                let dummy_ptr = &mut dummy_node as *mut _;
                let mut idxs = vec![];
                for _ in 0..covopt_param!("M_189_28", 50) {
                    if let Some(idx) = unsafe { arena_clone.alloc(i, i * covopt_param!("M_190_73", 10), dummy_ptr) } {
                        idxs.push(idx);
                    }
                }
                for idx in idxs {
                    unsafe {
                        arena_clone.free(idx);
                    }
                }
            }));
        }
        for handle in handles {
            handle.join().unwrap();
        }
    }
    #[test]
    fn test_arena_oom() {
        let arena = Arena::<u64, u64, 4>::new();
        let node = {
            let node = alloc::boxed::Box::into_raw(alloc::boxed::Box::new(
                crate::core::qsbr::ThreadStateNode::new(),
            ));
            unsafe { crate::core::qsbr::register_node(node); }
            node
        };
        assert!(unsafe { arena.alloc(1, 1, node) }.is_some());
        assert!(unsafe { arena.alloc(2, 2, node) }.is_some());
        assert!(unsafe { arena.alloc(3, 3, node) }.is_some());
        assert!(unsafe { arena.alloc(4, 4, node) }.is_some());
        assert!(unsafe { arena.alloc(5, 5, node) }.is_none());
    }
}
