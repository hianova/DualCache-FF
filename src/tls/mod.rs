use crate::sync::index_types::TickType;

/// Trait for plug-and-play Thread-Local Storage (TLS) in `no_std` or custom RTOS environments.
///
/// Enables thread-local batching of hits and L1 probation filtering on platforms
/// where standard `thread_local!` is not available.
pub trait TlsProvider: Send + Sync {
    /// Get the current worker thread ID (0..config.threads).
    ///
    /// Returns `None` if the thread is not registered or cannot be resolved.
    fn get_worker_id(&self) -> Option<usize>;

    /// Access the thread-local Hit Buffer array.
    ///
    /// The provider must execute the given closure with a mutable reference to the
    /// current thread's batch buffer: `([usize; 64], usize)`.
    fn with_hit_buf(&self, f: &mut dyn FnMut(&mut ([usize; 64], usize)));

    /// Access the thread-local L1 Probation Filter.
    ///
    /// The provider must execute the given closure with a mutable reference to the
    /// current thread's L1 probation filter state: `([u8; 4096], usize)`.
    fn with_l1_filter(&self, f: &mut dyn FnMut(&mut ([u8; 4096], usize)));

    /// Access the thread-local Last Flush Tick.
    ///
    /// The provider must execute the given closure with a mutable reference to the
    /// current thread's last flush tick value.
    fn with_last_flush_tick(&self, f: &mut dyn FnMut(&mut TickType));
}

#[cfg(all(feature = "std", not(any(feature = "loom", loom))))]
mod std_tls;
#[cfg(all(feature = "std", not(any(feature = "loom", loom))))]
pub use std_tls::DefaultTls;

#[cfg(any(feature = "loom", loom))]
mod loom_tls;
#[cfg(any(feature = "loom", loom))]
pub use loom_tls::DefaultTls;

#[cfg(not(any(feature = "std", feature = "loom", loom)))]
mod no_std_tls;
#[cfg(not(any(feature = "std", feature = "loom", loom)))]
pub use no_std_tls::DefaultTls;
