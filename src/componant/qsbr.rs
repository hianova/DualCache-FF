#![allow(clippy::not_unsafe_ptr_arg_deref)]
#![allow(clippy::missing_safety_doc)]
use ::core::sync::atomic::{AtomicPtr, AtomicUsize, AtomicBool, Ordering};
use core::ptr;

static GLOBAL_EPOCH: AtomicUsize = AtomicUsize::new(1);
static THREAD_STATES: AtomicPtr<ThreadStateNode> = AtomicPtr::new(ptr::null_mut());

#[doc(hidden)]
pub unsafe fn reset() {
    GLOBAL_EPOCH.store(1, Ordering::SeqCst);
    THREAD_STATES.store(ptr::null_mut(), Ordering::SeqCst);
}

#[derive(Copy, Clone)]
struct RetiredNode {
    index: u32,
    epoch: u64,
}

const GARBAGE_CAP: usize = 1024;
pub struct GarbageQueue {
    items: [RetiredNode; GARBAGE_CAP],
    head: usize,
    tail: usize,
}

impl GarbageQueue {
    const fn new() -> Self {
        Self {
            items: [RetiredNode { index: 0, epoch: 0 }; GARBAGE_CAP],
            head: 0,
            tail: 0,
        }
    }
}

pub struct LocalFreeQueue {
    items: [u32; 256],
    len: usize,
}

impl Default for LocalFreeQueue {
    fn default() -> Self {
        Self::new()
    }
}

impl LocalFreeQueue {
    pub const fn new() -> Self {
        Self { items: [0; 256], len: 0 }
    }
    pub fn pop(&mut self) -> Option<u32> {
        if self.len > 0 {
            self.len -= 1;
            Some(self.items[self.len])
        } else {
            None
        }
    }
    #[must_use]
    pub fn push(&mut self, val: u32) -> bool {
        if self.len < 256 {
            self.items[self.len] = val;
            self.len += 1;
            true
        } else {
            false
        }
    }
}

pub struct QsbrToken;

#[cfg_attr(not(feature = "std"), no_std_tool::auto_static(capacity = 256, partition = "qsbr"))]
pub struct ThreadStateNode {
    pub active: AtomicBool,
    pub epoch: AtomicUsize,
    pub next: *mut ThreadStateNode,
    pub garbage_queue: GarbageQueue,
    pub local_free: core::cell::UnsafeCell<LocalFreeQueue>,
}

impl Default for ThreadStateNode {
    fn default() -> Self {
        Self::new()
    }
}

impl ThreadStateNode {
    pub const fn new() -> Self {
        Self {
            active: AtomicBool::new(false),
            epoch: AtomicUsize::new(0),
            next: ptr::null_mut(),
            garbage_queue: GarbageQueue::new(),
            local_free: core::cell::UnsafeCell::new(LocalFreeQueue::new()),
        }
    }
}

unsafe impl Send for ThreadStateNode {}
unsafe impl Sync for ThreadStateNode {}

/// Register a pre-allocated thread state node. The caller should allocate this node
/// locally or in the static TLS blocks.
pub fn register_node(node: *mut ThreadStateNode) {
    let mut head = THREAD_STATES.load(Ordering::Acquire);
    loop {
        unsafe { (*node).next = head };
        
        // Yield to encourage a CAS collision for coverage
        #[cfg(test)]
        std::thread::yield_now();

        match THREAD_STATES.compare_exchange_weak(
            head,
            node,
            Ordering::Release,
            Ordering::Relaxed,
        ) {
            Ok(_) => break,
            Err(new_head) => {
                head = new_head;
                ::core::hint::spin_loop();
            }
        }
    }
}

pub fn get_global_epoch() -> usize {
    GLOBAL_EPOCH.load(Ordering::Relaxed)
}

/// A guard that pins the current thread to an epoch.
pub struct Guard {
    node: *mut ThreadStateNode,
}

