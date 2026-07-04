use alloc::vec::Vec;
use core::cell::UnsafeCell;
use ::core::sync::atomic::{AtomicUsize, Ordering};

pub struct TlsHandle {
    pub id: usize,
    pub qsbr_node: *mut crate::componant::qsbr::ThreadStateNode,
}

#[derive(Clone)]
pub struct TlsEntry<K, V> {
    pub hash: usize,
    pub key: K,
    pub value: V,
    pub hits: u8,
}

pub struct TlsCache<K, V, const TLS_CAP: usize, const TLS_INDEX_CAP: usize> {
    slots: [Option<TlsEntry<K, V>>; TLS_CAP],
    capacity: usize,
    pub promote_threshold: u8,
    probation_filter: [u8; 65536],
    probation_cursor: usize,
}

impl<K: Clone + Eq, V: Clone, const TLS_CAP: usize, const TLS_INDEX_CAP: usize> Default for TlsCache<K, V, TLS_CAP, TLS_INDEX_CAP> {
    fn default() -> Self {
        Self::new()
    }
}

impl<K: Clone + Eq, V: Clone, const TLS_CAP: usize, const TLS_INDEX_CAP: usize> TlsCache<K, V, TLS_CAP, TLS_INDEX_CAP> {
    pub const fn new() -> Self {
        Self { 
            slots: [const { None }; TLS_CAP],
            capacity: TLS_CAP,
            promote_threshold: 4,
            probation_filter: [0; 65536],
            probation_cursor: 0,
        }
    }

    #[inline(always)]
    pub fn get(&mut self, hash: usize, key: &K) -> (Option<&V>, bool, u8) {
        let idx = hash & (self.capacity - 1);
        if let Some(entry) = unsafe { self.slots.get_unchecked_mut(idx) } {
            if entry.hash == hash && entry.key == *key {
                let old_hits = entry.hits;
                entry.hits = entry.hits.saturating_add(1);
                
                let promote = old_hits < self.promote_threshold && entry.hits >= self.promote_threshold;
                
                let sync_weight = if entry.hits > self.promote_threshold && (entry.hits & 15) == 0 {
                    16
                } else {
                    0
                };
                
                return (Some(&entry.value), promote, sync_weight);
            }
        }
        (None, false, 0)
    }

    #[inline(always)]
    pub fn insert(&mut self, hash: usize, key: K, value: V) -> bool {
        let idx = hash & (self.capacity - 1);
        if let Some(entry) = unsafe { self.slots.get_unchecked_mut(idx) } {
            if entry.hash == hash && entry.key == key {
                entry.value = value;
                return true;
            }
        }
        
        let filter_idx = hash & 4095;
        
        // Slower Probation Filter: clear 1 element every 16 inserts
        self.probation_cursor = (self.probation_cursor + 1) & 65535;
        if (self.probation_cursor & 15) == 0 {
            unsafe { *self.probation_filter.get_unchecked_mut(self.probation_cursor >> 4) = 0; }
        }
        
        let count = unsafe { *self.probation_filter.get_unchecked(filter_idx) }.saturating_add(1);
        unsafe { *self.probation_filter.get_unchecked_mut(filter_idx) = count; }
        
        if count < 2 {
            return false;
        }
        
        unsafe { *self.slots.get_unchecked_mut(idx) = Some(TlsEntry { hash, key, value, hits: 0 }); }
        true
    }

    #[inline(always)]
    pub fn insert_fast_pass(&mut self, hash: usize, key: K, value: V) {
        let idx = hash & (self.capacity - 1);
        unsafe { *self.slots.get_unchecked_mut(idx) = Some(TlsEntry { hash, key, value, hits: 255 }); }
    }

    pub fn record_remote_hit(&mut self, hash: usize, weight: u8) {
        let idx = hash & (self.capacity - 1);
        if let Some(entry) = unsafe { self.slots.get_unchecked_mut(idx) } {
            if entry.hash == hash {
                entry.hits = entry.hits.saturating_add(weight);
            }
        }
    }
}

use crate::componant::daemon::DaemonMessage;

