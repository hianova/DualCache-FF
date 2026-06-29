use crate::sync::atomic::{AtomicUsize, AtomicU16, Ordering};
use core::cell::UnsafeCell;
use core::mem::MaybeUninit;

pub const NULL_INDEX: u16 = u16::MAX;

/// A lock-free static memory pool for Nodes using tagged indices to prevent ABA.
pub struct Arena<K, V, const N: usize> {
    nodes: [UnsafeCell<MaybeUninit<Node<K, V>>>; N],
    next_free: [AtomicU16; N],
    free_head: AtomicUsize, // Packed: (tag << 16) | index
}

// Ensure Arena can be shared across threads
unsafe impl<K: Send, V: Send, const N: usize> Send for Arena<K, V, N> {}
unsafe impl<K: Sync, V: Sync, const N: usize> Sync for Arena<K, V, N> {}

pub struct Node<K, V> {
    pub key: K,
    pub value: V,
}

impl<K, V, const N: usize> Arena<K, V, N> {
    pub fn new() -> Self {
        let mut next_free = core::array::from_fn(|_| AtomicU16::new(0));
        let mut i = 0;
        while i < N - 1 {
            next_free[i] = AtomicU16::new((i + 1) as u16);
            i += 1;
        }
        next_free[N - 1] = AtomicU16::new(NULL_INDEX);

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
    pub fn alloc(&self, key: K, value: V) -> Option<usize> {
        let mut head = self.free_head.load(Ordering::Acquire);
        loop {
            let index = (head & 0xFFFF) as u16;
            if index == NULL_INDEX {
                return None; // OOM
            }
            let tag = head >> 16;
            let next = self.next_free[index as usize].load(Ordering::Relaxed);
            let new_head = (tag.wrapping_add(1) << 16) | (next as usize);
            
            match self.free_head.compare_exchange_weak(head, new_head, Ordering::AcqRel, Ordering::Acquire) {
                Ok(_) => {
                    let idx = index as usize;
                    // Initialize the memory
                    unsafe {
                        (*self.nodes[idx].get()).write(Node { key, value });
                    }
                    return Some(idx);
                }
                Err(h) => head = h,
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
            let old_index = (head & 0xFFFF) as u16;
            self.next_free[index].store(old_index, Ordering::Relaxed);
            let tag = head >> 16;
            let new_head = (tag.wrapping_add(1) << 16) | (index as usize);
            
            match self.free_head.compare_exchange_weak(head, new_head, Ordering::Release, Ordering::Relaxed) {
                Ok(_) => break,
                Err(h) => head = h,
            }
        }
    }

    /// Get a reference to a node.
    /// Caller must ensure index is valid and the node is currently allocated.
    #[inline(always)]
    pub unsafe fn get(&self, index: usize) -> &Node<K, V> {
        unsafe {
            (*self.nodes[index].get()).assume_init_ref()
        }
    }
}
