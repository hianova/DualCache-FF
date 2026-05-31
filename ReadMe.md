# DualCache-FF (Fast and Furious)

> **A highly opinionated, absolutely wait-free concurrent cache in Rust, optimized for extreme read-to-write ratios and scan-resistance. Built for high-performance and `no_std` embedded compatibility.**

`DualcacheFF` is a specialized, high-density concurrent primitive built on **CQRS (Command Query Responsibility Segregation)**, **QSBR (Quiet State Based Reclamation)**, and a novel **Avg-based Clock Eviction Algorithm**.

By deliberately abandoning heavy API contracts in favor of CPU spatial locality and wait-free semantics, `DualcacheFF` achieves massive throughput under hostile workloads.

## 🧠 Architecture Overview

### 1. Wait-Free Read Path & QSBR
All reads are completely non-blocking and wait-free. Memory reclamation is handled via Quiet State Based Reclamation (QSBR), allowing readers to instantly access cached nodes without locks, mutexes, or atomic reference counting overhead.

### 2. Three-Tier Promotion System
- **T1 (Hot Cache):** A high-speed `AtomicPtr` slot array mapping to Cache indices for instant lookup.
- **T2 (Secondary Filter):** A larger slot array for capturing secondary heat patterns.
- **Cache (Main Storage):** The source of truth using an open-addressed index (Linear Probing).

### 3. Asynchronous Daemon & Batched Telemetry
Cache admissions and evictions are handled exclusively by an asynchronous background daemon. Read/write telemetry is buffered locally in Thread-Local Storage (TLS) and periodically flushed to the daemon via a custom lock-free `LossyQueue`.

### 4. Avg-based Clock Eviction
A revolution-shielded circular clock evicts items whose access rank falls below the global average, instantly adapting to shifting workload heat distributions.

## 🚀 Quick Start Examples

### Single-Threaded Basic Usage
```rust
use dualcache_ff::{DualCacheFF, Config};

fn main() {
    // Initialize cache with physical memory limits
    let config = Config::with_memory_budget(10 * 1024 * 1024, 60); // 10MB budget, 60% TTL load
    let cache = DualCacheFF::new(config);

    // Insert data
    cache.insert(1, "value_1");
    cache.insert(2, "value_2");

    // Retrieve data
    if let Some(val) = cache.get(&1) {
        println!("Found: {}", val);
    }
}
```

### Multi-Threaded Concurrent Usage
```rust
use dualcache_ff::{DualCacheFF, Config};
use std::sync::Arc;
use std::thread;

fn main() {
    let config = Config::with_memory_budget(50 * 1024 * 1024, 80);
    let cache = Arc::new(DualCacheFF::new(config));

    let mut handles = vec![];

    for i in 0..4 {
        let cache_clone = Arc::clone(&cache);
        handles.push(thread::spawn(move || {
            // High concurrency wait-free reads and writes
            cache_clone.insert(i, format!("Data {}", i));
            
            if let Some(val) = cache_clone.get(&i) {
                println!("Thread {} read: {}", i, val);
            }
        }));
    }

    for handle in handles {
        handle.join().unwrap();
    }
}
```

## 🧪 Testing & Benchmarks

DualCache-FF comes with an extensive suite of integration tests, property tests, and benchmarks. 

### Running Tests
To run the full suite of unit and integration tests (including concurrency correctness and memory safety checks):
```bash
cargo test
```

### Running Benchmarks
DualCache-FF uses custom `criterion`-based benchmarks for throughput, latency, and memory profiling.

By default, the benchmark suite only runs `DualCacheFF`:
```bash
cargo bench
```

To run a comparative benchmark against other caching libraries (like Moka and TinyUFO), enable the `full_bench` feature:
```bash
cargo bench --features full_bench
```

## 📜 License

This project is licensed under the [**MIT License**](LICENSE).

---
*Project co-developed and optimized with Antigravity.*
