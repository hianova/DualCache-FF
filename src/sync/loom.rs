use alloc::vec::Vec;
pub use loom::sync::Arc;

pub type ArcSlice<T> = Arc<Vec<T>>;

#[inline(always)]
pub fn new_arc_slice<T>(vec: Vec<T>) -> ArcSlice<T> {
    Arc::new(vec)
}

pub mod atomic {
    pub use loom::sync::atomic::{
        AtomicBool, AtomicPtr, AtomicU16, AtomicU32, AtomicU64, AtomicU8, AtomicUsize, Ordering,
    };
}

pub mod cell {
    pub use loom::cell::UnsafeCell;
}
