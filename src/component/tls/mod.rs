use ::core::sync::atomic::Ordering;
use core::cell::UnsafeCell;
#[repr(C, align(64))]
pub struct TlsHandle {
    pub id: usize,
    pub qsbr_node: *mut crate::core::qsbr::ThreadStateNode,
    pub block_ptr: *mut core::ffi::c_void,
    pub registry: Option<alloc::sync::Arc<dyn crate::core::qsbr::RegistryCore>>,
}
unsafe impl Send for TlsHandle {}
unsafe impl Sync for TlsHandle {}
impl Drop for TlsHandle {
    #[inline(always)]
    fn drop(&mut self) {
        if !self.qsbr_node.is_null() {
            unsafe {
                (*self.qsbr_node).active.store(false, Ordering::Release);
            }
        }
        if let Some(reg) = &self.registry {
            reg.free_id(self.id);
        }
    }
}
#[derive(Clone)]
#[repr(C, align(64))]
pub struct TlsEntry<K, V> {
    pub hash: usize,
    pub key: K,
    pub value: V,
    pub hits: u8,
}
#[repr(C, align(64))]
pub struct TlsCache<K, V, const TLS_CAP: usize, const TLS_INDEX_CAP: usize> {
    pub slots: alloc::boxed::Box<[Option<TlsEntry<K, V>>]>,
    pub capacity: usize,
    pub promote_threshold: u8,
    pub probation_filter: alloc::boxed::Box<[u8; 16384]>,
    pub probation_cursor: usize,
}
impl<K: Clone + Eq, V: Clone, const TLS_CAP: usize, const TLS_INDEX_CAP: usize> Default
    for TlsCache<K, V, TLS_CAP, TLS_INDEX_CAP>
{
    fn default() -> Self {
        Self::new(2)
    }
}
impl<K: Clone + Eq, V: Clone, const TLS_CAP: usize, const TLS_INDEX_CAP: usize>
    TlsCache<K, V, TLS_CAP, TLS_INDEX_CAP>
{
    pub fn new(promote_threshold: u8) -> Self {
        let mut slots_vec = alloc::vec::Vec::with_capacity(TLS_CAP);
        for _ in 0..TLS_CAP {
            slots_vec.push(None);
        }
        Self {
            slots: slots_vec.into_boxed_slice(),
            capacity: TLS_CAP,
            promote_threshold,
            probation_filter: alloc::boxed::Box::new([0; 16384]),
            probation_cursor: 0,
        }
    }
    #[inline(always)]
    pub fn get(&mut self, hash: usize, key: &K) -> (Option<V>, bool, u8) {
        let idx = hash & (self.capacity - 1);
        if let Some(entry) = unsafe { self.slots.get_unchecked_mut(idx) }
            && entry.hash == hash
            && entry.key == *key
        {
            let old_hits = entry.hits;
            entry.hits = entry.hits.saturating_add(1);
            let promote = old_hits < self.promote_threshold && entry.hits >= self.promote_threshold;
            let sync = if entry.hits & 15 == 0 { 1 } else { 0 };
            return (Some(entry.value.clone()), promote, sync);
        }
        (None, false, 0)
    }
    #[inline(always)]
    pub fn insert(&mut self, hash: usize, key: K, value: V) -> u8 {
        let filter_idx = hash & 16383;
        self.probation_cursor = self.probation_cursor.wrapping_add(1);
        let decay_idx = self.probation_cursor & 16383;
        unsafe {
            *self.probation_filter.get_unchecked_mut(decay_idx) = 0;
        }
        let count = unsafe { *self.probation_filter.get_unchecked(filter_idx) }.saturating_add(1);
        unsafe {
            *self.probation_filter.get_unchecked_mut(filter_idx) = count;
        }
        if count < self.promote_threshold {
            return 0;
        }
        let idx = hash & (self.capacity - 1);
        if let Some(entry) = unsafe { self.slots.get_unchecked_mut(idx) }
            && entry.hash == hash
            && entry.key == key
        {
            entry.value = value;
            return 2;
        }
        unsafe {
            *self.slots.get_unchecked_mut(idx) = Some(TlsEntry {
                hash,
                key,
                value,
                hits: 0,
            });
        }
        1
    }
    #[inline(always)]
    pub fn insert_fast_pass(&mut self, hash: usize, key: K, value: V) {
        let idx = hash & (self.capacity - 1);
        let hits = self.promote_threshold;
        unsafe {
            *self.slots.get_unchecked_mut(idx) = Some(TlsEntry {
                hash,
                key,
                value,
                hits,
            });
        }
    }
    pub fn record_remote_hit(&mut self, hash: usize, weight: u8) {
        let idx = hash & (self.capacity - 1);
        if let Some(entry) = unsafe { self.slots.get_unchecked_mut(idx) }
            && entry.hash == hash
        {
            entry.hits = entry.hits.saturating_add(weight);
        }
    }
}
#[cfg(feature = "std")]
use crate::component::daemon::DaemonMessage;
#[doc = " A block of TLS data representing the state for a single thread."]
#[repr(C, align(64))]
pub struct TlsBlock<K, V, const TLS_CAP: usize, const TLS_INDEX_CAP: usize> {
    pub id: usize,
    pub cache: TlsCache<K, V, TLS_CAP, TLS_INDEX_CAP>,
    #[cfg(feature = "std")]
    pub tx: Option<
        std::sync::Arc<
            no_std_tool::collections::mpsc_queue::BoundedQueue<DaemonMessage<K, V>, 65536>,
        >,
    >,
    #[cfg(feature = "std")]
    pub hit_rx: Option<
        std::sync::Arc<no_std_tool::collections::mpsc_queue::BoundedQueue<(usize, u8), 1024>>,
    >,
    pub op_count: u64,
    pub hit_count: u64,
    #[cfg(feature = "std")]
    pub hit_batch: [(usize, u8); 32],
    #[cfg(feature = "std")]
    pub hit_batch_len: u8,
    pub warmup_state: u16,
    pub qsbr_node: crate::core::qsbr::ThreadStateNode,
    pub registered: bool,
}
impl<K: Clone + Eq, V: Clone, const TLS_CAP: usize, const TLS_INDEX_CAP: usize> Default
    for TlsBlock<K, V, TLS_CAP, TLS_INDEX_CAP>
{
    fn default() -> Self {
        Self::new(2)
    }
}
impl<K: Clone + Eq, V: Clone, const TLS_CAP: usize, const TLS_INDEX_CAP: usize>
    TlsBlock<K, V, TLS_CAP, TLS_INDEX_CAP>
{
    pub fn new(promote_threshold: u8) -> Self {
        Self {
            id: 0,
            cache: TlsCache::new(promote_threshold),
            #[cfg(feature = "std")]
            tx: None,
            #[cfg(feature = "std")]
            hit_rx: None,
            op_count: 0,
            hit_count: 0,
            #[cfg(feature = "std")]
            hit_batch: [(0, 0); 32],
            #[cfg(feature = "std")]
            hit_batch_len: 0,
            warmup_state: 0,
            qsbr_node: crate::core::qsbr::ThreadStateNode::new(),
            registered: false,
        }
    }
}
#[repr(C, align(64))]
pub struct TlsRegistryState<K, V, const TLS_CAP: usize, const TLS_INDEX_CAP: usize> {
    #[allow(clippy::type_complexity)]
    blocks: no_std_tool::sync::SpinMutex<
        alloc::vec::Vec<
            alloc::boxed::Box<
                UnsafeCell<no_std_tool::sync::CachePadded<TlsBlock<K, V, TLS_CAP, TLS_INDEX_CAP>>>,
            >,
        >,
    >,
    free_list: no_std_tool::sync::SpinMutex<alloc::vec::Vec<usize>>,
}
impl<K: Send + 'static, V: Send + 'static, const TLS_CAP: usize, const TLS_INDEX_CAP: usize>
    crate::core::qsbr::RegistryCore for TlsRegistryState<K, V, TLS_CAP, TLS_INDEX_CAP>
{
    fn free_id(&self, id: usize) {
        if let Ok(mut free_list) = self.free_list.lock() {
            free_list.push(id);
        }
    }
}
unsafe impl<K, V, const TLS_CAP: usize, const TLS_INDEX_CAP: usize> Send
    for TlsRegistryState<K, V, TLS_CAP, TLS_INDEX_CAP>
{
}
unsafe impl<K, V, const TLS_CAP: usize, const TLS_INDEX_CAP: usize> Sync
    for TlsRegistryState<K, V, TLS_CAP, TLS_INDEX_CAP>
{
}
#[doc = " Registry for managing Thread-Local Caches dynamically without OS TLS."]
#[repr(C, align(64))]
pub struct TlsRegistry<K, V, const TLS_CAP: usize, const TLS_INDEX_CAP: usize> {
    state: alloc::sync::Arc<TlsRegistryState<K, V, TLS_CAP, TLS_INDEX_CAP>>,
    promote_threshold: u8,
}
unsafe impl<K, V, const TLS_CAP: usize, const TLS_INDEX_CAP: usize> Sync
    for TlsRegistry<K, V, TLS_CAP, TLS_INDEX_CAP>
{
}
unsafe impl<K, V, const TLS_CAP: usize, const TLS_INDEX_CAP: usize> Send
    for TlsRegistry<K, V, TLS_CAP, TLS_INDEX_CAP>
{
}
impl<K, V, const TLS_CAP: usize, const TLS_INDEX_CAP: usize>
    TlsRegistry<K, V, TLS_CAP, TLS_INDEX_CAP>
{
    #[cfg(feature = "std")]
    pub fn clear_channels(&self) {
        let blocks = self.state.blocks.lock().unwrap();
        for i in 0..blocks.len() {
            let block = unsafe { &mut *blocks[i].get() };
            block.value.tx = None;
            block.value.hit_rx = None;
        }
    }
}
impl<
    K: Clone + Eq + 'static + Send,
    V: Clone + 'static + Send,
    const TLS_CAP: usize,
    const TLS_INDEX_CAP: usize,
