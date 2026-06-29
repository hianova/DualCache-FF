use alloc::vec::Vec;
use core::sync::atomic::{AtomicUsize, Ordering};
use core::cell::UnsafeCell;
#[cfg(feature = "std")]
use crate::daemon::DaemonMessage;
use crate::core::qsbr;

/// An explicit handle given to a thread to access its TLS state and QSBR node.
pub struct TlsHandle {
    pub id: usize,
    pub qsbr_node: *mut qsbr::ThreadStateNode,
}

unsafe impl Send for TlsHandle {}
unsafe impl Sync for TlsHandle {}

/// The thread-local cache array structure (L1).
/// Simple, memory-friendly, and extremely fast because it is exclusively owned by the thread.
pub struct TlsEntry<K, V> {
    pub hash: usize,
    pub key: K,
    pub value: V,
    pub hits: u8,
}

pub struct TlsCache<K, V> {
    index: Vec<usize>,
    index_mask: usize,
    
    nodes: Vec<Option<TlsEntry<K, V>>>,
    capacity: usize,
    
    cursor: usize,
    count_sum: u32,
    free_list: Vec<usize>,
    
    pub promote_threshold: u8,
    probation_filter: alloc::boxed::Box<[u8; 4096]>,
    probation_cursor: usize,
}

impl<K: Clone + Eq, V: Clone> TlsCache<K, V> {
    pub fn new(capacity: usize) -> Self {
        assert!(capacity.is_power_of_two(), "TlsCache capacity must be a power of two");
        let index_capacity = capacity * 2;
        let mut index = Vec::with_capacity(index_capacity);
        for _ in 0..index_capacity {
            index.push(usize::MAX);
        }
        
        let mut nodes = Vec::with_capacity(capacity);
        let mut free_list = Vec::with_capacity(capacity);
        for i in 0..capacity {
            nodes.push(None);
            free_list.push(capacity - 1 - i);
        }
        
        Self { 
            index, 
            index_mask: index_capacity - 1, 
            nodes,
            capacity,
            cursor: 0,
            count_sum: 0,
            free_list,
            promote_threshold: 2,
            probation_filter: alloc::boxed::Box::new([0; 4096]),
            probation_cursor: 0,
        }
    }

    #[inline(always)]
    pub fn get(&mut self, hash: usize, key: &K) -> (Option<&V>, bool, bool) {
        let mut found_node_idx = None;
        let mut idx = hash & self.index_mask;
        for _ in 0..16 {
            let node_idx = unsafe { *self.index.get_unchecked(idx) };
            if node_idx == usize::MAX {
                break;
            }
            if node_idx != usize::MAX - 1
                && let Some(entry) = unsafe { self.nodes.get_unchecked(node_idx) }
                && entry.hash == hash && entry.key == *key {
                    found_node_idx = Some(node_idx);
                    break;
            }
            idx = (idx + 1) & self.index_mask;
        }

        if let Some(node_idx) = found_node_idx {
            let entry = unsafe { self.nodes.get_unchecked_mut(node_idx) }.as_mut().unwrap();
            if entry.hits < 255 {
                entry.hits += 1;
                self.count_sum += 1;
            }
            let promote = entry.hits == self.promote_threshold;
            let sync = entry.hits > self.promote_threshold && entry.hits.is_multiple_of(16);
            return (Some(&entry.value), promote, sync);
        }
        (None, false, false)
    }

    fn alloc_slot(&mut self) -> usize {
        if let Some(idx) = self.free_list.pop() {
            return idx;
        }
        
        let avg = (self.count_sum as usize / self.capacity) as u8;
        loop {
            let node_idx = self.cursor;
            self.cursor = (self.cursor + 1) & (self.capacity - 1);
            
            if let Some(entry) = unsafe { self.nodes.get_unchecked_mut(node_idx) } {
                if entry.hits <= avg {
                    self.count_sum -= entry.hits as u32;
                    let target_hash = entry.hash;
                    unsafe { *self.nodes.get_unchecked_mut(node_idx) = None; }
                    
                    let mut i = target_hash & self.index_mask;
                    for _ in 0..16 {
                        let i_ptr = unsafe { self.index.get_unchecked_mut(i) };
                        if *i_ptr == node_idx {
                            *i_ptr = usize::MAX - 1; // Tombstone
                            break;
                        }
                        i = (i + 1) & self.index_mask;
                    }
                    
                    return node_idx;
                } else {
                    entry.hits -= avg;
                    self.count_sum -= avg as u32;
                }
            }
        }
    }

    fn index_insert(&mut self, hash: usize, node_idx: usize) {
        let mut idx = hash & self.index_mask;
        for _ in 0..16 {
            let v = unsafe { *self.index.get_unchecked(idx) };
            if v == usize::MAX || v == usize::MAX - 1 {
                unsafe { *self.index.get_unchecked_mut(idx) = node_idx; }
                return;
            }
            if v == node_idx {
                return;
            }
            idx = (idx + 1) & self.index_mask;
        }
    }

