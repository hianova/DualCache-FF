extern crate alloc;

/// Trait for custom thread/task executors to spawn the background Daemon.
///
/// Decouples spawning from `DualCacheFF::new`, enabling execution on Tokio,
/// FreeRTOS tasks, Loom virtual threads, or other user-defined runtimes.
pub trait DaemonSpawner: Send + Sync {
    /// Spawn a closure as a concurrent background execution unit.
    fn spawn(&self, f: alloc::boxed::Box<dyn FnOnce() + Send + 'static>);
}

#[cfg(all(feature = "std", not(any(feature = "loom", loom))))]
mod std_spawner;
#[cfg(all(feature = "std", not(any(feature = "loom", loom))))]
pub use std_spawner::DefaultSpawner;

#[cfg(any(feature = "loom", loom))]
mod loom_spawner;
#[cfg(any(feature = "loom", loom))]
pub use loom_spawner::DefaultSpawner;
