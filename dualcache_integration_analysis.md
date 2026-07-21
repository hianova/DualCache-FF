# Analysis of `DualCache-FF` Integration inside `cdDB`

This document details the architectural integration and usages of the `DualCache-FF` concurrent cache inside the `cdDB` storage engine, highlighting key structural coupling and proposing decoupling abstractions.

---

## 1. Survey of `DualCache-FF` Usages in `cdDB`

Inside `Universal-Project/storage/cdDB`, `DualCache-FF` is utilized as a **global hotness index filter** (L1 Cache Interception Layer) to determine if a requested entity is hot and resides in-memory, bypassing slower I/O paths.

### A. Thread Registration (`cache.rs`)
- **File**: [cache.rs](file:///Users/kuangtalin/Documents/Universal-Project/storage/cdDB/src/cache.rs)
- **Usage**:
  - Implements `HitCache<K, V, const B0, const B1, const B2, const B3>`, an ergonomic thread-local wrapper.
  - Dynamically registers executing threads with `inner: DualCacheFF` via thread-local variables (`HANDLES`), creating and caching a `TlsHandle` per executing thread.

### B. Query Interception (`core/query.rs`)
- **File**: [query.rs](file:///Users/kuangtalin/Documents/Universal-Project/storage/cdDB/src/core/query.rs)
- **Usage**:
  - `Query` structures hold a `TlsHandle` obtained via `route.hot_index.register_thread()`.
  - On `get_str`, `get_int`, and `get_blob` query paths, it checks:
    ```rust
    let handle = self.cache_handle;
    let _pin = dualcache_ff::core::qsbr::pin(handle.qsbr_node);
    if self.route.hot_index.get(&(self.route.partition_id, entity_id), handle).is_some() {
        // Fast memory columnar fetch
    }
    ```
  - Directly binds `dualcache_ff::core::qsbr::pin` to lock the QSBR retired queue during lookups.

### C. Partition Initialization & Routing (`engine/partition.rs` & `engine/dispatcher.rs`)
- **Files**: [partition.rs](file:///Users/kuangtalin/Documents/Universal-Project/storage/cdDB/src/engine/partition.rs), [dispatcher.rs](file:///Users/kuangtalin/Documents/Universal-Project/storage/cdDB/src/engine/dispatcher.rs)
- **Usage**:
  - `CdDBDispatcher` instantiates a global shared `global_cache` of type `DualCacheFF<(u32, usize), (), 64, 4096, 262144, 266304>`.
  - Every registered partition route gets a cloned reference (`Arc::clone(&self.global_cache)`) to act as its `hot_index`.
  - `prewarm_partition` calls `self.global_cache.warmup(items)` to inject keys directly into the Hot Tier (T1) on startup.

---

## 2. Key Pain Points & Coupling Issues

1. **Hardcoded Type Signatures**: `cdDB` hardcodes the exact generic arguments of `DualCacheFF` (`<(u32, usize), (), 64, 4096, 262144, 266304>`) inside its structs (`PartitionRoute`, `Partition`, `CdDBDispatcher`). Callers cannot configure different cache capacities, eviction rates, or key structures.
2. **Leakage of QSBR Internals**: `cdDB`'s query path must import and manually execute `dualcache_ff::core::qsbr::pin(handle.qsbr_node)`. This exposes internal thread-reclamation mechanisms (QSBR) directly to the database query loop.
3. **No-std Stubs**: For `no_std` targets without the `dualcache-ff` feature, `cdDB` maintains a manual `dualcache_stub` that duplicates the entire `DualCacheFF` struct definition and methods as no-ops.

---

## 3. Recommended Encapsulations & Abstractions

To decouple the two crates, we propose introducing a unified interface inside `cdDB` and refining the safe cache API:

### 💡 1. Cache Provider Trait (`HotIndexProvider`)
Introduce a trait to abstract hotness checking and thread registration. This allows the concrete cache implementation to be swapped or configured independently:

```rust
pub trait HotIndexProvider: Send + Sync {
    type Handle;

    fn register_thread(&self) -> Self::Handle;
    fn is_hot(&self, partition_id: u32, entity_id: usize, handle: &Self::Handle) -> bool;
    fn prewarm(&self, partition_id: u32, entity_ids: &[usize]);
}
```

By binding `PartitionRoute` to `Arc<dyn HotIndexProvider<Handle = ...>>`, we remove `DualCacheFF`'s capacity constants (`64, 4096, 262144, ...`) from `cdDB`'s internal definitions.

### 💡 2. Safe Auto-Pinning Cache API
Encapsulate QSBR pinning inside the cache lookup method itself to avoid manual pinning in `query.rs`:

```rust
impl<K, V, ...> DualCacheFF<K, V, ...> {
    /// Safe get operation that automatically pins the QSBR node during execution
    #[inline(always)]
    pub fn get_safe(&self, key: &K, handle: &TlsHandle) -> Option<V> {
        let _pin = crate::core::qsbr::pin(handle.qsbr_node);
        self.get(key, handle)
    }
}
```

This ensures `cdDB` only interacts with high-level safe APIs (`get_safe`) and never touches `qsbr_node` or `qsbr::pin` directly.
