# DualCache-FF

**DualCache-FF** is an ultra-high-performance, multi-tiered concurrent cache optimized for extreme read-to-write ratios. 

## Tech Stack
- **Wait-Free Concurrency**: Physically zero contention on the read hot-path via Thread-Local Storage (TLS) registries.
- **QSBR (Quiescent State Based Reclamation)**: Lock-free memory management eliminating the overhead of hazard pointers or reference counting.
- **Multi-Tier Architecture**: T0 (Genius), T1 (Hot), T2 (Warm) promotion pipelines to prevent cache pollution.
- **CATA-DC Demiurge Engine**: A closed-loop control system that dynamically tunes eviction and promotion thresholds based on real-time hit rates.

## Features
- **Daemon Mode**: Offloads cache eviction and memory reclamation to a background thread to guarantee 99.99% SLA latency for foreground workers.
- **Zero Allocation on Reads**: No heap allocation is triggered during cache retrieval.
- **`#![no_std]` Compatible**: Can be run in bare-metal and WASM environments.

## Example

```rust
use dualcache_ff::DualCacheFF;
use dualcache_ff::core::config::DefaultExponentialPolicy;

// Initialize a 3-tier global cache with 10 maximum threads
// T0: 256, T1: 1024, T2: 2048, Total: 4096
static CACHE: DualCacheFF<u64, u64, DefaultExponentialPolicy, 256, 1024, 2048, 4096, 10, 256, 512> = DualCacheFF::new();

fn worker_thread() {
    // 1. Register thread to acquire a fast TLS handle & QSBR node
    let handle = CACHE.register_thread();
    
    // 2. Insert data normally or use 'warmup' to bypass promotion and pin to T0
    CACHE.insert(42, 1000, &handle);
    CACHE.warmup(99, 9999, &handle); // Genius item, skips T2/T1 directly to T0
    
    // 3. Zero-contention, wait-free read
    if let Some(val) = CACHE.get(&42, &handle) {
        assert_eq!(val, 1000);
    }
    
    // The handle's Drop implementation automatically deregisters the thread,
    // safely retiring the QSBR node and preventing memory leaks.
}
```
