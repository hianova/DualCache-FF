#![cfg_attr(not(any(feature = "std", feature = "daemon", test)), no_std)]
extern crate alloc;
pub mod cache_trait;
pub mod component;
pub mod core;
pub mod utils;
#[cfg(feature = "std")]
use crate::component::daemon::DaemonMessage;
#[cfg(feature = "std")]
use crate::component::tls::{TlsHandle, TlsRegistry};
#[cfg(feature = "std")]
use ::core::sync::atomic::{AtomicBool, Ordering};
#[cfg(feature = "std")]
use alloc::sync::Arc;
#[macro_export]
macro_rules! covopt_param {
    ($ name : expr , $ default : expr) => {{
        #[cfg(feature = "covopt")]
        {
            if let Ok(val_str) = ::std::env::var(concat!("COVOPT_", $name)) {
                if let Ok(val) = val_str.parse() {
                    val
                } else {
                    $default
                }
            } else {
                $default
            }
        }
        #[cfg(not(feature = "covopt"))]
        {
            $default
        }
    }};
    ($ name : expr , $ default : expr , $ range : expr) => {{
        #[cfg(feature = "covopt")]
        {
            if let Ok(val_str) = ::std::env::var(concat!("COVOPT_", $name)) {
                if let Ok(val) = val_str.parse() {
                    val
                } else {
                    $default
                }
            } else {
                $default
            }
        }
        #[cfg(not(feature = "covopt"))]
        {
            $default
        }
    }};
}
#[doc = " Macro to easily define a `DualCacheFF` type alias by just specifying T0 (Global L2 capacity)"]
#[doc = " and TOTAL (Global L3 total capacity). The macro automatically derives T1 (1/6 of TOTAL) and T2 (5/6 of TOTAL)."]
#[doc = " Note: The L1 cache is strictly maintained by the Thread-Local TLS arrays, ensuring zero atomic overhead."]
#[macro_export]
macro_rules! define_dualcache {
    ($ name : ident , $ k : ty , $ v : ty , T0 = $ t0 : expr , TOTAL = $ total : expr) => {
        pub type $name = $crate::DualCacheFF<
            $k,
            $v,
            $crate::core::config::DefaultExponentialPolicy,
            $t0,
            { $total / 6 },
            { $total - ($total / 6) },
            65536,
            16,
            $total,
        >;
    };
}
#[doc = " Macro to easily define a `StaticDualCache` type alias by just specifying T0 and TOTAL."]
#[macro_export]
macro_rules! define_static_dualcache {
    ($ name : ident , $ k : ty , $ v : ty , $ policy : ty , T0 = $ t0 : expr , TOTAL = $ total : expr) => {
        pub type $name = $crate::core::static_cache::StaticDualCache<
            $k,
            $v,
            $policy,
            $t0,
            { $total / 6 },
            { $total - ($total / 6) },
            $total,
        >;
    };
}
#[doc = " Macro to easily define a `DualCacheCore` type alias by just specifying T0 and TOTAL."]
#[macro_export]
macro_rules! define_core_cache {
    ($ name : ident , $ k : ty , $ v : ty , $ policy : ty , T0 = $ t0 : expr , TOTAL = $ total : expr) => {
        pub type $name = $crate::core::engine::DualCacheCore<
            $k,
            $v,
            $policy,
            $t0,
            { $total / 6 },
            { $total - ($total / 6) },
            $total,
        >;
    };
}
#[cfg(feature = "std")]
#[doc = " `DualCacheFF` is the main entry point for the cache, providing standard API operations and managing the"]
#[doc = " background daemon for garbage collection and memory reclamation."]
pub type GlobalQueue<K, V> = no_std_tool::collections::mpsc_queue::BoundedQueue<DaemonMessage<K, V>, 65536>;

#[repr(align(64))]
#[repr(C)]
pub struct DualCacheFF<
    K,
    V,
    P: crate::core::config::CachePolicy + Send + Sync + 'static = crate::core::config::DefaultExponentialPolicy,
    const T0_CAP: usize = { covopt_param!("M_114_28", 131072) },
    const T1_CAP: usize = { covopt_param!("M_115_28", 16384) },
    const T2_CAP: usize = { covopt_param!("M_116_28", 262144) },
    const TLS_CAP: usize = { covopt_param!("M_117_29", 65536) },
    const TLS_INDEX_CAP: usize = { covopt_param!("M_118_35", 128) },
    const TOTAL_CAP: usize = { covopt_param!("M_119_31", 131072) + covopt_param!("M_119_40", 16384) + covopt_param!("M_119_48", 262144) },
