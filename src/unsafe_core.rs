pub use arena::Arena;
pub use storage::{Cache, Node};
pub use filters::{T1, T2};
pub use workers::{BatchBuf, WorkerSlot};

mod arena {
    pub struct Arena {
        pub(crate) capacity: usize,
        pub(crate) cursor: usize,
        pub(crate) rank: Vec<u8>,
        pub hashes: Vec<u64>,
        pub(crate) free_list: Vec<usize>,
        pub(crate) count_sum: u64,
    }

    unsafe impl Send for Arena {}
    unsafe impl Sync for Arena {}

    impl Arena {
        pub fn new(capacity: usize) -> Self {
            Self {
                capacity,
                cursor: 0,
                rank: vec![0; capacity],
                hashes: vec![0; capacity],
                free_list: (0..capacity).collect(),
                count_sum: 0,
            }
        }

        #[inline(always)]
        pub fn pop_free_slot(&mut self) -> Option<usize> {
            self.free_list.pop()
        }

        #[inline(always)]
        pub fn push_free_slot(&mut self, idx: usize) {
            self.free_list.push(idx);
        }

        #[inline(always)]
        pub fn free_list_empty(&self) -> bool {
            self.free_list.is_empty()
        }

        #[inline(always)]
        pub fn free_list_len(&self) -> usize {
            self.free_list.len()
        }

        #[inline(always)]
        pub fn set_hash(&mut self, idx: usize, hash: u64) {
            self.hashes[idx] = hash;
        }

        #[inline(always)]
        pub fn get_hash(&self, idx: usize) -> u64 {
            self.hashes[idx]
        }

        #[inline(always)]
        pub fn set_rank(&mut self, idx: usize, rank: u8) {
            let old = self.rank[idx];
            self.rank[idx] = rank;
            self.count_sum = self.count_sum - old as u64 + rank as u64;
        }

        #[inline(always)]
        pub fn get_rank(&self, idx: usize) -> u8 {
            self.rank[idx]
        }

        #[inline(always)]
        pub fn decrement_rank(&mut self, idx: usize) {
            if self.rank[idx] > 0 {
                self.rank[idx] -= 1;
                self.count_sum -= 1;
            }
        }

        #[inline(always)]
        pub fn count_sum(&self) -> u64 {
            self.count_sum
        }

        #[inline(always)]
        pub fn cursor(&self) -> usize {
            self.cursor
        }

        #[inline(always)]
        pub fn advance_cursor(&mut self) {
            self.cursor = (self.cursor + 1) % self.capacity;
        }

        pub fn clear(&mut self) {
            self.free_list = (0..self.capacity).collect();
            self.rank.fill(0);
            self.cursor = 0;
            self.count_sum = 0;
        }
    }
}

mod storage {
    use std::sync::atomic::{AtomicU64, AtomicPtr, Ordering};
    use std::ptr;

    pub struct Node<K, V> {
        pub key: K,
        pub value: V,
        pub expire_at: u32,
        pub g_idx: u32,
    }

    pub struct Cache<K, V> {
        pub(crate) index_mask: usize,
        pub(crate) index: Box<[AtomicU64]>,
        pub(crate) nodes: Box<[AtomicPtr<Node<K, V>>]>,
    }

    unsafe impl<K: Send, V: Send> Send for Cache<K, V> {}
    unsafe impl<K: Send + Sync, V: Send + Sync> Sync for Cache<K, V> {}

    impl<K, V> Cache<K, V> {
        pub fn new(capacity: usize) -> Self {
            let index_size = (capacity * 2).next_power_of_two();
            let mut index = Vec::with_capacity(index_size);
            for _ in 0..index_size {
                index.push(AtomicU64::new(0));
            }

            let mut nodes = Vec::with_capacity(capacity);
            for _ in 0..capacity {
                nodes.push(AtomicPtr::new(ptr::null_mut()));
            }

            Self {
                index_mask: index_size - 1,
                index: index.into_boxed_slice(),
                nodes: nodes.into_boxed_slice(),
            }
        }

        #[inline(always)]
        pub fn index_probe(&self, hash: u64, tag: u16) -> Option<usize> {
            let mut idx = hash as usize & self.index_mask;
            for _ in 0..16 {
                let entry = self.index[idx].load(Ordering::Acquire);
                if entry == 0 {
                    return None;
                }
                if entry != u64::MAX && (entry >> 48) as u16 == tag {
                    return Some((entry & 0x0000_FFFF_FFFF_FFFF) as usize);
                }
                idx = (idx + 1) & self.index_mask;
            }
            None
        }

