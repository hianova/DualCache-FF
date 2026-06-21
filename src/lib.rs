//! # DualCache-FF (Fast and Furious)
//!
//! A highly opinionated, absolutely wait-free concurrent cache in Rust, optimized for extreme
//! read-to-write ratios and scan-resistance. Built for high-performance and `no_std` embedded
//! target environments.
//!
//! ## 🧠 Key Concepts & Features
//!
//! - **Wait-Free Read Path & QSBR**: All reads are completely non-blocking and wait-free.
//!   Memory reclamation is handled via Quiet State Based Reclamation (QSBR), allowing readers
//!   to instantly access cached nodes without locks, mutexes, or atomic reference counting overhead.
//! - **Three-Tier Promotion System**:
//!   - **T1 (Hot Cache)**: A high-speed `AtomicPtr` slot array mapping to Cache indices for instant lookup.
//!   - **T2 (Secondary Filter)**: A larger slot array for capturing secondary heat patterns.
//!   - **Cache (Main Storage)**: The source of truth using an open-addressed index (Linear Probing).
//! - **Asynchronous Daemon & Batched Telemetry**: Cache admissions and evictions are handled
//!   exclusively by an asynchronous background daemon. Read/write telemetry is buffered locally
//!   in Thread-Local Storage (TLS) and periodically flushed to the daemon via a custom lock-free `LossyQueue`.
//! - **Avg-based Clock Eviction**: A revolution-shielded circular clock evicts items whose
//!   access rank falls below the global average, instantly adapting to shifting workload heat distributions.
//! - **`no_std` / Bare-Metal Fallback**: Out-of-the-box support for resource-constrained environments
//!   via `StaticDualCache`, using atomic spinlocks to eliminate background threads and achieve zero idle power.

#![cfg_attr(not(feature = "std"), no_std)]
extern crate alloc;

#[doc(hidden)]
pub mod arena;
#[doc(hidden)]
pub mod components;
#[doc(hidden)]
pub mod config;
#[doc(hidden)]
#[cfg(feature = "std")]
pub mod cache;
#[doc(hidden)]
#[doc(hidden)]
pub mod daemon;
#[doc(hidden)]
pub mod filters;
#[doc(hidden)]
pub mod lossy_queue;
#[doc(hidden)]
pub mod storage;
#[doc(hidden)]
pub mod unsafe_core;
#[doc(hidden)]
pub mod workers;
#[doc(hidden)]
pub mod static_cache;
#[doc(hidden)]
pub mod core_cache;
#[doc(hidden)]
pub mod shared_core;
#[doc(hidden)]
pub mod registry;
pub(crate) mod sync;

pub use config::Config;
pub use components::{WorkerState, CachePadded};
pub use static_cache::static_cache::StaticDualCache;
pub use filters::BloomFilter;

#[cfg(feature = "std")]
pub use cache::{DualCacheFF, ColdStartSession};
#[cfg(feature = "std")]
pub use components::{DefaultSpawner, DefaultTls, Spawner};
#[cfg(feature = "std")]
pub use daemon::{Daemon, DaemonStatus, CacheTier};