> {
    pub core: alloc::boxed::Box<crate::core::DualCacheCore<K, V, P, T0_CAP, T1_CAP, T2_CAP, TOTAL_CAP>>,
    pub daemon_mode: AtomicBool,
    pub reclaim_lock: AtomicBool,
    #[cfg(feature = "std")]
    pub cata_mode: AtomicBool,
    pub warmup_step: u8,
    pub warmup_pct: usize,
    pub tls_registry: TlsRegistry<K, V, 65536, 128>,
    #[cfg(feature = "std")]
    pub global_tx: arc_swap::ArcSwapOption<GlobalQueue<K, V>>,
    #[cfg(feature = "std")]
    pub daemon_handle: arc_swap::ArcSwapOption<crate::component::daemon::Daemon>,
}
#[cfg(feature = "std")]
impl<
    K,
    V,
    P: crate::core::config::CachePolicy + Send + Sync + 'static,
    const T0_CAP: usize,
    const T1_CAP: usize,
    const T2_CAP: usize,
    const TLS_CAP: usize,
    const TLS_INDEX_CAP: usize,
    const TOTAL_CAP: usize,
> Default for DualCacheFF<K, V, P, T0_CAP, T1_CAP, T2_CAP, TLS_CAP, TLS_INDEX_CAP, TOTAL_CAP>
where
    K: Clone + Eq + ::core::hash::Hash + Send + Sync + 'static,
    V: Clone + Send + Sync + 'static,
{
    fn default() -> Self {
        Self::new()
    }
}
#[cfg(feature = "std")]
impl<
    K,
    V,
    P: crate::core::config::CachePolicy + Send + Sync + 'static,
    const T0_CAP: usize,
    const T1_CAP: usize,
    const T2_CAP: usize,
    const TLS_CAP: usize,
    const TLS_INDEX_CAP: usize,
    const TOTAL_CAP: usize,