        #[inline(always)]
        pub fn index_store(&self, hash: u64, tag: u16, entry: u64) {
            let mut idx = hash as usize & self.index_mask;
            for i in 0..16 {
                let prev = self.index[idx].load(Ordering::Acquire);
                if prev == 0 || prev == u64::MAX || (prev >> 48) == (tag as u64) {
                    self.index[idx].store(entry, Ordering::Release);
                    return;
                }
                if i == 15 {
                    self.index[hash as usize & self.index_mask].store(entry, Ordering::Release);
                }
                idx = (idx + 1) & self.index_mask;
            }
        }

        #[inline(always)]
        pub fn index_remove(&self, hash: u64, tag: u16, g_idx: usize) {
            let mut idx = hash as usize & self.index_mask;
            for _ in 0..16 {
                let entry = self.index[idx].load(Ordering::Acquire);
                if entry == 0 {
                    return;
                }
                if entry != u64::MAX && (entry >> 48) as u16 == tag && (entry & 0x0000_FFFF_FFFF_FFFF) == (g_idx as u64) {
                    self.index[idx].store(u64::MAX, Ordering::Release);
                    return;
                }
                idx = (idx + 1) & self.index_mask;
            }
        }

        #[inline(always)]
        pub fn index_clear_at(&self, idx: usize) {
            self.index[idx].store(0, Ordering::Relaxed);
        }

        #[inline(always)]
        pub fn index_len(&self) -> usize {
            self.index.len()
        }

        #[inline(always)]
        pub fn node_get_full(&self, idx: usize, key: &K, current_epoch: u32) -> Option<V>
        where K: Eq, V: Clone
        {
            let ptr = self.nodes[idx].load(Ordering::Acquire);
            if ptr.is_null() {
                return None;
            }
            // Safety: QSBR guarantees pointer is valid during check-in.
            let node = unsafe { &*ptr };
            if node.key == *key {
                if node.expire_at > 0 && node.expire_at < current_epoch {
                    return None;
                }
                Some(node.value.clone())
            } else {
                None
            }
        }

        pub fn clear(&self) {
            for i in 0..self.index.len() {
                self.index[i].store(0, Ordering::Relaxed);
            }
            for i in 0..self.nodes.len() {
                self.nodes[i].store(ptr::null_mut(), Ordering::Release);
            }
        }
    }
}

mod filters {
    use std::sync::atomic::{AtomicPtr, Ordering};
    use std::ptr;
    use crate::unsafe_core::Node;

    pub struct T1<K, V> {
        pub(crate) mask: usize,
        pub(crate) slots: Box<[AtomicPtr<Node<K, V>>]>,
    }

    unsafe impl<K: Send, V: Send> Send for T1<K, V> {}
    unsafe impl<K: Send + Sync, V: Send + Sync> Sync for T1<K, V> {}

    impl<K, V> T1<K, V> {
        pub fn new(slots_count: usize) -> Self {
            let mut slots = Vec::with_capacity(slots_count);
            for _ in 0..slots_count {
                slots.push(AtomicPtr::new(ptr::null_mut()));
            }
            Self {
                mask: slots_count - 1,
                slots: slots.into_boxed_slice(),
            }
        }

        #[inline(always)]
        pub fn load_slot(&self, hash: u64) -> *mut Node<K, V> {
            let idx = hash as usize & self.mask;
            self.slots[idx].load(Ordering::Acquire)
        }

        #[inline(always)]
        pub fn store_slot(&self, hash: u64, ptr: *mut Node<K, V>) {
            let idx = hash as usize & self.mask;
            self.slots[idx].store(ptr, Ordering::Release);
        }

        #[inline(always)]
        pub fn clear_if_matches(&self, hash: u64, expected_ptr: *mut Node<K, V>) {
            let idx = hash as usize & self.mask;
            let _ = self.slots[idx].compare_exchange(
                expected_ptr,
                ptr::null_mut(),
                Ordering::Release,
                Ordering::Relaxed,
            );
        }

        #[inline(always)]
        pub fn clear_at(&self, idx: usize) {
            self.slots[idx].store(ptr::null_mut(), Ordering::Relaxed);
        }

        #[inline(always)]
        pub fn len(&self) -> usize {
            self.slots.len()
        }
    }

    pub struct T2<K, V> {
        pub(crate) mask: usize,
        pub(crate) slots: Box<[AtomicPtr<Node<K, V>>]>,
    }

