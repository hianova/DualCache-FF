use core::ops::{Deref, DerefMut};
use crate::sync::atomic::{AtomicUsize, Ordering};
use crate::sync::index_types::TickType;
use core::cell::{Cell, RefCell};
use alloc::vec::Vec;

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

#[derive(Debug, Clone, Copy, Default)]
pub struct DefaultSpawner;

impl DefaultSpawner {
    #[inline]
    #[cfg(all(feature = "std", not(any(feature = "loom", loom))))]
    pub fn spawn(&self, f: alloc::boxed::Box<dyn FnOnce() + Send + 'static>) {
        std::thread::spawn(f);
    }

    #[inline]
    #[cfg(any(feature = "loom", loom))]
    pub fn spawn(&self, f: alloc::boxed::Box<dyn FnOnce() + Send + 'static>) {
        loom::thread::spawn(move || f());
    }
}

// ── DefaultTls ────────────────────────────────────────────────────────────

#[cfg(all(feature = "std", not(any(feature = "loom", loom))))]
mod std_tls_impl {
    use super::*;
    use std::sync::Mutex;

    struct IdAllocator {
        free_list: Mutex<Vec<usize>>,
        next_id: AtomicUsize,
    }

    static ALLOCATOR: IdAllocator = IdAllocator {
        free_list: Mutex::new(Vec::new()),
        next_id: AtomicUsize::new(0),
    };

    struct ThreadIdGuard {
        id: usize,
    }

    impl Drop for ThreadIdGuard {
        fn drop(&mut self) {
            if let Ok(mut list) = ALLOCATOR.free_list.lock() {
                list.push(self.id);
            }
        }
    }

    thread_local! {
        static WORKER_ID: usize = {
            let id = if let Ok(mut list) = ALLOCATOR.free_list.lock() {
                list.pop().unwrap_or_else(|| ALLOCATOR.next_id.fetch_add(1, Ordering::Relaxed))
            } else {
                ALLOCATOR.next_id.fetch_add(1, Ordering::Relaxed)
            };
            
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

#[cfg(all(feature = "std", not(any(feature = "loom", loom))))]
pub use std_tls_impl::DefaultTls;

#[cfg(any(feature = "loom", loom))]
mod loom_tls_impl {
    use super::*;
    use std::sync::Mutex;

    struct IdAllocator {
        free_list: Mutex<Vec<usize>>,
        next_id: AtomicUsize,
    }

    loom::lazy_static! {
        static ref ALLOCATOR: IdAllocator = IdAllocator {
            free_list: Mutex::new(Vec::new()),
            next_id: AtomicUsize::new(0),
        };
    }

    struct ThreadIdGuard {
        id: usize,
    }

    impl Drop for ThreadIdGuard {
        fn drop(&mut self) {
            if let Ok(mut list) = ALLOCATOR.free_list.lock() {
                list.push(self.id);
            }
        }
    }

    loom::thread_local! {
        static WORKER_ID: usize = {
            let id = if let Ok(mut list) = ALLOCATOR.free_list.lock() {
                list.pop().unwrap_or_else(|| ALLOCATOR.next_id.fetch_add(1, Ordering::Relaxed))
            } else {
                ALLOCATOR.next_id.fetch_add(1, Ordering::Relaxed)
            };
            GUARD.with(|g| {
                *g.borrow_mut() = Some(ThreadIdGuard { id });
            });
            id
        };

        static GUARD: RefCell<Option<ThreadIdGuard>> = RefCell::new(None);
        static HIT_BUF: RefCell<([usize; 64], usize)> = RefCell::new(([0; 64], 0));
        static L1_FILTER: RefCell<([u8; 4096], usize)> = RefCell::new(([0; 4096], 0));
        static LAST_FLUSH_TICK: Cell<TickType> = Cell::new(0);
        static WARMUP_STATE: Cell<u8> = Cell::new(0);
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
            Some(HIT_BUF.with(|buf| f(&mut *buf.borrow_mut())))
        }

        #[inline(always)]
        pub fn with_l1_filter<F, R>(&self, f: F) -> Option<R>
        where
            F: FnOnce(&mut ([u8; 4096], usize)) -> R,
        {
            Some(L1_FILTER.with(|filter| f(&mut *filter.borrow_mut())))
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

#[cfg(any(feature = "loom", loom))]
pub use loom_tls_impl::DefaultTls;

#[cfg(not(any(feature = "std", feature = "loom", loom)))]
mod no_std_tls_impl {
    use super::*;

    #[derive(Clone, Default)]
    pub struct DefaultTls;

    impl DefaultTls {
        #[inline(always)]
        pub fn get_worker_id(&self) -> Option<usize> {
            None
        }

        #[inline(always)]
        pub fn with_hit_buf<F, R>(&self, _f: F) -> Option<R>
        where
            F: FnOnce(&mut ([usize; 64], usize)) -> R,
        {
            None
        }

        #[inline(always)]
        pub fn with_l1_filter<F, R>(&self, _f: F) -> Option<R>
        where
            F: FnOnce(&mut ([u8; 4096], usize)) -> R,
        {
            None
        }

        #[inline(always)]
        pub fn with_last_flush_tick<F, R>(&self, _f: F) -> Option<R>
        where
            F: FnOnce(&mut TickType) -> R,
        {
            None
        }

        #[inline(always)]
        pub fn with_warmup_state<F, R>(&self, f: F) -> R
        where
            F: FnOnce(&mut u8) -> R,
        {
            let mut state = 255;
            f(&mut state)
        }
    }
}

#[cfg(not(any(feature = "std", feature = "loom", loom)))]
pub use no_std_tls_impl::DefaultTls;
