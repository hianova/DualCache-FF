#![allow(clippy::not_unsafe_ptr_arg_deref)]
#![allow(clippy::missing_safety_doc)]
use crate::sync::atomic::{AtomicPtr, AtomicUsize, AtomicBool, Ordering};
use alloc::boxed::Box;
use core::ptr;

lazy_static::lazy_static! {
    static ref GLOBAL_EPOCH: AtomicUsize = AtomicUsize::new(1);
    static ref THREAD_STATES: AtomicPtr<ThreadStateNode> = AtomicPtr::new(ptr::null_mut());
}

#[derive(Copy, Clone)]
struct RetiredNode {
    index: u16,
    epoch: u64,
}

const GARBAGE_CAP: usize = 1024;
pub struct GarbageQueue {
    items: [RetiredNode; GARBAGE_CAP],
    head: usize,
    tail: usize,
}

impl GarbageQueue {
    fn new() -> Self {
        Self {
            items: [RetiredNode { index: 0, epoch: 0 }; GARBAGE_CAP],
            head: 0,
            tail: 0,
        }
    }
}

/// Represents a thread's state in the QSBR system.
pub struct ThreadStateNode {
    pub active: AtomicBool,
    pub epoch: AtomicUsize,
    pub next: *mut ThreadStateNode,
    pub garbage_queue: GarbageQueue,
}

impl ThreadStateNode {
    fn new() -> Self {
        Self {
            active: AtomicBool::new(false),
            epoch: AtomicUsize::new(0),
            next: ptr::null_mut(),
            garbage_queue: GarbageQueue::new(),
        }
    }
}

// GarbageNode is removed since we use GarageQueue.

/// Register a new thread state node. The caller should store this pointer locally
/// (e.g., using `thread_local!` in the `std` daemon) and pass it to `Guard::new()`.
pub fn register_thread() -> *mut ThreadStateNode {
    let node = Box::into_raw(Box::new(ThreadStateNode::new()));
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
            Ok(_) => break node,
            Err(new_head) => head = new_head,
        }
    }
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

    /// Get the underlying ThreadStateNode pointer.
    pub fn node(&self) -> *mut ThreadStateNode {
        self.node
    }
}

impl Drop for Guard {
    fn drop(&mut self) {
        unsafe {
            (*self.node).active.store(false, Ordering::Release);
        }
    }
}

/// Pin the current thread using an explicit node. Use this before reading from the cache.
pub fn pin(node: *mut ThreadStateNode) -> Guard {
    Guard::new(node)
}


/// Retire a node index into the thread-local garbage queue safely using QSBR.
/// This prevents ABA by ensuring the index is not freed to the Arena until all threads observing it have advanced.
pub fn retire(index: usize, node: *mut ThreadStateNode) {
    let epoch = GLOBAL_EPOCH.load(Ordering::Acquire) as u64;
    unsafe {
        let q = &mut (*node).garbage_queue;
        let idx = q.head % GARBAGE_CAP;
        q.items[idx] = RetiredNode {
            index: index as u16,
            epoch,
        };
        q.head += 1;
    }
}

/// Try to reclaim memory from the thread-local garbage queue. 
/// Returns a list of reclaimed indices (up to 16 at a time to bound latency).
pub fn try_reclaim(node: *mut ThreadStateNode) -> [u16; 16] {
    // Advance the global epoch. Threads that pin() after this will read the new epoch.
    // This allows previously retired nodes to eventually be reclaimed once older active epochs clear out.
    GLOBAL_EPOCH.fetch_add(1, Ordering::Relaxed);

    let mut reclaimed = [u16::MAX; 16];
    let mut count = 0;
    
    let min_epoch = get_min_epoch();
    
    unsafe {
        let q = &mut (*node).garbage_queue;
        while q.tail < q.head && count < 16 {
            let idx = q.tail % GARBAGE_CAP;
            let retired = q.items[idx];
            
            // If the retired epoch is strictly less than the minimum active epoch across all threads,
            // no thread can possibly have a reference to this node anymore.
            if retired.epoch < min_epoch as u64 {
                reclaimed[count] = retired.index;
                count += 1;
                q.tail += 1;
            } else {
                // Epochs are monotonically increasing. If this one isn't safe, neither are the rest.
                break;
            }
        }
    }
    
    reclaimed
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


