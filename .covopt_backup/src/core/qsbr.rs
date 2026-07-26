use ::core::sync::atomic::{AtomicBool, AtomicPtr, AtomicUsize, Ordering};
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
const GARBAGE_CAP: usize = 4096;
#[repr(align(64))]
#[repr(C)]
pub struct GarbageQueue {
    items: [RetiredNode; GARBAGE_CAP],
    head: AtomicUsize,
    tail: AtomicUsize,
}
impl GarbageQueue {
    const fn new() -> Self {
        Self {
            items: [RetiredNode { index: 0, epoch: 0 }; GARBAGE_CAP],
            head: AtomicUsize::new(0),
            tail: AtomicUsize::new(0),
        }
    }
}
#[repr(align(64))]
#[repr(C)]
pub struct MpmcQueue<const N: usize> {
    head: AtomicUsize,
    tail: AtomicUsize,
    buffer: [::core::sync::atomic::AtomicU32; N],
}
impl<const N: usize> Default for MpmcQueue<N> {
    fn default() -> Self {
        Self::new()
    }
}
impl<const N: usize> MpmcQueue<N> {
    pub const fn new() -> Self {
        Self {
            head: AtomicUsize::new(0),
            tail: AtomicUsize::new(0),
            buffer: [const { ::core::sync::atomic::AtomicU32::new(u32::MAX) }; N],
        }
    }
    pub fn push(&self, val: u32) -> bool {
        let result = self
            .tail
            .try_update(Ordering::SeqCst, Ordering::Relaxed, |tail| {
                if tail.wrapping_sub(self.head.load(Ordering::Acquire)) >= N {
                    None
                } else {
                    Some(tail + 1)
                }
            });
        match result {
            Ok(tail) => {
                while self.buffer[tail % N].load(Ordering::Acquire) != u32::MAX {
                    ::core::hint::spin_loop();
                }
                self.buffer[tail % N].store(val, Ordering::Release);
                true
            }
            Err(_) => false,
        }
    }
    pub fn pop(&self) -> Option<u32> {
        let mut final_val = 0;
        let result = self
            .head
            .try_update(Ordering::SeqCst, Ordering::Relaxed, |head| {
                if head == self.tail.load(Ordering::Acquire) {
                    return None;
                }
                let val = self.buffer[head % N].load(Ordering::Acquire);
                if val != u32::MAX {
                    final_val = val;
                    Some(head + 1)
                } else {
                    None
                }
            });
        if let Ok(old_head) = result {
            self.buffer[old_head % N].store(u32::MAX, Ordering::Release);
            Some(final_val)
        } else {
            None
        }
    }
}
#[repr(C, align(64))]
pub struct LocalFreeQueue {
    items: [u32; 4096],
    len: usize,
}
impl Default for LocalFreeQueue {
    fn default() -> Self {
        Self::new()
    }
}
impl LocalFreeQueue {
    pub const fn new() -> Self {
        Self {
            items: [0; 4096],
            len: 0,
        }
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
        if self.len < 4096 {
            self.items[self.len] = val;
            self.len += 1;
            true
        } else {
            false
        }
    }
}
#[repr(C, align(64))]
pub struct QsbrToken;
#[cfg_attr(
    not(feature = "std"),
    no_std_tool_macros::auto_static(capacity = 256, partition = "qsbr")
)]
#[repr(align(64))]
#[repr(C)]
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
pub trait RegistryCore: Send + Sync {
    fn free_id(&self, id: usize);
}
#[doc = " Register a pre-allocated thread state node. The caller should allocate this node"]
#[doc = " locally or in the static TLS blocks."]
#[doc = " # Safety"]
#[doc = " `node` must be a valid, non-null pointer."]
pub unsafe fn register_node(node: *mut ThreadStateNode) {
    let _ = THREAD_STATES.try_update(Ordering::Release, Ordering::Relaxed, |head| {
        unsafe { (*node).next = head };
        #[cfg(test)]
        core::hint::spin_loop();
        Some(node)
    });
}
pub fn get_global_epoch() -> usize {
    GLOBAL_EPOCH.load(Ordering::Relaxed)
}
#[doc = " A guard that pins the current thread to an epoch."]
#[repr(C, align(64))]
pub struct Guard {
    node: *mut ThreadStateNode,
}
impl Guard {
    #[doc = " Create a new Guard using the explicitly provided ThreadStateNode."]
    #[doc = " # Safety"]
    #[doc = " `node` must be a valid, non-null ThreadStateNode pointer."]
    pub unsafe fn new(node: *mut ThreadStateNode) -> Self {
        let global_epoch = GLOBAL_EPOCH.load(Ordering::Acquire);
        unsafe {
            (*node).epoch.store(global_epoch, Ordering::Release);
            (*node).active.store(true, Ordering::Release);
        }
        Self { node }
    }
    #[doc = " # Safety"]
    #[doc = " Caller must ensure node pointer invariant is preserved."]
    #[inline(always)]
    pub unsafe fn unpinned(node: *mut ThreadStateNode) -> Self {
        Self { node }
    }
    #[doc = " # Safety"]
    #[doc = " Creates an unpinned dummy guard."]
    #[inline(always)]
    pub unsafe fn dummy() -> Self {
        Self {
            node: core::ptr::null_mut(),
        }
    }
    #[doc = " Get the underlying ThreadStateNode pointer."]
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
#[doc = " # Safety"]
#[doc = " `node` must be a valid, non-null ThreadStateNode pointer."]
pub unsafe fn pin_relaxed(node: *mut ThreadStateNode) -> Guard {
    let node_ref = unsafe { &*node };
    node_ref.active.store(true, Ordering::Relaxed);
    Guard { node }
}
#[doc = " # Safety"]
#[doc = " `node` must be a valid, non-null ThreadStateNode pointer."]
#[inline(always)]
pub unsafe fn pin(node: *mut ThreadStateNode) -> Guard {
    unsafe { Guard::new(node) }
}
#[doc = " Retire a node index into the thread-local garbage queue safely using QSBR."]
#[doc = " This prevents ABA by ensuring the index is not freed to the Arena until all threads observing it have advanced."]
#[doc = " # Safety"]
#[doc = " `node` must be a valid, non-null ThreadStateNode pointer."]
pub unsafe fn retire<F: FnMut(u32)>(index: usize, node: *mut ThreadStateNode, mut _free_fn: F) {
    let epoch = GLOBAL_EPOCH.load(Ordering::Acquire) as u64;
    unsafe {
        let q = &mut (*node).garbage_queue;
        let mut head = q.head.load(Ordering::Relaxed);
        while head.wrapping_sub(q.tail.load(Ordering::Acquire)) >= GARBAGE_CAP {
            let cur_epoch = GLOBAL_EPOCH.load(Ordering::Relaxed);
            (*node).epoch.store(cur_epoch, Ordering::Release);
            ::core::hint::spin_loop();
            head = q.head.load(Ordering::Relaxed);
        }
        let idx = head % GARBAGE_CAP;
        q.items[idx] = RetiredNode {
            index: index as u32,
            epoch,
        };
        q.head.store(head.wrapping_add(1), Ordering::Release);
    }
}
#[doc = " The Daemon calls this globally to move safe nodes from GarbageQueues to Arena."]
pub fn daemon_reclaim<F: FnMut(&[u32])>(mut free_batch_fn: F) {
    GLOBAL_EPOCH.fetch_add(1, Ordering::Relaxed);
    let min_epoch = get_min_epoch();
    let mut batch = [0u32; 128];
    let mut batch_len = 0;
    let mut node = THREAD_STATES.load(Ordering::Acquire);
    while !node.is_null() {
        unsafe {
            let q = &mut (*node).garbage_queue;
            let mut tail = q.tail.load(Ordering::Relaxed);
            let head = q.head.load(Ordering::Acquire);
            while tail < head {
                let idx = tail % GARBAGE_CAP;
                let retired = q.items[idx];
                if retired.epoch < min_epoch as u64 {
                    batch[batch_len] = retired.index;
                    batch_len += 1;
                    tail += 1;
                    if batch_len == 128 {
                        free_batch_fn(&batch[..batch_len]);
                        batch_len = 0;
                    }
                } else {
                    break;
                }
            }
            q.tail.store(tail, Ordering::Release);
            node = (*node).next;
        }
    }
    if batch_len > 0 {
        free_batch_fn(&batch[..batch_len]);
    }
}
fn get_min_epoch() -> usize {
    let mut min_epoch = GLOBAL_EPOCH.load(Ordering::Acquire);
    let mut node = THREAD_STATES.load(Ordering::Acquire);
    while !node.is_null() {
        unsafe {
            if (*node).active.load(Ordering::Acquire) {
                let e = (*node).epoch.load(Ordering::Acquire);
                if e < min_epoch {
                    min_epoch = e;
                }
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