    #[inline(always)]
    pub fn insert(&mut self, hash: usize, key: K, value: V) {
        let mut idx = hash & self.index_mask;
        for _ in 0..16 {
            let node_idx = unsafe { *self.index.get_unchecked(idx) };
            if node_idx == usize::MAX {
                break;
            }
            if node_idx != usize::MAX - 1
                && let Some(entry) = unsafe { self.nodes.get_unchecked_mut(node_idx) }
                && entry.hash == hash && entry.key == key {
                    entry.value = value;
                    return;
            }
            idx = (idx + 1) & self.index_mask;
        }
        
        let filter_idx = hash & 4095;
        // Probation filter fast-clear 4 elements using unsafe
        unsafe {
            let ptr = self.probation_filter.as_mut_ptr().add(self.probation_cursor);
            core::ptr::write_bytes(ptr, 0, 4);
        }
        self.probation_cursor = (self.probation_cursor + 4) & 4095;
        
        let count = unsafe { *self.probation_filter.get_unchecked(filter_idx) }.saturating_add(1);
        unsafe { *self.probation_filter.get_unchecked_mut(filter_idx) = count; }
        
        if count <= 1 {
            return;
        }
        
        let node_idx = self.alloc_slot();
        unsafe { *self.nodes.get_unchecked_mut(node_idx) = Some(TlsEntry { hash, key, value, hits: 0 }); }
        self.index_insert(hash, node_idx);
    }

    #[inline(always)]
    pub fn insert_fast_pass(&mut self, hash: usize, key: K, value: V) {
        let mut idx = hash & self.index_mask;
        for _ in 0..16 {
            let node_idx = unsafe { *self.index.get_unchecked(idx) };
            if node_idx == usize::MAX {
                break;
            }
            if node_idx != usize::MAX - 1
                && let Some(entry) = unsafe { self.nodes.get_unchecked_mut(node_idx) }
                && entry.hash == hash && entry.key == key {
                    entry.value = value;
                    let old_hits = entry.hits;
                    entry.hits = 255;
                    self.count_sum += (255 - old_hits) as u32;
                    return;
            }
            idx = (idx + 1) & self.index_mask;
        }
        
        let node_idx = self.alloc_slot();
        unsafe { *self.nodes.get_unchecked_mut(node_idx) = Some(TlsEntry { hash, key, value, hits: 255 }); }
        self.count_sum += 255;
        self.index_insert(hash, node_idx);
    }

    pub fn record_remote_hit(&mut self, hash: usize, weight: u8) {
        let mut idx = hash & self.index_mask;
        for _ in 0..16 {
            let node_idx = unsafe { *self.index.get_unchecked(idx) };
            if node_idx == usize::MAX {
                break;
            }
            if node_idx != usize::MAX - 1
                && let Some(entry) = unsafe { self.nodes.get_unchecked_mut(node_idx) }
                && entry.hash == hash {
                    let add = (255 - entry.hits).min(weight);
                    entry.hits += add;
                    self.count_sum += add as u32;
                    return;
            }
            idx = (idx + 1) & self.index_mask;
        }
    }
}

/// A block of TLS data representing the state for a single thread.
pub struct TlsBlock<K, V> {
    pub cache: TlsCache<K, V>,
    #[cfg(feature = "std")]
    pub tx: Option<crossbeam_channel::Sender<DaemonMessage<K, V>>>,
    #[cfg(feature = "std")]
    pub hit_rx: Option<crossbeam_channel::Receiver<(usize, u8)>>,
    pub op_count: u16,
    pub hit_batch: [(usize, u8); 32],
    pub hit_batch_len: u8,
    pub warmup_state: u8,
}

impl<K: Clone + Eq, V: Clone> TlsBlock<K, V> {
    pub fn new(capacity: usize) -> Self {
        Self {
            cache: TlsCache::new(capacity),
            #[cfg(feature = "std")]
            tx: None,
            #[cfg(feature = "std")]
            hit_rx: None,
            op_count: 0,
            hit_batch: [(0, 0); 32],
            hit_batch_len: 0,
            warmup_state: 0,
        }
    }
}

/// Registry for managing Thread-Local Caches dynamically without OS TLS.
pub struct TlsRegistry<K, V> {
    blocks: alloc::vec::Vec<UnsafeCell<TlsBlock<K, V>>>,
    next_id: AtomicUsize,
}

// We manually implement Sync because we guarantee that each UnsafeCell
// is only accessed by the thread holding the corresponding TlsHandle.
unsafe impl<K, V> Sync for TlsRegistry<K, V> {}

impl<K: Clone + Eq, V: Clone> TlsRegistry<K, V> {
    pub fn new(max_threads: usize, local_cache_size: usize) -> Self {
        let mut blocks = Vec::with_capacity(max_threads);
        for _ in 0..max_threads {
            blocks.push(UnsafeCell::new(TlsBlock::new(local_cache_size)));
        }
        Self {
            blocks,
            next_id: AtomicUsize::new(0),
        }
    }

    /// Returns the maximum number of threads that can be registered
    pub fn max_threads(&self) -> usize {
        self.blocks.len()
    }

    /// Register a thread dynamically, allocating a handle and a QSBR node.
    pub fn register_thread(&self) -> TlsHandle {
        let id = self.next_id.fetch_add(1, Ordering::Relaxed);
        if id >= self.blocks.len() {
            panic!("Exceeded max thread capacity in TlsRegistry");
        }
        let qsbr_node = qsbr::register_thread();
        TlsHandle { id, qsbr_node }
    }

    /// Returns a mutable reference to the thread's local block.
    /// This is safe because each thread gets a unique ID and exclusively owns its block.
    #[inline]
    #[allow(clippy::mut_from_ref)]
    pub fn get_block_mut(&self, handle: &TlsHandle) -> &mut TlsBlock<K, V> {
        let block_ptr = self.blocks[handle.id].get();
        unsafe { &mut *block_ptr }
    }
}
