#[cfg(not(feature = "std"))]
use alloc::{boxed::Box, vec::Vec};

use crate::sync::{Arc, ArcSlice, new_arc_slice};
use crate::sync::atomic::{AtomicBool, AtomicU16, AtomicU32, Ordering};
use core::hash::Hash;

use crate::arena::Arena;
use crate::storage::{Cache, Node};
use crate::filters::{T1, T2};
use crate::components::GLOBAL_EPOCH;

const MAX_RANK: u8 = 3;

/// Core data plane encapsulating wait-free data structures and their single-writer mutation logic.
pub struct CoreCache<K, V> {
    pub arena: Arena,
    pub t1: Arc<T1<K, V>>,
    pub t2: Arc<T2<K, V>>,
    pub cache: Arc<Cache<K, V>>,
    pub admission: Arc<AdmissionFilter>,
    pub garbage_queue: Vec<(*mut Node<K, V>, usize, bool)>,
    pub registry_garbage_queue: Vec<(u32, *mut crate::registry::RegistryInner<K, V>)>,
    pub hit_accumulator: Vec<usize>,
    pub is_cold_start: Arc<AtomicBool>,
    pub epoch: Arc<AtomicU32>,
    pub duration: u32,
    pub registry: Arc<crate::registry::ThreadRegistry<K, V>>,
    pub on_evict: Option<Arc<dyn Fn(K, V) + Send + Sync>>,
    pub on_promote: Option<Arc<dyn Fn(K, V) + Send + Sync>>,
}

unsafe impl<K: Send, V: Send> Send for CoreCache<K, V> {}

impl<K, V> Drop for CoreCache<K, V> {
    fn drop(&mut self) {
        for &(ptr, _, is_eviction) in &self.garbage_queue {
            unsafe {
                let node = alloc::boxed::Box::from_raw(ptr);
                if is_eviction {
                    if let Some(cb) = &self.on_evict {
                        cb(node.key, node.value);
                    }
                }
            }
        }
        for &(_, ptr) in &self.registry_garbage_queue {
            unsafe {
                let _ = alloc::boxed::Box::from_raw(ptr);
            }
        }
    }
}