/// A block of TLS data representing the state for a single thread.
pub struct TlsBlock<K, V, const TLS_CAP: usize, const TLS_INDEX_CAP: usize> {
    pub cache: TlsCache<K, V, TLS_CAP, TLS_INDEX_CAP>,
    #[cfg(feature = "std")]
    pub tx: Option<::alloc::sync::Arc<no_std_tool::collections::mpsc_queue::BoundedQueue<DaemonMessage<K, V>, 65536>>>,
    #[cfg(feature = "std")]
    pub hit_rx: Option<::alloc::sync::Arc<no_std_tool::collections::mpsc_queue::BoundedQueue<(usize, u8), 1024>>>,
    pub op_count: u64,
    #[cfg(feature = "std")]
    pub hit_batch: [(usize, u8); 32],
    #[cfg(feature = "std")]
    pub hit_batch_len: u8,
    pub warmup_state: u8,
    pub qsbr_node: crate::componant::qsbr::ThreadStateNode,
}

impl<K: Clone + Eq, V: Clone, const TLS_CAP: usize, const TLS_INDEX_CAP: usize> Default for TlsBlock<K, V, TLS_CAP, TLS_INDEX_CAP> {
    fn default() -> Self {
        Self::new()
    }
}

impl<K: Clone + Eq, V: Clone, const TLS_CAP: usize, const TLS_INDEX_CAP: usize> TlsBlock<K, V, TLS_CAP, TLS_INDEX_CAP> {
    pub const fn new() -> Self {
        Self {
            cache: TlsCache::new(),
            #[cfg(feature = "std")]
            tx: None,
            #[cfg(feature = "std")]
            hit_rx: None,
            op_count: 0,
            #[cfg(feature = "std")]
            hit_batch: [(0, 0); 32],
            #[cfg(feature = "std")]
            hit_batch_len: 0,
            warmup_state: 0,
            qsbr_node: crate::componant::qsbr::ThreadStateNode::new(),
        }
    }
}

/// Registry for managing Thread-Local Caches dynamically without OS TLS.
pub struct TlsRegistry<K, V, const MAX_THREADS: usize, const TLS_CAP: usize, const TLS_INDEX_CAP: usize> {
    blocks: [UnsafeCell<no_std_tool::sync::CachePadded<TlsBlock<K, V, TLS_CAP, TLS_INDEX_CAP>>>; MAX_THREADS],
    next_id: AtomicUsize,
}

unsafe impl<K, V, const MAX_THREADS: usize, const TLS_CAP: usize, const TLS_INDEX_CAP: usize> Sync for TlsRegistry<K, V, MAX_THREADS, TLS_CAP, TLS_INDEX_CAP> {}
unsafe impl<K, V, const MAX_THREADS: usize, const TLS_CAP: usize, const TLS_INDEX_CAP: usize> Send for TlsRegistry<K, V, MAX_THREADS, TLS_CAP, TLS_INDEX_CAP> {}

impl<K: Clone + Eq, V: Clone, const MAX_THREADS: usize, const TLS_CAP: usize, const TLS_INDEX_CAP: usize> Default for TlsRegistry<K, V, MAX_THREADS, TLS_CAP, TLS_INDEX_CAP> {
    fn default() -> Self {
        Self::new()
    }
}

impl<K: Clone + Eq, V: Clone, const MAX_THREADS: usize, const TLS_CAP: usize, const TLS_INDEX_CAP: usize> TlsRegistry<K, V, MAX_THREADS, TLS_CAP, TLS_INDEX_CAP> {
    pub const fn new() -> Self {
        Self {
            blocks: [const { UnsafeCell::new(no_std_tool::sync::CachePadded { value: TlsBlock::new() }) }; MAX_THREADS],
            next_id: AtomicUsize::new(0),
        }
    }

    pub fn max_threads(&self) -> usize {
        MAX_THREADS
    }

    pub fn register_thread(&self) -> TlsHandle {
        let id = self.next_id.fetch_add(1, Ordering::Relaxed);
        if id >= MAX_THREADS {
            panic!("Exceeded max thread capacity in TlsRegistry");
        }
        let block = unsafe { &mut (*self.blocks[id].get()).value };
        let qsbr_node = &mut block.qsbr_node as *mut _;
        crate::componant::qsbr::register_node(qsbr_node);
        TlsHandle { id, qsbr_node }
    }

    #[inline]
    #[allow(clippy::mut_from_ref)]
    pub fn get_block_mut(&self, handle: &TlsHandle) -> &mut TlsBlock<K, V, TLS_CAP, TLS_INDEX_CAP> {
        let block_ptr = self.blocks[handle.id].get();
        unsafe { &mut (*block_ptr).value }
    }
}
