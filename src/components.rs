use core::cell::{Cell, RefCell};
use core::ops::{Deref, DerefMut};
#[allow(unused_imports)]
use crate::sync::atomic::{AtomicUsize, Ordering};
use crate::sync::index_types::TickType;

pub static GLOBAL_EPOCH: AtomicUsize = AtomicUsize::new(1);

pub struct WorkerState {
    pub local_epoch: CachePadded<AtomicUsize>,
}

impl Default for WorkerState {
    fn default() -> Self {
        Self::new()
    }
}

impl WorkerState {
    pub fn new() -> Self {
        Self {
            local_epoch: CachePadded::new(AtomicUsize::new(0)),
        }
    }
}

// ── CachePadded ───────────────────────────────────────────────────────────

/// Cache-line-aligned wrapper to prevent false sharing between worker slots.
/// Uses `#[repr(C, align(N))]` directly:
/// - 128 bytes on Apple Silicon / ARM (128-byte cache line)
/// -  64 bytes on x86_64 and everything else (64-byte cache line)
#[cfg_attr(any(target_arch = "aarch64", target_arch = "arm"), repr(C, align(128)))]
#[cfg_attr(not(any(target_arch = "aarch64", target_arch = "arm")), repr(C, align(64)))]
pub struct CachePadded<T>(pub T);

impl<T> CachePadded<T> {
    #[inline(always)]
    pub fn new(val: T) -> Self {
        Self(val)
    }

    #[inline(always)]
    pub fn into_inner(self) -> T {
        self.0
    }
}

impl<T> Deref for CachePadded<T> {
    type Target = T;
    #[inline(always)]
    fn deref(&self) -> &T {
        &self.0
    }
}

impl<T> DerefMut for CachePadded<T> {
    #[inline(always)]
    fn deref_mut(&mut self) -> &mut T {
        &mut self.0
    }
}

// ── DefaultSpawner ────────────────────────────────────────────────────────

#[cfg(feature = "std")]
pub mod std_components {
    use super::*;
    use alloc::boxed::Box;

    #[derive(Debug, Clone, Copy, Default)]
    pub struct DefaultSpawner;

    impl DefaultSpawner {
        #[inline]
        pub fn spawn(&self, f: Box<dyn FnOnce() + Send + 'static>) {
            std::thread::spawn(f);
        }
    }

    // ── DefaultTls ────────────────────────────────────────────────────────────

    use core::sync::atomic::{AtomicUsize, Ordering};
    struct IdAllocator {
        bits: [AtomicUsize; 128],
    }

    impl IdAllocator {
        const fn new() -> Self {
            #[allow(clippy::declare_interior_mutable_const)]
            const ZERO: AtomicUsize = AtomicUsize::new(0);
            Self { bits: [ZERO; 128] }
        }

        fn alloc(&self) -> usize {
            for (i, word) in self.bits.iter().enumerate() {
                let mut current = word.load(Ordering::Relaxed);
                while current != !0 {
                    let bit = current.trailing_ones() as usize;
                    if bit < usize::BITS as usize {
                        let mask = 1_usize << bit;
                        match word.compare_exchange_weak(
                            current,
                            current | mask,
                            Ordering::Acquire,
                            Ordering::Relaxed,
                        ) {
                            Ok(_) => return i * (usize::BITS as usize) + bit,
                            Err(v) => current = v,
                        }
                    } else {
                        break;
                    }
                }
            }
            panic!("Exceeded maximum number of concurrent threads in DualCache-FF");
        }

        fn free(&self, id: usize) {
            let word_idx = id / (usize::BITS as usize);
            let bit_idx = id % (usize::BITS as usize);
            if word_idx < self.bits.len() {
                self.bits[word_idx].fetch_and(!(1_usize << bit_idx), Ordering::Release);
            }
        }
    }

    static ALLOCATOR: IdAllocator = IdAllocator::new();

    struct ThreadIdGuard {
        id: usize,
    }

    impl Drop for ThreadIdGuard {
        fn drop(&mut self) {
            ALLOCATOR.free(self.id);
        }
    }

