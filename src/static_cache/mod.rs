//! Static and stub cache interfaces optimized for bare-metal and ultra-constrained embedded targets.

#![allow(clippy::module_inception)]

pub mod static_cache;
pub mod stub;

/// A zero-allocation, completely `alloc`-free static direct-mapped concurrent cache.
pub use static_cache::StaticDualCache;

/// A zero-overhead facade stub implementation where all operations are compiled away.
pub use stub::DualCacheStub;