impl<K, V> CoreCache<K, V>
where
    K: Hash + Eq + Send + Sync + Clone + 'static,
    V: Send + Sync + Clone + 'static,
{
    #[allow(clippy::too_many_arguments)]
    pub fn new(
        capacity: usize,
        t1: Arc<T1<K, V>>,
        t2: Arc<T2<K, V>>,
        cache: Arc<Cache<K, V>>,
        epoch: Arc<AtomicU32>,
        duration: u32,
        registry: Arc<crate::registry::ThreadRegistry<K, V>>,
        is_cold_start: Arc<AtomicBool>,
        on_evict: Option<Arc<dyn Fn(K, V) + Send + Sync>>,
        on_promote: Option<Arc<dyn Fn(K, V) + Send + Sync>>,
    ) -> Self {
        Self {
            arena: Arena::new(capacity),
            t1,
            t2,
            cache,
            admission: Arc::new(AdmissionFilter::new(capacity)),
            garbage_queue: Vec::new(),
            registry_garbage_queue: Vec::new(),
            hit_accumulator: Vec::with_capacity(8192),
            is_cold_start,
            epoch,
            duration,
            registry,
            on_evict,
            on_promote,
        }
    }

    #[inline(always)]
    pub fn handle_admission_insert(&mut self, k: K, v: V, hash: u64, is_t1: bool) {
        if is_t1 {
            self.handle_insert_t1(k, v, hash);
            return;
        }
        let cold_start = self.arena.free_list_len() > self.arena.capacity / 20;
        self.is_cold_start.store(cold_start, Ordering::Relaxed);
        if cold_start || self.admission.check_ghost(hash) {
            self.handle_insert_with_hash(k, v, hash);
        }
    }

    #[inline(always)]
    pub fn handle_insert_with_hash(&mut self, k: K, v: V, hash: u64) {
        let tag = (hash >> 48) as u16;

        let global_idx = if let Some(existing_idx) = self.cache.index_probe(hash, tag) {
            existing_idx
        } else {
            if self.arena.free_list_empty() {
                self.evict_batch();
            }
            if let Some(new_idx) = self.arena.pop_free_slot() {
                new_idx
            } else {
                return;
            }
        };

        let entry = (tag as u64) << 48 | (global_idx as u64 & 0x0000_FFFF_FFFF_FFFF);

        let node_ptr = Box::into_raw(Box::new(Node {
            key: k,
            value: v,
            expire_at: self.epoch.load(Ordering::Relaxed) + self.duration,
            g_idx: global_idx as u32,
        }));

        let old_ptr = self.cache.nodes[global_idx].swap(node_ptr, Ordering::Release);
        if !old_ptr.is_null() {
            let epoch = GLOBAL_EPOCH.load(Ordering::Relaxed);
            self.garbage_queue.push((old_ptr, epoch, false));
        }

        self.cache.index_store(hash, tag, entry);
        self.arena.set_hash(global_idx, hash);
        self.arena.set_rank(global_idx, MAX_RANK);
    }

    pub fn handle_insert_t2(&mut self, k: K, v: V, hash: u64) {
        let tag = (hash >> 48) as u16;
        let global_idx = if let Some(idx) = self.cache.index_probe(hash, tag) {
            idx
        } else {
            if self.arena.free_list_empty() {
                self.evict_batch();
            }
            if let Some(new_idx) = self.arena.pop_free_slot() {
                new_idx
            } else {
                return;
            }
        };

        let entry = (tag as u64) << 48 | (global_idx as u64 & 0x0000_FFFF_FFFF_FFFF);

        let node_ptr = Box::into_raw(Box::new(Node {
            key: k,
            value: v,
            expire_at: self.epoch.load(Ordering::Relaxed) + self.duration,
            g_idx: global_idx as u32,
        }));

        let old_ptr = self.cache.nodes[global_idx].swap(node_ptr, Ordering::Release);
        if !old_ptr.is_null() {
            let epoch = GLOBAL_EPOCH.load(Ordering::Relaxed);
            self.garbage_queue.push((old_ptr, epoch, false));
        }

        self.cache.index_store(hash, tag, entry);
        self.arena.set_hash(global_idx, hash);
        self.arena.set_rank(global_idx, MAX_RANK);
        self.t2.store_slot(hash, node_ptr);
    }

    pub fn handle_insert_core(&mut self, k: K, v: V, hash: u64) {
        let tag = (hash >> 48) as u16;
        let global_idx = if let Some(idx) = self.cache.index_probe(hash, tag) {
            idx
        } else {
            if self.arena.free_list_empty() {
                self.evict_batch();
            }
            if let Some(new_idx) = self.arena.pop_free_slot() {
                new_idx
            } else {
                return;
            }
        };

        let entry = (tag as u64) << 48 | (global_idx as u64 & 0x0000_FFFF_FFFF_FFFF);

        let node_ptr = Box::into_raw(Box::new(Node {
            key: k,
            value: v,
            expire_at: self.epoch.load(Ordering::Relaxed) + self.duration,
            g_idx: global_idx as u32,
        }));

        let old_ptr = self.cache.nodes[global_idx].swap(node_ptr, Ordering::Release);
        if !old_ptr.is_null() {
            let epoch = GLOBAL_EPOCH.load(Ordering::Relaxed);
            self.garbage_queue.push((old_ptr, epoch, false));
        }

        self.cache.index_store(hash, tag, entry);
        self.arena.set_hash(global_idx, hash);
        self.arena.set_rank(global_idx, MAX_RANK);
    }

    pub fn handle_insert_with_rank(&mut self, k: K, v: V, hash: u64, tier: crate::daemon::CacheTier, rank: u8) {
        let tag = (hash >> 48) as u16;
        let global_idx = if let Some(idx) = self.cache.index_probe(hash, tag) {
            idx
        } else {
            if self.arena.free_list_empty() {
                self.evict_batch();
            }
            if let Some(new_idx) = self.arena.pop_free_slot() {
                new_idx
            } else {
                return;
            }
        };

        let entry = (tag as u64) << 48 | (global_idx as u64 & 0x0000_FFFF_FFFF_FFFF);

        let node_ptr = Box::into_raw(Box::new(Node {
            key: k,
            value: v,
            expire_at: self.epoch.load(Ordering::Relaxed) + self.duration,
            g_idx: global_idx as u32,
        }));

        let old_ptr = self.cache.nodes[global_idx].swap(node_ptr, Ordering::Release);
        if !old_ptr.is_null() {
            let epoch = GLOBAL_EPOCH.load(Ordering::Relaxed);
            self.garbage_queue.push((old_ptr, epoch, false));
        }

        self.cache.index_store(hash, tag, entry);
        self.arena.set_hash(global_idx, hash);
        self.arena.set_rank(global_idx, rank);
        match tier {
            crate::daemon::CacheTier::Tier1 => self.t1.store_slot(hash, node_ptr),
            crate::daemon::CacheTier::Tier2 => self.t2.store_slot(hash, node_ptr),
            crate::daemon::CacheTier::Core => {}
        }
    }
    #[inline(always)]
    pub fn handle_insert_t1(&mut self, k: K, v: V, hash: u64) {
        let tag = (hash >> 48) as u16;

        let global_idx = if let Some(existing_idx) = self.cache.index_probe(hash, tag) {
            existing_idx
        } else {
            if self.arena.free_list_empty() {
                self.evict_batch();
            }
            if let Some(new_idx) = self.arena.pop_free_slot() {
                new_idx
            } else {
                return;
            }
        };

        let entry = (tag as u64) << 48 | (global_idx as u64 & 0x0000_FFFF_FFFF_FFFF);

        let node_ptr = Box::into_raw(Box::new(Node {
            key: k,
            value: v,
            expire_at: self.epoch.load(Ordering::Relaxed) + self.duration,
            g_idx: global_idx as u32,
        }));

        let old_cache_ptr = self.cache.nodes[global_idx].swap(node_ptr, Ordering::Release);
        if !old_cache_ptr.is_null() {
            let epoch = GLOBAL_EPOCH.load(Ordering::Relaxed);
            self.garbage_queue.push((old_cache_ptr, epoch, false));
        }

        self.t1.store_slot(hash, node_ptr);

        self.cache.index_store(hash, tag, entry);
        self.arena.set_hash(global_idx, hash);
        self.arena.set_rank(global_idx, 255);
    }

    #[inline(always)]
    pub fn handle_remove(&mut self, _k: K, hash: u64) {
        let tag = (hash >> 48) as u16;
        if let Some(g_idx) = self.cache.index_probe(hash, tag) {
            let old_ptr =
                self.cache.nodes[g_idx].swap(core::ptr::null_mut(), Ordering::Release);
            if !old_ptr.is_null() {
                let epoch = GLOBAL_EPOCH.load(Ordering::Relaxed);
                self.garbage_queue.push((old_ptr, epoch, true));
                self.t1.clear_if_matches(hash, old_ptr);
                self.t2.clear_if_matches(hash, old_ptr);
            }
            self.cache.index_remove(hash, tag, g_idx);
            self.arena.set_rank(g_idx, 0);
        }
    }

    pub fn handle_clear(&mut self) {
        self.cache.clear();
        for i in 0..self.t1.len() {
            self.t1.clear_at(i);
        }
        for i in 0..self.t2.len() {
            self.t2.clear_at(i);
        }
        self.admission.clear();
        self.arena.clear();
        self.is_cold_start.store(true, Ordering::Relaxed);
    }

    pub fn maintenance(&mut self) {
        let current_global = GLOBAL_EPOCH.load(Ordering::Relaxed);
        GLOBAL_EPOCH.store(current_global + 1, Ordering::Release);

        let mut min_active_epoch = current_global + 1;
        let inner = unsafe { &*self.registry.get_inner() };
        for state in inner.states.iter() {
            let local = state.local_epoch.load(Ordering::Acquire);
            if local != 0 && local < min_active_epoch {
                min_active_epoch = local;
            }
        }

        if !self.garbage_queue.is_empty() {
            self.garbage_queue.retain(|&(ptr, epoch, is_eviction)| {
                if epoch < min_active_epoch {
                    unsafe {
                        let node = *Box::from_raw(ptr);
                        if is_eviction {
                            if let Some(cb) = &self.on_evict {
                                cb(node.key, node.value);
                            }
                        }
                    };
                    false
                } else {
                    true
                }
            });
        }

        if !self.registry_garbage_queue.is_empty() {
            self.registry_garbage_queue.retain(|&(epoch, ptr)| {
                if epoch < min_active_epoch as u32 {
                    unsafe {
                        let _ = alloc::boxed::Box::from_raw(ptr);
                    }
                    false
                } else {
                    true
                }
            });
        }

        if !self.hit_accumulator.is_empty() {
            self.hit_accumulator.sort_unstable();

            for &g_idx in &self.hit_accumulator {
                self.arena.set_rank(g_idx, MAX_RANK);
                let hash = self.arena.get_hash(g_idx);
                let ptr = self.cache.nodes[g_idx].load(Ordering::Acquire);
                if !ptr.is_null() && self.t1.load_slot(hash) != ptr {
                    self.t1.store_slot(hash, ptr);
                }
            }
            self.hit_accumulator.clear();
        }

        if self.arena.free_list_len() < self.arena.capacity / 10 {
            self.evict_batch();
        }

        let cold_start = self.arena.free_list_len() > self.arena.capacity / 20;
        if self.is_cold_start.load(Ordering::Relaxed) != cold_start {
            self.is_cold_start.store(cold_start, Ordering::Relaxed);
        }
    }

    #[inline(always)]
    pub fn process_hits(&mut self, batch: &[usize]) {
        for &g_idx in batch.iter() {
            if g_idx < self.arena.capacity && g_idx != usize::MAX {
                self.hit_accumulator.push(g_idx);
            }
        }
    }

    pub fn evict_batch(&mut self) {
        let count = 128;
        let avg = (self.arena.count_sum() / self.arena.capacity as u64) as u8;
        let threshold = avg.max(1);

        for _ in 0..count {
            if self.arena.free_list_len() > self.arena.capacity / 10 {
                break;
            }

            let idx = self.arena.cursor();
            let r = self.arena.get_rank(idx);

            if r <= threshold {
                let hash = self.arena.get_hash(idx);
                let tag = (hash >> 48) as u16;

                let old_ptr =
                    self.cache.nodes[idx].swap(core::ptr::null_mut(), Ordering::Release);
                if !old_ptr.is_null() {
                    let epoch = GLOBAL_EPOCH.load(Ordering::Relaxed);
                    self.garbage_queue.push((old_ptr, epoch, true)); // Eviction by capacity
                    self.t1.clear_if_matches(hash, old_ptr);
                    self.t2.clear_if_matches(hash, old_ptr);
                }

                self.cache.index_remove(hash, tag, idx);

                self.admission.record_death(hash);
                self.arena.push_free_slot(idx);
                self.arena.set_rank(idx, 0);
            } else {
                self.arena.decrement_rank(idx);
            }
            self.arena.advance_cursor();
        }
    }
}

