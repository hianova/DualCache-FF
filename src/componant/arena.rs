#![allow(clippy::missing_safety_doc)]
use ::core::sync::atomic::{AtomicUsize, Ordering};
use core::cell::UnsafeCell;
use core::mem::MaybeUninit;

pub const NULL_INDEX: u32 = u32::MAX;

/// A lock-free static memory pool for Nodes using tagged indices to prevent ABA.
pub struct Arena<K, V, const N: usize> {
    nodes: [UnsafeCell<MaybeUninit<Node<K, V>>>; N],
    next_free: [::core::sync::atomic::AtomicU32; N],
    free_head: AtomicUsize, // Packed: (tag << 32) | index
}

// Ensure Arena can be shared across threads
unsafe impl<K: Send, V: Send, const N: usize> Send for Arena<K, V, N> {}
unsafe impl<K: Sync, V: Sync, const N: usize> Sync for Arena<K, V, N> {}

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
    pub const fn new() -> Self {
        let mut next_free = [const { ::core::sync::atomic::AtomicU32::new(0) }; N];
        let mut i = 0;
        while i < N - 1 {
            next_free[i] = ::core::sync::atomic::AtomicU32::new((i + 1) as u32);
            i += 1;
        }
        next_free[N - 1] = ::core::sync::atomic::AtomicU32::new(NULL_INDEX);

        // Nodes array initialization
        let nodes: [UnsafeCell<MaybeUninit<Node<K, V>>>; N] = unsafe {
            core::mem::MaybeUninit::uninit().assume_init()
        };

        Self {
            nodes,
            next_free,
            free_head: AtomicUsize::new(0), // tag 0, index 0
        }
    }

    /// Allocates a node from the free list and initializes it.
    /// Returns the index of the allocated node.
    pub fn alloc(&self, key: K, value: V, node: *mut crate::componant::qsbr::ThreadStateNode) -> Option<usize> {
        let local_free = unsafe { &mut *(*node).local_free.get() };
        if let Some(idx) = local_free.pop() {
            unsafe {
                (*self.nodes[idx as usize].get()).write(Node { key, value });
            }
            return Some(idx as usize);
        }

        let mut head = self.free_head.load(Ordering::Acquire);
        loop {
            let index = (head & 0xFFFFFFFF) as u32;
            if index == NULL_INDEX {
                return None; // OOM
            }
            let tag = head >> 32;
            let next = self.next_free[index as usize].load(Ordering::Relaxed);
            let new_head = (tag.wrapping_add(1) << 32) | (next as usize);
            
            match self.free_head.compare_exchange_weak(head, new_head, Ordering::AcqRel, Ordering::Acquire) {
                Ok(_) => {
                    let idx = index as usize;
                    // Initialize the memory
                    unsafe {
                        (*self.nodes[idx].get()).write(Node { key, value });
                    }
                    return Some(idx);
                }
                Err(h) => {
                    head = h;
                    ::core::hint::spin_loop();
                }
            }
        }
    }

    /// Safely frees a node, running its drop logic, and returning it to the free list.
    /// MUST only be called when no threads are reading the node (e.g., via QSBR).
    pub unsafe fn free(&self, index: usize) {
        // Drop the inner item
        unsafe {
            core::ptr::drop_in_place((*self.nodes[index].get()).as_mut_ptr());
        }

        // Push to free list
        let mut head = self.free_head.load(Ordering::Relaxed);
        loop {
            let next = (head & 0xFFFFFFFF) as u32;
            self.next_free[index].store(next, Ordering::Relaxed);
            let tag = (head >> 32).wrapping_add(1);
            let new_head = (tag << 32) | index;
            
            match self.free_head.compare_exchange_weak(head, new_head, Ordering::Release, Ordering::Relaxed) {
                Ok(_) => break,
                Err(h) => {
                    head = h;
                    ::core::hint::spin_loop();
                }
            }
        }
    }

    /// Get a reference to a node.
    /// Caller must ensure index is valid and the node is currently allocated.
    #[inline(always)]
    pub unsafe fn get(&self, index: usize) -> &Node<K, V> {
        unsafe {
            &*((*self.nodes[index].get()).as_ptr())
        }
    }

    pub unsafe fn get_mut(&self, index: usize) -> &mut Node<K, V> {
        unsafe {
            &mut *((*self.nodes[index].get()).as_mut_ptr())
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::sync::Arc;
    use std::thread;

    #[test]
    fn test_arena_default() {
        let arena = Arena::<u64, u64, 100>::new();
        let mut dummy_node = crate::componant::qsbr::ThreadStateNode::new();
        let dummy_ptr = &mut dummy_node as *mut _;
        assert!(arena.alloc(1, 10, dummy_ptr).is_some());
    }

    #[test]
    fn test_arena_cas_retries() {
        let arena = Arc::new(Arena::<u64, u64, 1000>::new());
        let mut handles = vec![];

        for i in 0..10 {
            let arena_clone = arena.clone();
            handles.push(thread::spawn(move || {
                let mut dummy_node = crate::componant::qsbr::ThreadStateNode::new();
                let dummy_ptr = &mut dummy_node as *mut _;
                let mut idxs = vec![];
                for _ in 0..50 {
                    if let Some(idx) = arena_clone.alloc(i, i * 10, dummy_ptr) {
                        idxs.push(idx);
                    }
                }
                for idx in idxs {
                    unsafe { arena_clone.free(idx); }
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
            let node = std::boxed::Box::into_raw(std::boxed::Box::new(crate::componant::qsbr::ThreadStateNode::new()));
            crate::componant::qsbr::register_node(node);
            node
        };
        assert!(arena.alloc(1, 1, node).is_some());
        assert!(arena.alloc(2, 2, node).is_some());
        assert!(arena.alloc(3, 3, node).is_some());
        assert!(arena.alloc(4, 4, node).is_some());
        assert!(arena.alloc(5, 5, node).is_none()); // OOM
    }
}