> DualCacheFF<K, V, P, T0_CAP, T1_CAP, T2_CAP, TLS_CAP, TLS_INDEX_CAP, TOTAL_CAP>
where
    K: Clone + Eq + ::core::hash::Hash + Send + Sync + 'static,
    V: Clone + Send + Sync + 'static,
{
    pub fn new() -> Self {
        Self { core : crate :: core :: DualCacheCore :: new_boxed (P :: Evict :: default ()) , daemon_mode : AtomicBool :: new (false) , reclaim_lock : AtomicBool :: new (false) , # [cfg (feature = "std")] cata_mode : AtomicBool :: new (false) , warmup_step : crate :: covopt_param ! ("WARMUP_STEP" , 10 , 1 .. 20) , warmup_pct : crate :: covopt_param ! ("WARMUP_PCT" , 95 , 50 .. 100) , tls_registry : TlsRegistry :: new () , # [cfg (feature = "std")] global_tx : arc_swap :: ArcSwapOption :: empty () , # [cfg (feature = "std")] daemon_handle : arc_swap :: ArcSwapOption :: empty () , }
    }
    #[doc = " Start the CATA-DC Demiurge tuning engine in the background"]
    #[cfg(feature = "std")]
    pub fn set_cata_tuning(&'static self, on: bool) {
        if on
            && !self
                .cata_mode
                .swap(true, std::sync::atomic::Ordering::SeqCst)
        {
            crate::component::cata::spawn_demiurge(self);
        } else if !on {
            self.cata_mode
                .store(false, std::sync::atomic::Ordering::SeqCst);
        }
    }
    #[doc = " Turn the Daemon on or off."]
    #[doc = " If turned on, a new daemon thread is automatically spawned and channel is established."]
    #[cfg(feature = "std")]
    pub fn set_daemon_mode(&'static self, on: bool) {
        self.daemon_mode.store(on, Ordering::SeqCst);
        if on {
            let tx = unsafe {
                ::std::sync::Arc::<
                    no_std_tool::collections::mpsc_queue::BoundedQueue<DaemonMessage<K, V>, 65536>,
                >::new_zeroed()
                .assume_init()
            };
            let rx = tx.clone();
            let mut broadcast_txs = std::vec::Vec::with_capacity(self.tls_registry.max_threads());
            for i in 0..self.tls_registry.max_threads() {
                let dummy_handle = TlsHandle {
                    id: i,
                    qsbr_node: ::core::ptr::null_mut(),
                    block_ptr: ::core::ptr::null_mut(),
                    registry: None,
                };
                let block = unsafe { &mut *self.tls_registry.get_block_mut(&dummy_handle) };
                block.tx = Some(::std::sync::Arc::clone(&tx));
                let hit_queue = unsafe {
                    ::std::sync::Arc::<
                        no_std_tool::collections::mpsc_queue::BoundedQueue<(usize, u8), 1024>,
                    >::new_zeroed()
                    .assume_init()
                };
                block.hit_rx = Some(::std::sync::Arc::clone(&hit_queue));
                broadcast_txs.push(hit_queue);
            }
            let daemon_node = {
                let node = std::boxed::Box::into_raw(std::boxed::Box::new(
                    crate::core::qsbr::ThreadStateNode::new(),
                ));
                unsafe { crate::core::qsbr::register_node(node); }
                node
            };
            let daemon =
                crate::component::daemon::Daemon::spawn(&self.core, rx, broadcast_txs, daemon_node);
            self.daemon_handle.store(Some(Arc::new(daemon)));
            self.global_tx.store(Some(tx));
        } else {
            self.global_tx.store(None);
            self.tls_registry.clear_channels();
            if let Some(daemon) = self.daemon_handle.swap(None)
                && let Ok(mut d) = Arc::try_unwrap(daemon)
            {
                d.join();
            }
        }
    }
    #[doc = " Register the current thread to get a fast TLS handle."]
    pub fn register_thread(&self) -> TlsHandle {
        let handle = self.tls_registry.register_thread();
        #[cfg(feature = "std")]
        if let Some(global_tx) = self.global_tx.load_full() {
            let block = unsafe { &mut *self.tls_registry.get_block_mut(&handle) };
            block.tx = Some(global_tx);
        }
        handle
    }
    /// Safe get operation that automatically pins the QSBR node during execution
    #[inline(always)]
    pub fn get_safe(&self, key: &K, handle: &TlsHandle) -> Option<V> {
        let _pin = unsafe { crate::core::qsbr::pin(handle.qsbr_node) };
        self.get(key, handle)
    }

    #[inline(always)]
    pub fn get(&self, key: &K, handle: &TlsHandle) -> Option<V> {
        let block = unsafe { &mut *self.tls_registry.get_block_mut(handle) };
        block.op_count = block.op_count.wrapping_add(1);
        let op_count = block.op_count as u32;
        #[cfg(feature = "std")]
        if op_count & covopt_param!("M_263_22", 63) == 0 {
            let global = crate::core::qsbr::get_global_epoch();
            unsafe {
                let node = &mut *handle.qsbr_node;
                node.epoch
                    .store(global, ::core::sync::atomic::Ordering::Relaxed);
                node.active
                    .store(true, ::core::sync::atomic::Ordering::Relaxed);
            }
        }
        let hash = self.core.hash_key(key);
        let guard = ::core::mem::ManuallyDrop::new(unsafe {
            crate::core::qsbr::Guard::unpinned(handle.qsbr_node)
        });

        if let Some(val) = self.core.get_t0(hash, key, &guard, op_count) {
            block.warmup_state = block.warmup_state.saturating_add(self.warmup_step as u16);
            if op_count & covopt_param!("M_280_26", 63) == 0 {
                block.cache.insert_fast_pass(hash, key.clone(), val.clone());
            }
            return Some(val.clone());
        }
        if let Some(val) = self.core.get_t1(hash, key, &guard, op_count) {
            if op_count & covopt_param!("M_286_26", 127) == 0 {
                block.cache.insert_fast_pass(hash, key.clone(), val.clone());
            }
            return Some(val.clone());
        }
        let (val_opt, promote, _sync) = block.cache.get(hash, key);
        if let Some(val) = val_opt {
            if promote {
                unsafe { self.core.put_t0(key.clone(), val.clone(), handle.qsbr_node); }
            }
            #[cfg(feature = "std")]
            if _sync > 0 {
                if block.hit_batch_len < covopt_param!("M_298_41", 32) {
                    block.hit_batch[block.hit_batch_len as usize] = (hash, _sync);
                    block.hit_batch_len += 1;
                }
                if block.hit_batch_len == covopt_param!("M_302_42", 32) {
                    if let Some(ref tx) = block.tx {
                        let mut batch = [(0, 0); 32];
                        batch.copy_from_slice(&block.hit_batch[..covopt_param!("M_305_65", 32)]);
                        let _ =
                            tx.push(crate::component::daemon::DaemonMessage::HitBatch(std::boxed::Box::new((batch, covopt_param!("M_307_115", 32)))));
                    }
                    block.hit_batch_len = 0;
                }
            }
            return Some(val);
        }
        if let Some(val) = self.core.get_t2(hash, key, &guard, op_count) {
            block.warmup_state = block.warmup_state.saturating_sub(self.warmup_step as u16);
            block.cache.insert(hash, key.clone(), val.0.clone());
            return Some(val.0.clone());
        }
        None
    }
    pub fn insert(&self, key: K, value: V, handle: &TlsHandle) {
        let block = unsafe { &mut *self.tls_registry.get_block_mut(handle) };
        block.op_count = block.op_count.wrapping_add(1);
        if crate::utils::unlikely(block.op_count.is_multiple_of(covopt_param!("M_324_64", 64))) {
            if !self.daemon_mode.load(Ordering::Relaxed) {
                if self
                    .reclaim_lock
                    .compare_exchange(false, true, Ordering::Acquire, Ordering::Relaxed)
                    .is_ok()
                {
                    self.core.sync_reclaim();
                    self.reclaim_lock.store(false, Ordering::Release);
                }
            } else {
                self.core.try_reclaim(handle.qsbr_node);
            }
        }
        let hash = self.core.hash_key(&key);
        let res = block.cache.insert(hash, key.clone(), value.clone());
        if res == 1 {
            let pct = covopt_param!("M_341_22", 95);
            let is_warming_up = self.core.arena.allocated_count() < (self.core.arena.capacity() * pct / covopt_param!("M_342_104", 100));
            if is_warming_up || (block.op_count & covopt_param!("M_343_50", 127)) == 0 {
                unsafe { self.core.put(key, value, handle.qsbr_node, block.op_count as u32); }
            }
        } else if res == 2
            && (block.op_count & covopt_param!("M_347_33", 127)) == 0 {
                unsafe { self.core.put(key, value, handle.qsbr_node, block.op_count as u32); }
            }
    }
    #[doc = " Insert a key-value pair directly as a high-priority \"genius\" item."]
    #[doc = " This bypasses normal promotion and pins the item directly in the hottest tier (T0)."]
    #[doc = " Equivalent to 'insert_t1' or 'warmup' from v0.4.0."]
    pub fn warmup(&self, key: K, value: V, handle: &TlsHandle) {
        let block = unsafe { &mut *self.tls_registry.get_block_mut(handle) };
        block.op_count = block.op_count.wrapping_add(1);
        if crate::utils::unlikely(block.op_count.is_multiple_of(covopt_param!("M_357_64", 64))) {
            if !self.daemon_mode.load(Ordering::Relaxed) {
                if self
                    .reclaim_lock
                    .compare_exchange(false, true, Ordering::Acquire, Ordering::Relaxed)
                    .is_ok()
                {
                    self.core.sync_reclaim();
                    self.reclaim_lock.store(false, Ordering::Release);
                }
            } else {
                self.core.try_reclaim(handle.qsbr_node);
            }
        }
        let hash = self.core.hash_key(&key);
        block
            .cache
            .insert_fast_pass(hash, key.clone(), value.clone());
        unsafe { self.core.put_t0(key, value, handle.qsbr_node); }
    }
}
#[cfg(feature = "std")]
unsafe impl<
    K,
    V,
    P: crate::core::config::CachePolicy + Send + Sync + 'static,
    const T0_CAP: usize,
    const T1_CAP: usize,
    const T2_CAP: usize,
    const TLS_CAP: usize,
    const TLS_INDEX_CAP: usize,
    const TOTAL_CAP: usize,
> Send for DualCacheFF<K, V, P, T0_CAP, T1_CAP, T2_CAP, TLS_CAP, TLS_INDEX_CAP, TOTAL_CAP>
{}
#[cfg(feature = "std")]
unsafe impl<
    K,
    V,
    P: crate::core::config::CachePolicy + Send + Sync + 'static,
    const T0_CAP: usize,
    const T1_CAP: usize,
    const T2_CAP: usize,
    const TLS_CAP: usize,
    const TLS_INDEX_CAP: usize,
    const TOTAL_CAP: usize,
> Sync for DualCacheFF<K, V, P, T0_CAP, T1_CAP, T2_CAP, TLS_CAP, TLS_INDEX_CAP, TOTAL_CAP>
{}
#[cfg(feature = "std")]
impl<
    K,
    V,
    P: crate::core::config::CachePolicy + Send + Sync + 'static,
    const T0_CAP: usize,
    const T1_CAP: usize,
    const T2_CAP: usize,
    const TLS_CAP: usize,
    const TLS_INDEX_CAP: usize,
    const TOTAL_CAP: usize,
> DualCacheFF<K, V, P, T0_CAP, T1_CAP, T2_CAP, TLS_CAP, TLS_INDEX_CAP, TOTAL_CAP>
where
    K: Clone + Eq + Send + Sync + 'static,
    V: Clone + Send + Sync + 'static,
{
    pub fn get_metrics(&self) -> (u64, u64) {
        self.tls_registry.get_metrics()
    }
}
#[cfg(feature = "std")]
impl<
    K,
    V,
    P: crate::core::config::CachePolicy + Send + Sync + 'static,
    const T0_CAP: usize,
    const T1_CAP: usize,
    const T2_CAP: usize,
    const TLS_CAP: usize,
    const TLS_INDEX_CAP: usize,
    const TOTAL_CAP: usize,
> Drop for DualCacheFF<K, V, P, T0_CAP, T1_CAP, T2_CAP, TLS_CAP, TLS_INDEX_CAP, TOTAL_CAP>
{
    fn drop(&mut self) {
        self.daemon_mode
            .store(false, ::core::sync::atomic::Ordering::SeqCst);
        self.cata_mode
            .store(false, ::core::sync::atomic::Ordering::SeqCst);
        self.global_tx.store(None);
        self.tls_registry.clear_channels();
        if let Some(daemon) = self.daemon_handle.swap(None)
            && let Ok(mut d) = Arc::try_unwrap(daemon)
        {
            d.join();
        }
        unsafe {
            crate::core::qsbr::reset();
        }
    }
}
#[cfg(feature = "std")]
impl<
    K: Clone + Eq + ::core::hash::Hash + Send + Sync + 'static,
    V: Clone + Send + Sync + 'static,
    P: crate::core::config::CachePolicy + Send + Sync + 'static,
    const T0_CAP: usize,
    const T1_CAP: usize,
    const T2_CAP: usize,
    const TLS_CAP: usize,
    const TLS_INDEX_CAP: usize,
    const TOTAL_CAP: usize,
> crate::cache_trait::ConcurrentCache<K, V> for DualCacheFF<K, V, P, T0_CAP, T1_CAP, T2_CAP, TLS_CAP, TLS_INDEX_CAP, TOTAL_CAP>
{
    fn get(&self, key: &K) -> Option<V> {
        thread_local! { static THREAD_HANDLE : std :: cell :: OnceCell < crate :: component :: tls :: TlsHandle > = const { std :: cell :: OnceCell :: new () } ; }
        THREAD_HANDLE.with(|cell| {
            let handle = cell.get_or_init(|| self.register_thread());
            DualCacheFF::get(self, key, handle)
        })
    }
    fn put(&self, key: K, value: V) {
        thread_local! { static THREAD_HANDLE : std :: cell :: OnceCell < crate :: component :: tls :: TlsHandle > = const { std :: cell :: OnceCell :: new () } ; }
        THREAD_HANDLE.with(|cell| {
            let handle = cell.get_or_init(|| self.register_thread());
            DualCacheFF::insert(self, key, value, handle);
        })
    }
}
#[cfg(test)]
mod tests {
    use super::*;
    use std::thread;
    #[test]
    fn test_static_global_cache() {
        std::thread::Builder::new()
            .stack_size(covopt_param!("M_489_24", 32) * covopt_param!("M_489_29", 1024) * covopt_param!("M_489_36", 1024))
            .spawn(|| {
                static GLOBAL_CACHE: std::sync::LazyLock<DualCacheFF<u64, u64, crate::core::config::DefaultExponentialPolicy, 256, 1024, 2048, 1024>> =
                    std::sync::LazyLock::new(DualCacheFF::new);
                let handle = GLOBAL_CACHE.register_thread();
                GLOBAL_CACHE.insert(1, covopt_param!("M_494_39", 100), &handle);
                GLOBAL_CACHE.insert(1, covopt_param!("M_495_39", 100), &handle);
                assert_eq!(GLOBAL_CACHE.get(&1, &handle), Some(100));
            })
            .unwrap()
            .join()
            .unwrap();
    }
    #[test]
    fn test_daemon_off_sync() {
        std::thread::Builder::new()
            .stack_size(covopt_param!("M_505_24", 32) * covopt_param!("M_505_29", 1024) * covopt_param!("M_505_36", 1024))
            .spawn(|| {
                static CACHE: std::sync::LazyLock<DualCacheFF<u64, u64, crate::core::config::DefaultExponentialPolicy, 256, 1024, 2048, 4096>> =
                    std::sync::LazyLock::new(DualCacheFF::new);
                let handle = CACHE.register_thread();
                CACHE.insert(1, covopt_param!("M_510_32", 100), &handle);
                CACHE.insert(1, covopt_param!("M_511_32", 100), &handle);
                assert_eq!(CACHE.get(&1, &handle), Some(100));
                CACHE.insert(2, covopt_param!("M_513_32", 200), &handle);
                CACHE.insert(2, covopt_param!("M_514_32", 200), &handle);
                assert_eq!(CACHE.get(&2, &handle), Some(200));
            })
            .unwrap()
            .join()
            .unwrap();
    }
    #[cfg(feature = "std")]
    #[test]
    fn test_daemon_on_async() {
        std::thread::Builder::new()
            .stack_size(covopt_param!("M_525_24", 32) * covopt_param!("M_525_29", 1024) * covopt_param!("M_525_36", 1024))
            .spawn(|| {
                use std::time::Duration;
                static CACHE: std::sync::LazyLock<DualCacheFF<u64, u64, crate::core::config::DefaultExponentialPolicy, 8, 16, 64, 88>> =
                    std::sync::LazyLock::new(DualCacheFF::new);
                CACHE.set_daemon_mode(true);
                let handle = CACHE.register_thread();
                CACHE.insert(covopt_param!("M_532_29", 10), covopt_param!("M_532_33", 1000), &handle);
                CACHE.insert(covopt_param!("M_533_29", 10), covopt_param!("M_533_33", 1000), &handle);
                for i in covopt_param!("M_534_25", 100)..covopt_param!("M_534_30", 175) {
                    CACHE.insert(i, i * covopt_param!("M_535_40", 10), &handle);
                    CACHE.insert(i, i * covopt_param!("M_536_40", 10), &handle);
                }
                for _ in 0..covopt_param!("M_538_28", 5) {
                    let _ = CACHE.get(&covopt_param!("M_539_39", 10), &handle);
                }
                if let Some(ref tx) = CACHE.global_tx.load_full() {
                    let _ = tx.push(crate::component::daemon::DaemonMessage::SetPollInterval(covopt_param!("M_542_93", 5)));
                    let ack = crate::component::daemon::OneshotAck::new();
                    let _ = tx.push(crate::component::daemon::DaemonMessage::Sync(ack.clone()));
                    ack.wait();
                }
                thread::sleep(Duration::from_millis(covopt_param!("M_547_52", 50)));
                assert_eq!(CACHE.get(&10, &handle), Some(1000));
                CACHE.set_daemon_mode(false);
                thread::sleep(Duration::from_millis(covopt_param!("M_550_52", 50)));
            })
            .unwrap()
            .join()
            .unwrap();
    }
    #[cfg(feature = "std")]
    #[test]
    fn test_extensive_coverage() {
        std::thread::Builder::new()
            .stack_size(covopt_param!("M_560_24", 32) * covopt_param!("M_560_29", 1024) * covopt_param!("M_560_36", 1024))
            .spawn(|| {
                use std::time::Duration;
                static CACHE: std::sync::LazyLock<DualCacheFF<u64, u64, crate::core::config::DefaultExponentialPolicy, 256, 1024, 2048, 4096>> =
                    std::sync::LazyLock::new(DualCacheFF::new);
                let handle = CACHE.register_thread();
                for i in 0..covopt_param!("M_566_28", 100) {
                    CACHE.insert(i, i * covopt_param!("M_567_40", 10), &handle);
                    CACHE.insert(i, i * covopt_param!("M_568_40", 10), &handle);
                    CACHE.get(&i, &handle);
                }
                for _ in 0..covopt_param!("M_571_28", 300) {
                    CACHE.get(&covopt_param!("M_572_31", 10), &handle);
                }
                CACHE.set_daemon_mode(true);
                for i in covopt_param!("M_575_25", 100)..covopt_param!("M_575_30", 200) {
                    CACHE.insert(i, i * covopt_param!("M_576_40", 10), &handle);
                    CACHE.insert(i, i * covopt_param!("M_577_40", 10), &handle);
                    for _ in 0..covopt_param!("M_578_32", 100) {
                        CACHE.get(&i, &handle);
                    }
                }
                std::thread::sleep(Duration::from_millis(covopt_param!("M_582_57", 50)));
                if let Some(ref tx) = CACHE.global_tx.load_full() {
                    let _ = tx.push(crate::component::daemon::DaemonMessage::Promote(
                        covopt_param!("M_585_24", 999), covopt_param!("M_585_29", 999), covopt_param!("M_585_34", 9990), 0,
                    ));
                    let _ = tx.push(crate::component::daemon::DaemonMessage::Promote(
                        covopt_param!("M_588_24", 888), covopt_param!("M_588_29", 888), covopt_param!("M_588_34", 8880), 2,
                    ));
                    let mut arr = [(0usize, 0u8); 32];
                    arr[0] = (covopt_param!("M_591_30", 123), covopt_param!("M_591_35", 10));
                    arr[1] = (covopt_param!("M_592_30", 123), covopt_param!("M_592_35", 5));
                    arr[2] = (covopt_param!("M_593_30", 456), 1);
                    let _ = tx.push(crate::component::daemon::DaemonMessage::HitBatch(std::boxed::Box::new((arr, covopt_param!("M_594_113", 3)))));
                }
                std::thread::sleep(Duration::from_millis(covopt_param!("M_596_57", 50)));
                let handle2 = CACHE.register_thread();
                for i in covopt_param!("M_598_25", 100)..covopt_param!("M_598_30", 200) {
                    CACHE.get(&i, &handle2);
                }
                for i in covopt_param!("M_601_25", 1000)..covopt_param!("M_601_31", 2000) {
                    CACHE.insert(i, i * covopt_param!("M_602_40", 10), &handle);
                }
                for i in covopt_param!("M_604_25", 1000)..covopt_param!("M_604_31", 2000) {
                    CACHE.get(&i, &handle2);
                }
                let warmup = unsafe { &*CACHE.tls_registry.get_block_mut(&handle2) }.warmup_state;
                println!("Warmup state for handle2 after 1000 gets: {}", warmup);
                for i in covopt_param!("M_609_25", 2000)..covopt_param!("M_609_31", 3000) {
                    CACHE.insert(i, i * covopt_param!("M_610_40", 10), &handle2);
                    CACHE.insert(i, i * covopt_param!("M_611_40", 10), &handle2);
                }
                for _ in 1..covopt_param!("M_613_28", 9) {
                    let _ = CACHE.register_thread();
                }
                if let Some(ref tx) = CACHE.global_tx.load_full() {
                    let _ = tx.push(crate::component::daemon::DaemonMessage::Promote(
                        covopt_param!("M_618_24", 123), covopt_param!("M_618_29", 123), covopt_param!("M_618_34", 123), 0,
                    ));
                    let _ = tx.push(crate::component::daemon::DaemonMessage::SetPollInterval(covopt_param!("M_620_93", 5)));
                    let ack = crate::component::daemon::OneshotAck::new();
                    let _ = tx.push(crate::component::daemon::DaemonMessage::Sync(ack.clone()));
                    ack.wait();
                }
                thread::sleep(Duration::from_millis(covopt_param!("M_625_52", 50)));
                CACHE.set_daemon_mode(false);
                thread::sleep(Duration::from_millis(covopt_param!("M_627_52", 50)));
                CACHE.core.try_reclaim(handle.qsbr_node);
            })
            .unwrap()
            .join()
            .unwrap();
    }
}
