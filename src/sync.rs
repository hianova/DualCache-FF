#[cfg(not(feature = "std"))]
use alloc::vec::Vec;
#[cfg(feature = "std")]
use std::vec::Vec;

#[cfg(all(feature = "std", not(any(feature = "loom", loom))))]
pub use std::sync::Arc;

#[cfg(any(feature = "loom", loom))]
pub use loom::sync::Arc;

#[cfg(all(not(feature = "std"), not(any(feature = "loom", loom))))]
pub use alloc::sync::Arc;

#[cfg(not(any(feature = "loom", loom)))]
pub type ArcSlice<T> = Arc<[T]>;

#[cfg(any(feature = "loom", loom))]
pub type ArcSlice<T> = Arc<Vec<T>>;

#[cfg(not(any(feature = "loom", loom)))]
#[inline(always)]
pub fn new_arc_slice<T>(vec: Vec<T>) -> ArcSlice<T> {
    vec.into_boxed_slice().into()
}

#[cfg(any(feature = "loom", loom))]
#[inline(always)]
pub fn new_arc_slice<T>(vec: Vec<T>) -> ArcSlice<T> {
    Arc::new(vec)
}

pub mod atomic {
    #[cfg(not(any(feature = "loom", loom)))]
    pub use core::sync::atomic::{
        AtomicBool, AtomicPtr, AtomicU16, AtomicU32, AtomicU64, AtomicU8, AtomicUsize, Ordering,
    };

    #[cfg(any(feature = "loom", loom))]
    pub use loom::sync::atomic::{
        AtomicBool, AtomicPtr, AtomicU16, AtomicU32, AtomicU64, AtomicU8, AtomicUsize, Ordering,
    };
}

pub mod cell {
    #[cfg(not(any(feature = "loom", loom)))]
    pub struct UnsafeCell<T>(core::cell::UnsafeCell<T>);

    #[cfg(not(any(feature = "loom", loom)))]
    impl<T> UnsafeCell<T> {
        #[inline(always)]
        pub const fn new(data: T) -> Self {
            Self(core::cell::UnsafeCell::new(data))
        }

        #[inline(always)]
        pub fn get(&self) -> *mut T {
            self.0.get()
        }

        #[inline(always)]
        pub fn with<F, R>(&self, f: F) -> R
        where
            F: FnOnce(*const T) -> R,
        {
            f(self.0.get() as *const T)
        }

        #[inline(always)]
        pub fn with_mut<F, R>(&self, f: F) -> R
        where
            F: FnOnce(*mut T) -> R,
        {
            f(self.0.get())
        }
    }

    #[cfg(any(feature = "loom", loom))]
    pub use loom::cell::UnsafeCell;
}

#[cfg(target_has_atomic = "64")]
pub mod index_types {
    pub type AtomicIndex = super::atomic::AtomicU64;
    pub type IndexType = u64;
    pub const EMPTY: u64 = 0;
    pub const TOMBSTONE: u64 = u64::MAX;
    pub const TAG_SHIFT: usize = 48;
    pub const INDEX_MASK: u64 = 0x0000_FFFF_FFFF_FFFF;
    pub type AtomicTick = super::atomic::AtomicU64;
    pub type TickType = u64;
}

#[cfg(not(target_has_atomic = "64"))]
pub mod index_types {
    pub type AtomicIndex = super::atomic::AtomicU32;
    pub type IndexType = u32;
    pub const EMPTY: u32 = 0;
    pub const TOMBSTONE: u32 = u32::MAX;
    pub const TAG_SHIFT: usize = 24;
    pub const INDEX_MASK: u32 = 0x00FF_FFFF;
    // daemon_tick wraps naturally, u32 is sufficient if u64 atomics are missing.
    pub type AtomicTick = super::atomic::AtomicU32;
    pub type TickType = u32;
}