> Default for TlsRegistry<K, V, TLS_CAP, TLS_INDEX_CAP>
{
    fn default() -> Self {
        Self::new()
    }
}
impl<
    K: Clone + Eq + 'static + Send,
    V: Clone + 'static + Send,
    const TLS_CAP: usize,
    const TLS_INDEX_CAP: usize,
> TlsRegistry<K, V, TLS_CAP, TLS_INDEX_CAP>
{
    pub fn new() -> Self {
        let blocks = alloc::vec::Vec::with_capacity(64);
        let free_list = alloc::vec::Vec::with_capacity(64);
        Self {
            state: alloc::sync::Arc::new(TlsRegistryState {
                blocks: no_std_tool::sync::SpinMutex::new(blocks),
                free_list: no_std_tool::sync::SpinMutex::new(free_list),
            }),
            promote_threshold: crate::covopt_param!("T0_PROMOTE_THRESH", 2u8, 1..10) as u8,
        }
    }
    pub fn max_threads(&self) -> usize {
        self.state.blocks.lock().unwrap().len()
    }
    pub fn get_metrics(&self) -> (u64, u64) {
        let mut total_ops = 0;
        let mut total_hits = 0;
        let blocks = self.state.blocks.lock().unwrap();
        for i in 0..blocks.len() {
            let block = unsafe { &*blocks[i].get() };
            if block.value.qsbr_node.active.load(Ordering::Relaxed) {
                total_ops += block.value.op_count;
                total_hits += block.value.hit_count;
            }
        }
        (total_ops, total_hits)
    }
    pub fn register_thread(&self) -> TlsHandle {
        let mut id = usize::MAX;
        if let Ok(mut free_list) = self.state.free_list.lock()
            && let Some(free_id) = free_list.pop()
        {
            id = free_id;
        }
        if id == usize::MAX {
            let new_block =
                alloc::boxed::Box::new(UnsafeCell::new(no_std_tool::sync::CachePadded {
                    value: TlsBlock::new(self.promote_threshold),
                }));
            let mut blocks = loop {
                if let Ok(guard) = self.state.blocks.lock() {
                    break guard;
                }
                core::hint::spin_loop();
            };
            id = blocks.len();
            blocks.push(new_block);
        }
        let blocks = loop {
            if let Ok(guard) = self.state.blocks.lock() {
                break guard;
            }
            core::hint::spin_loop();
        };
        let block = unsafe { &mut (*blocks[id].get()).value };
        let qsbr_node = &mut block.qsbr_node as *mut _;
        let block_ptr = block as *mut _ as *mut core::ffi::c_void;
        let registry_arc =
            self.state.clone() as alloc::sync::Arc<dyn crate::core::qsbr::RegistryCore>;
        if !block.registered {
            crate::core::qsbr::register_node(qsbr_node);
            block.registered = true;
        } else {
            unsafe { (*qsbr_node).active.store(true, Ordering::Release) };
        }
        TlsHandle {
            id,
            qsbr_node,
            block_ptr,
            registry: Some(registry_arc),
        }
    }
    pub fn deregister_thread(&self, handle: &TlsHandle) {
        if let Ok(mut free_list) = self.state.free_list.lock() {
            free_list.push(handle.id);
        }
    }
    #[inline]
    #[allow(clippy::mut_from_ref)]
    pub fn get_block_mut(&self, handle: &TlsHandle) -> &mut TlsBlock<K, V, TLS_CAP, TLS_INDEX_CAP> {
        if handle.block_ptr.is_null() {
            let blocks = self.state.blocks.lock().unwrap();
            unsafe { &mut (*blocks[handle.id].get()).value }
        } else {
            unsafe { &mut *(handle.block_ptr as *mut TlsBlock<K, V, TLS_CAP, TLS_INDEX_CAP>) }
        }
    }
}
