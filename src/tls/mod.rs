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
pub struct TlsCache<K, V> {
    entries: Vec<Option<(usize, K, V, u8)>>, // hash, key, value, hits
    capacity_mask: usize,
    pub promote_threshold: u8,
    
    // Probation Filter (Hash Admission)
    probation_filter: alloc::boxed::Box<[u8; 4096]>,
    probation_cursor: usize,
}

impl<K: Clone + Eq, V: Clone> TlsCache<K, V> {
    pub fn new(capacity: usize) -> Self {
        let mut entries = Vec::with_capacity(capacity);
        for _ in 0..capacity {
            entries.push(None);
        }
        assert!(capacity.is_power_of_two(), "TlsCache capacity must be a power of two");
        Self { 
            entries, 
            capacity_mask: capacity - 1, 
            promote_threshold: 2, // Default promote threshold
            probation_filter: alloc::boxed::Box::new([0; 4096]),
            probation_cursor: 0,
        }
    }



    /// Get value from TlsCache.
    /// Returns (value, should_promote, should_sync_hit)
    #[inline(always)]
    pub fn get(&mut self, hash: usize, key: &K) -> (Option<&V>, bool, bool) {
        let idx = hash & self.capacity_mask;
        if let Some((h, k, v, hits)) = &mut self.entries[idx]
            && *h == hash && k == key {
                *hits = hits.saturating_add(1);
                let promote = *hits == self.promote_threshold;
                let sync = *hits > self.promote_threshold && (*hits % 16 == 0);
                if *hits == 255 {
                    *hits = 255 - 16;
                }
                return (Some(v), promote, sync);
            }
        (None, false, false)
    }

    /// Put value into TlsCache. Evicts old item to L3 callback if necessary.
    #[inline(always)]
    pub fn insert(&mut self, hash: usize, key: K, value: V) {
        let idx = hash & self.capacity_mask;
        
        // 1. Update Check: If the key is already here, just update it (bypass filter)
        if let Some((h, k, v, _hits)) = &mut self.entries[idx]
            && *h == hash && *k == key {
                *v = value;
                return;
            }
        
        // 2. Admission Check (Probation Filter)
        let filter_idx = hash & 4095;
        
        // Clock-sweep aging
        for i in 0..4 {
            self.probation_filter[(self.probation_cursor + i) & 4095] = 0;
        }
        self.probation_cursor = (self.probation_cursor + 4) & 4095;
        
        let count = self.probation_filter[filter_idx].saturating_add(1);
        self.probation_filter[filter_idx] = count;
        
        if count <= 1 {
            // First time seen, rejected from TlsCache to prevent thrashing
            return;
        }
        
        // 3. Admission Passed: Insert into TlsCache, evicting old item if any
        self.entries[idx] = Some((hash, key, value, 0));
    }

    /// Fast Pass insertion into TlsCache.
    /// Bypasses probation filter and sets hits to 255 (max) to prevent local eviction.
    #[inline(always)]
    pub fn insert_fast_pass(&mut self, hash: usize, key: K, value: V) {
        let idx = hash & self.capacity_mask;
        self.entries[idx] = Some((hash, key, value, 255));
    }

    /// Update hit counts from remote broadcasts. Only updates if the key (Value) is locally present.
    pub fn record_remote_hit(&mut self, hash: usize, weight: u8) {
        let idx = hash & self.capacity_mask;
        if let Some((entry_hash, _, _, hits)) = &mut self.entries[idx]
            && *entry_hash == hash {
                *hits = hits.saturating_add(weight);
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