    unsafe impl<K: Send, V: Send> Send for T2<K, V> {}
    unsafe impl<K: Send + Sync, V: Send + Sync> Sync for T2<K, V> {}

    impl<K, V> T2<K, V> {
        pub fn new(slots_count: usize) -> Self {
            let mut slots = Vec::with_capacity(slots_count);
            for _ in 0..slots_count {
                slots.push(AtomicPtr::new(ptr::null_mut()));
            }
            Self {
                mask: slots_count - 1,
                slots: slots.into_boxed_slice(),
            }
        }

        #[inline(always)]
        pub fn load_slot(&self, hash: u64) -> *mut Node<K, V> {
            let idx = hash as usize & self.mask;
            self.slots[idx].load(Ordering::Acquire)
        }

        #[inline(always)]
        pub fn store_slot(&self, hash: u64, ptr: *mut Node<K, V>) {
            let idx = hash as usize & self.mask;
            self.slots[idx].store(ptr, Ordering::Release);
        }

        #[inline(always)]
        pub fn clear_if_matches(&self, hash: u64, expected_ptr: *mut Node<K, V>) {
            let idx = hash as usize & self.mask;
            let _ = self.slots[idx].compare_exchange(
                expected_ptr,
                ptr::null_mut(),
                Ordering::Release,
                Ordering::Relaxed,
            );
        }

        #[inline(always)]
        pub fn clear_at(&self, idx: usize) {
            self.slots[idx].store(ptr::null_mut(), Ordering::Relaxed);
        }

        #[inline(always)]
        pub fn len(&self) -> usize {
            self.slots.len()
        }
    }
}

mod workers {
    use std::cell::UnsafeCell;
    use std::mem::MaybeUninit;

    /// Zero-allocation batch buffer: fixed-size MaybeUninit array, reused in-place.
    /// No Mutex, no Vec, no heap allocation on the hot path.
    #[cfg_attr(any(target_arch = "aarch64", target_arch = "arm"), repr(C, align(128)))]
    #[cfg_attr(not(any(target_arch = "aarch64", target_arch = "arm")), repr(C, align(64)))]
    pub struct BatchBuf<K, V> {
        items: [MaybeUninit<(K, V, u64)>; 32],
        len: usize,
    }

    impl<K, V> BatchBuf<K, V> {
        pub fn new() -> Self {
            Self {
                items: unsafe { MaybeUninit::uninit().assume_init() },
                len: 0,
            }
        }

        #[inline(always)]
        pub fn push(&mut self, item: (K, V, u64)) -> bool {
            self.items[self.len] = MaybeUninit::new(item);
            self.len += 1;
            self.len == 32
        }

        pub fn len(&self) -> usize {
            self.len
        }

        pub fn drain_to_vec(&mut self) -> Vec<(K, V, u64)> {
            let mut batch = Vec::with_capacity(self.len);
            for i in 0..self.len {
                batch.push(unsafe { self.items[i].assume_init_read() });
            }
            self.len = 0;
            batch
        }
    }

    impl<K, V> Drop for BatchBuf<K, V> {
        fn drop(&mut self) {
            for i in 0..self.len {
                unsafe {
                    self.items[i].assume_init_drop();
                }
            }
        }
    }

    unsafe impl<K: Send, V: Send> Send for BatchBuf<K, V> {}
    unsafe impl<K: Sync, V: Sync> Sync for BatchBuf<K, V> {}

    #[cfg_attr(any(target_arch = "aarch64", target_arch = "arm"), repr(C, align(128)))]
    #[cfg_attr(not(any(target_arch = "aarch64", target_arch = "arm")), repr(C, align(64)))]
    pub struct WorkerSlot<K, V> {
        inner: UnsafeCell<BatchBuf<K, V>>,
    }

    impl<K, V> WorkerSlot<K, V> {
        pub fn new() -> Self {
            Self {
                inner: UnsafeCell::new(BatchBuf::new()),
            }
        }

        /// Provides exclusive access to the underlying buffer.
        /// Safety: The caller must ensure that only one thread accesses this slot at a time.
        /// In DualCache-FF, this is guaranteed by the WORKER_ID invariant.
        #[inline(always)]
        pub unsafe fn get_mut_unchecked(&self) -> &mut BatchBuf<K, V> {
            unsafe { &mut *self.inner.get() }
        }
    }

    unsafe impl<K: Send, V: Send> Send for WorkerSlot<K, V> {}
    unsafe impl<K: Send + Sync, V: Send + Sync> Sync for WorkerSlot<K, V> {}
}
