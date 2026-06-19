use alloc::vec::Vec;
pub use alloc::sync::Arc;

pub type ArcSlice<T> = Arc<[T]>;

#[inline(always)]
pub fn new_arc_slice<T>(vec: Vec<T>) -> ArcSlice<T> {
    vec.into_boxed_slice().into()
}

pub mod atomic {
    pub use core::sync::atomic::{
        AtomicBool, AtomicPtr, AtomicU16, AtomicU32, AtomicU64, AtomicU8, AtomicUsize, Ordering,
    };
}

pub mod cell {
    pub struct UnsafeCell<T>(core::cell::UnsafeCell<T>);

    #[allow(dead_code)]
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
}
