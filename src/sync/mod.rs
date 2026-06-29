//! Synchronization primitives abstraction layer.
//! This allows seamless switching between native atomics and `loom` atomics for testing.

#[cfg(not(loom))]
pub mod atomic {
    pub use core::sync::atomic::*;
}

#[cfg(loom)]
pub mod atomic {
    pub use loom::sync::atomic::*;
}

#[cfg(not(loom))]
pub mod arc {
    pub use alloc::sync::Arc;
}

#[cfg(loom)]
pub mod arc {
    pub use loom::sync::Arc;
}

#[cfg(not(loom))]
pub mod mutex {
    pub use spin::Mutex;
}

#[cfg(loom)]
pub mod mutex {
    pub use loom::sync::Mutex;
}

#[cfg(not(loom))]
pub mod thread {
    #[cfg(feature = "std")]
    pub use std::thread::{spawn, yield_now, JoinHandle, sleep};
}

#[cfg(loom)]
pub mod thread {
    pub use loom::thread::{spawn, yield_now, JoinHandle};
}