impl Guard {
    /// Create a new Guard using the explicitly provided ThreadStateNode.
    pub fn new(node: *mut ThreadStateNode) -> Self {
        let global_epoch = GLOBAL_EPOCH.load(Ordering::Acquire);
        unsafe {
            (*node).epoch.store(global_epoch, Ordering::Release);
            (*node).active.store(true, Ordering::Release);
        }
        Self { node }
    }

    #[inline(always)]
    pub unsafe fn unpinned(node: *mut ThreadStateNode) -> Self {
        Self { node }
    }
    
    #[inline(always)]
    pub unsafe fn dummy() -> Self {
        Self { node: core::ptr::null_mut() }
    }
    
    /// Get the underlying ThreadStateNode pointer.
    #[inline(always)]
    pub fn node(&self) -> *mut ThreadStateNode {
        self.node
    }
}

impl Drop for Guard {
    #[inline(always)]
    fn drop(&mut self) {
        if !self.node.is_null() {
            let node_ref = unsafe { &*self.node };
            node_ref.active.store(false, Ordering::Release);
        }
    }
}

pub fn pin_relaxed(node: *mut ThreadStateNode) -> Guard {
    let node_ref = unsafe { &*node };
    node_ref.active.store(true, Ordering::Relaxed);
    Guard { node }
}

#[inline(always)]
pub fn pin(node: *mut ThreadStateNode) -> Guard {
    Guard::new(node)
}


/// Retire a node index into the thread-local garbage queue safely using QSBR.
/// This prevents ABA by ensuring the index is not freed to the Arena until all threads observing it have advanced.
pub fn retire<F: FnMut(u32)>(index: usize, node: *mut ThreadStateNode, mut free_fn: F) {
    let epoch = GLOBAL_EPOCH.load(Ordering::Acquire) as u64;
    unsafe {
        let q = &mut (*node).garbage_queue;
        
        while q.head - q.tail >= GARBAGE_CAP {
            try_reclaim(node, &mut free_fn);
            if q.head - q.tail >= GARBAGE_CAP {
                std::thread::yield_now();
            }
        }
        
        let idx = q.head % GARBAGE_CAP;
        q.items[idx] = RetiredNode {
            index: index as u32,
            epoch,
        };
        q.head += 1;
    }
}

/// Try to reclaim memory from the thread-local garbage queue. 
/// Calls the provided closure for each reclaimed node index.
pub fn try_reclaim<F: FnMut(u32)>(node: *mut ThreadStateNode, mut f: F) {
    // Advance the global epoch. Threads that pin() after this will read the new epoch.
    // This allows previously retired nodes to eventually be reclaimed once older active epochs clear out.
    GLOBAL_EPOCH.fetch_add(1, Ordering::Relaxed);

    let min_epoch = get_min_epoch();
    
    unsafe {
        let q = &mut (*node).garbage_queue;
        
        // Debug check to ensure we aren't leaking and overwriting memory in the ring buffer
        debug_assert!(q.head - q.tail <= GARBAGE_CAP, "QSBR garbage queue overflow! Memory leaked.");
        
        while q.tail < q.head {
            let idx = q.tail % GARBAGE_CAP;
            let retired = q.items[idx];
            
            // If the retired epoch is strictly less than the minimum active epoch across all threads,
            // no thread can possibly have a reference to this node anymore.
            if retired.epoch < min_epoch as u64 {
                f(retired.index);
                q.tail += 1;
            } else {
                // Epochs are monotonically increasing. If this one isn't safe, neither are the rest.
                break;
            }
        }
    }
}

fn get_min_epoch() -> usize {
    let mut min_epoch = GLOBAL_EPOCH.load(Ordering::Acquire);
    let mut node = THREAD_STATES.load(Ordering::Acquire);
    while !node.is_null() {
        unsafe {
            if (*node).active.load(Ordering::Acquire) {
                let e = (*node).epoch.load(Ordering::Acquire);
                if e < min_epoch { min_epoch = e; }
            }
            node = (*node).next;
        }
    }
    min_epoch
}



#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_qsbr_thread_state_node_new() {
        let node = ThreadStateNode::new();
        assert_eq!(node.epoch.load(Ordering::Relaxed), 0);
    }
}
