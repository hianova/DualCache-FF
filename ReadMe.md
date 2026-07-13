# DualCache-FF (Fast and Furious)

> **A highly opinionated, absolutely wait-free concurrent cache in Rust, optimized for extreme read-to-write ratios and scan-resistance. Built for high-performance and `no_std` embedded compatibility.**

`DualcacheFF` is a specialized, high-density concurrent primitive built on **CQRS (Command Query Responsibility Segregation)**, **QSBR (Quiet State Based Reclamation)**, and a novel **Avg-based Clock Eviction Algorithm (Blackjack)**.

By deliberately abandoning heavy API contracts in favor of CPU spatial locality and wait-free semantics, `DualcacheFF` achieves massive throughput under hostile workloads.

## Architecture Overview

### 1. Wait-Free Read Path & QSBR
All reads are completely non-blocking and wait-free. Memory reclamation is handled via Quiet State Based Reclamation (QSBR), allowing readers to instantly access cached nodes without locks, mutexes, or atomic reference counting overhead.

### 2. Three-Tier Promotion System
- **T0 (L1 Cache):** Ultra-fast array mapping for hyper-frequent hits.
- **T1 (Hot Cache):** A high-speed `AtomicPtr` slot array mapping to Cache indices for instant lookup.
- **T2 (Secondary Filter):** A larger slot array for capturing secondary heat patterns and delaying eviction.
- **Cache (Arena):** The source of truth using a flat Arena allocator.

### 3. Asynchronous Daemon & Batched Telemetry
Cache admissions and evictions are handled exclusively by an asynchronous background daemon. Read/write telemetry is buffered locally in Thread-Local Storage (TLS) and periodically flushed to the daemon via a custom lock-free `mpsc_queue::BoundedQueue`.

### 4. Blackjack (Avg-based Clock Eviction)
A revolution-shielded circular clock evicts items whose access rank falls below the global average, instantly adapting to shifting workload heat distributions.

## Quick Start Examples

### Basic Usage (`DualCacheFF`)
```rust
use dualcache_ff::DualCacheFF;
use dualcache_ff::component::config::DefaultExponentialPolicy;

fn main() {
    // Initialize cache using default configuration and generics
    let cache = DualCacheFF::<
        u64, u64,
        DefaultExponentialPolicy,
        64,     // CAP2
        4096,   // CAP1
        262144, // CAP0
        266304, // TOTAL_CAP
        16,     // MAX_THREADS
        1024,   // TLS_CAP
        64      // TLS_INDEX_CAP
    >::default();

    // Spawn Daemon to process writes in the background
    cache.spawn_daemon(dualcache_ff::ThreadCount::Pin(1));

    // Wait-free insert
    cache.put_t2_single_thread(1, 100);

    // Wait-free read
    if let Some(val) = cache.get(&1) {
        println!("Found: {}", val);
    }
}
```

## Testing & Benchmarks

DualCache-FF comes with an extensive suite of integration tests, property tests, and benchmarks. 

### Running Tests
To run the full suite of unit and integration tests (including concurrency correctness and memory safety checks):
```bash
cargo test
```

### Running Benchmarks
DualCache-FF uses highly optimized custom benchmark harnesses (with `harness = false`) to accurately measure throughput, latency at the nanosecond scale, and memory profiling.

To run the full suite of benchmarks:
```bash
cargo bench
```

## License

This project is licensed under the [**MIT License**](LICENSE).