// impl<K, V> Drop for CoreCache<K, V> {
//     fn drop(&mut self) {
//         for &(ptr, _) in self.garbage_queue.iter() {
//             if !ptr.is_null() {
//                 unsafe {
//                     let _ = Box::from_raw(ptr);
//                 }
//             }
//         }
//     }
// }

pub struct AdmissionFilter {
    pub ghost_mask: usize,
    pub ghost_set: ArcSlice<AtomicU16>,
}

impl AdmissionFilter {
    pub fn new(capacity: usize) -> Self {
        let ghost_size = capacity.max(256);
        let mut ghost_vec = Vec::with_capacity(ghost_size);
        for _ in 0..ghost_size {
            ghost_vec.push(AtomicU16::new(0));
        }

        Self {
            ghost_mask: ghost_size - 1,
            ghost_set: new_arc_slice(ghost_vec),
        }
    }

    #[inline(always)]
    pub fn record_death(&self, hash: u64) {
        let fp = (hash >> 48) as u16;
        let idx = (hash as usize) & self.ghost_mask;
        self.ghost_set[idx].store(fp, Ordering::Relaxed);
    }

    #[inline(always)]
    pub fn check_ghost(&self, hash: u64) -> bool {
        let fp = (hash >> 48) as u16;
        let ghost_idx = (hash as usize) & self.ghost_mask;
        self.ghost_set[ghost_idx].load(Ordering::Relaxed) == fp
    }

