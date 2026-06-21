use std::vec::Vec;
pub use std::sync::Arc;

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

#[cfg(test)]
mod tests {
    use super::cell::UnsafeCell;

    #[test]
    fn test_unsafe_cell_get_with() {
        let cell = UnsafeCell::new(42);
        assert_eq!(unsafe { *cell.get() }, 42);
        cell.with(|ptr| {
            assert_eq!(unsafe { *ptr }, 42);
        });
    }

    #[test]
    fn test_unsafe_cell_with_mut() {
        let cell = UnsafeCell::new(10);
        cell.with_mut(|ptr| {
            unsafe { *ptr = 20; }
        });
        
        let val = cell.with(|ptr| unsafe { *ptr });
        assert_eq!(val, 20);
    }

    #[test]
    fn test_new_arc_slice() {
        use super::new_arc_slice;
        let slice: std::sync::Arc<[i32]> = new_arc_slice(vec![42; 5]);
        assert_eq!(slice.len(), 5);
        for &v in slice.iter() {
            assert_eq!(v, 42);
        }
    }
}