    thread_local! {
        static WORKER_ID: usize = {
            let id = ALLOCATOR.alloc();
            
            GUARD.with(|g| {
                *g.borrow_mut() = Some(ThreadIdGuard { id });
            });
            id
        };

        static GUARD: RefCell<Option<ThreadIdGuard>> = const { RefCell::new(None) };
        static HIT_BUF: RefCell<([usize; 64], usize)> = const { RefCell::new(([0; 64], 0)) };
        static L1_FILTER: RefCell<([u8; 4096], usize)> = const { RefCell::new(([0; 4096], 0)) };
        static LAST_FLUSH_TICK: Cell<TickType> = const { Cell::new(0) };
        static WARMUP_STATE: Cell<u8> = const { Cell::new(0) };
    }

    #[derive(Clone, Default)]
    pub struct DefaultTls;

    impl DefaultTls {
        #[inline(always)]
        pub fn get_worker_id(&self) -> Option<usize> {
            Some(WORKER_ID.with(|id| *id))
        }

        #[inline(always)]
        pub fn with_hit_buf<F, R>(&self, f: F) -> Option<R>
        where
            F: FnOnce(&mut ([usize; 64], usize)) -> R,
        {
            Some(HIT_BUF.with(|buf| f(&mut buf.borrow_mut())))
        }

        #[inline(always)]
        pub fn with_l1_filter<F, R>(&self, f: F) -> Option<R>
        where
            F: FnOnce(&mut ([u8; 4096], usize)) -> R,
        {
            Some(L1_FILTER.with(|filter| f(&mut filter.borrow_mut())))
        }

        #[inline(always)]
        pub fn with_last_flush_tick<F, R>(&self, f: F) -> Option<R>
        where
            F: FnOnce(&mut TickType) -> R,
        {
            Some(LAST_FLUSH_TICK.with(|cell| {
                let mut val = cell.get();
                let res = f(&mut val);
                cell.set(val);
                res
            }))
        }

        #[inline(always)]
        pub fn with_warmup_state<F, R>(&self, f: F) -> R
        where
            F: FnOnce(&mut u8) -> R,
        {
            WARMUP_STATE.with(|cell| {
                let mut val = cell.get();
                let res = f(&mut val);
                cell.set(val);
                res
            })
        }
    }
}

#[cfg(feature = "std")]
pub use std_components::{DefaultSpawner, DefaultTls};



#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_cache_padded() {
        let mut padded = CachePadded::new(42);
        assert_eq!(*padded, 42);
        *padded = 43;
        assert_eq!(*padded, 43);
        assert_eq!(padded.into_inner(), 43);
    }

    #[test]
    fn test_cache_padded_align() {
        assert!(std::mem::align_of::<CachePadded<u8>>() >= 64, "CachePadded must be cache-line aligned");
        assert!(std::mem::size_of::<CachePadded<u8>>() >= 64, "CachePadded size must be at least 64 bytes");
    }

    #[test]
    fn test_worker_state() {
        use core::sync::atomic::Ordering;
        let ws = WorkerState::new();
        assert_eq!(ws.local_epoch.0.load(Ordering::Relaxed), 0);
        let ws_default = WorkerState::default();
        assert_eq!(ws_default.local_epoch.0.load(Ordering::Relaxed), 0);
    }

    #[test]
    fn test_id_allocator_concurrent_via_tls() {
        #[cfg(feature = "std")]
        {
            let mut handles = vec![];
            for _ in 0..10 {
                handles.push(std::thread::spawn(|| {
                    let tls = DefaultTls::default();
                    for _ in 0..100 {
                        let id = tls.get_worker_id().unwrap();
                        assert!(id < 8192);
                    }
                }));
            }
            for h in handles {
                h.join().unwrap();
            }
        }
    }

    #[test]
    fn test_default_tls_methods() {
        #[cfg(feature = "std")]
        {
            let tls = DefaultTls::default();
            let id = tls.get_worker_id().unwrap();
            assert!(id < 8192);
            
            let res = tls.with_l1_filter(|f| {
                f.0[0] = 1;
                true
            });
            assert!(res.is_some());
            assert!(res.unwrap()); 
            
            tls.with_hit_buf(|buf| {
                buf.0[0] = 123;
                buf.1 += 1;
                assert_eq!(buf.1, 1);
                buf.1 = 0; // clear
            });
        }
    }

    #[test]
    fn test_default_spawner() {
        #[cfg(feature = "std")]
        {
            let spawner = DefaultSpawner::default();
            spawner.spawn(Box::new(|| {
                // Thread will just exit
            }));
        }
    }
}