    pub fn clear(&self) {
        for val in self.ghost_set.iter() {
            val.store(0, Ordering::Relaxed);
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::storage::Node;
    use alloc::boxed::Box;

    #[test]
    fn test_core_cache_drop() {
        let mut core = CoreCache::<u64, u64>::new(
            10,
            Arc::new(T1::new(10)),
            Arc::new(T2::new(10)),
            Arc::new(Cache::new(10)),
            Arc::new(AtomicU32::new(1)),
            200,
            Arc::new(crate::registry::ThreadRegistry::new(10)),
            Arc::new(AtomicBool::new(true)),
            Some(Arc::new(|_k, _v| {})),
            None,
        );

        // Add dummy node to garbage queue
        let ptr = Box::into_raw(Box::new(Node {
            key: 1,
            value: 1,
            expire_at: 0,
            g_idx: 0,
        }));
        core.garbage_queue.push((ptr, 0, true));

        // Add dummy registry to registry garbage queue
        let reg_ptr = Box::into_raw(Box::new(crate::registry::RegistryInner {
            states: vec![].into_boxed_slice(),
            buffers: vec![].into_boxed_slice(),
        }));
        core.registry_garbage_queue.push((0, reg_ptr));

        // Let core drop
        drop(core);
    }

    #[test]
    fn test_core_cache_insert_variations() {
        let mut core = CoreCache::<u64, u64>::new(
            10,
            Arc::new(T1::new(10)),
            Arc::new(T2::new(10)),
            Arc::new(Cache::new(10)),
            Arc::new(AtomicU32::new(1)),
            200,
            Arc::new(crate::registry::ThreadRegistry::new(10)),
            Arc::new(AtomicBool::new(true)),
            Some(Arc::new(|_k, _v| {})),
            None,
        );

        // 1. handle_insert_t2
        core.handle_insert_t2(1, 1, 1);
        // overwrite t2
        core.handle_insert_t2(1, 2, 1);
        
        // 2. handle_insert_core
        core.handle_insert_core(2, 2, 2);
        // overwrite core
        core.handle_insert_core(2, 3, 2);

        // 3. handle_insert_with_rank
        core.handle_insert_with_rank(3, 3, 3, crate::daemon::CacheTier::Tier1, 1);
        // overwrite with rank
        core.handle_insert_with_rank(3, 4, 3, crate::daemon::CacheTier::Tier2, 2);
        core.handle_insert_with_rank(3, 5, 3, crate::daemon::CacheTier::Core, 3);
        
        // Fill up arena to trigger evict_batch() inside handle_insert_with_hash
        for i in 10..20 {
            core.handle_insert_with_hash(i, i, i);
        }
        // now full, next insert triggers evict_batch
        core.handle_insert_with_hash(20, 20, 20);
        
        // Fill up to trigger evict_batch in other functions
        core.handle_insert_t2(21, 21, 21);
        core.handle_insert_core(22, 22, 22);
        core.handle_insert_with_rank(23, 23, 23, crate::daemon::CacheTier::Tier1, 1);
    }
}
