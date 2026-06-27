#[cfg(not(feature = "std"))]
use alloc::{boxed::Box, vec, vec::Vec};

use core::sync::atomic::{AtomicPtr, AtomicBool, Ordering};
use crate::sync::Arc;
use crate::components::WorkerState;
use crate::workers::WorkerSlot;


/// Inner structures of the worker registry holding states and sharded miss buffers.
pub struct RegistryInner<K, V> {
    pub states: Box<[Arc<WorkerState>]>,
    pub buffers: Box<[Arc<WorkerSlot<K, V>>]>,
}

/// A lock-free thread registry utilizing QSBR reclamation for thread-local buffers.
///
/// Dynamically grows the number of registered thread-local buffers and worker states
/// without locking the hot read/write path.
pub struct ThreadRegistry<K, V> {
    pub inner: AtomicPtr<RegistryInner<K, V>>,
    pub lock: AtomicBool,
}

unsafe impl<K: Send, V: Send> Send for ThreadRegistry<K, V> {}
unsafe impl<K: Sync, V: Sync> Sync for ThreadRegistry<K, V> {}

impl<K, V> Drop for ThreadRegistry<K, V> {
    fn drop(&mut self) {
        let ptr = self.inner.load(Ordering::Acquire);
        if !ptr.is_null() {
            unsafe {
                let _ = Box::from_raw(ptr);
            }
        }
    }
}

impl<K, V> ThreadRegistry<K, V> {
    #[inline(always)]
    pub fn get_inner(&self) -> *mut RegistryInner<K, V> {
        self.inner.load(Ordering::Relaxed)
    }

    /// Return the number of registered worker/thread slots.
    #[inline(always)]
    pub fn len(&self) -> usize {
        let ptr = self.get_inner();
        unsafe { (&(*ptr).states).len() }
    }

    /// Ensure the registry capacity can cover the requested thread index.
    ///
    /// If the capacity is insufficient, grows the registry using a double-checked spinlock pattern,
    /// and returns `Some(*mut RegistryInner)` representing the retired old registry pointer.
    /// This retired pointer must be passed to the Daemon for QSBR cleanup.
    pub fn ensure_capacity(&self, required_id: usize) -> Option<*mut RegistryInner<K, V>> {
        let mut ptr = self.get_inner();
        let mut len = unsafe { (&(*ptr).states).len() };
        if required_id < len {
            return None; // Capacity is already sufficient
        }

        // Acquire spinlock
        let mut backoff = 1;
        while self.lock.compare_exchange_weak(false, true, Ordering::Acquire, Ordering::Relaxed).is_err() {
            for _ in 0..backoff {
                core::hint::spin_loop();
            }
            backoff = (backoff << 1).min(128);
        }

        // Double check
        ptr = self.get_inner();
        len = unsafe { (&(*ptr).states).len() };
        if required_id < len {
            self.lock.store(false, Ordering::Release);
            return None;
        }

        let new_capacity = (required_id + 1).next_power_of_two().max(len * 2);
        
        let old_inner = unsafe { &*ptr };
        let mut new_states = Vec::with_capacity(new_capacity);
        let mut new_buffers = Vec::with_capacity(new_capacity);
        
        for i in 0..len {
            new_states.push(old_inner.states[i].clone());
            new_buffers.push(old_inner.buffers[i].clone());
        }
        for _ in len..new_capacity {
            new_states.push(Arc::new(WorkerState::new()));
            new_buffers.push(Arc::new(WorkerSlot::new()));
        }
        
        let new_inner = Box::new(RegistryInner {
            states: new_states.into_boxed_slice(),
            buffers: new_buffers.into_boxed_slice(),
        });
        
        let new_ptr = Box::into_raw(new_inner);
        self.inner.store(new_ptr, Ordering::Release);
        
        self.lock.store(false, Ordering::Release);
        
        Some(ptr) // Return old ptr to be garbage collected
    }
}

impl<K: Send + Sync + 'static, V: Send + Sync + 'static> ThreadRegistry<K, V> {
    /// Create a new registry with the specified initial capacity.
    pub fn new(initial_capacity: usize) -> Self {
        let mut states = Vec::with_capacity(initial_capacity);
        let mut buffers = Vec::with_capacity(initial_capacity);
        for _ in 0..initial_capacity {
            states.push(Arc::new(WorkerState::new()));
            buffers.push(Arc::new(WorkerSlot::new()));
        }
        
        let inner = Box::new(RegistryInner {
            states: states.into_boxed_slice(),
            buffers: buffers.into_boxed_slice(),
        });
        
        Self {
            inner: AtomicPtr::new(Box::into_raw(inner)),
            lock: AtomicBool::new(false),
        }
    }
}
