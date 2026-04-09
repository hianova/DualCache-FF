# DualCache-FF (Fast and Furious)

## License 
[PolyForm-Noncommercial-1.0.0](https://polyformproject.org/licenses/noncommercial/1.0.0/)

---

# DualCacheFF

**DualCacheFF** is a high-performance, in-memory caching library for Rust, designed for extreme concurrency and strict latency bounds. 

It abandons traditional `Mutex<HashMap>` and standard LRU linked-list designs in favor of a **Sharded Dual-Buffer Architecture** and a novel **Pendulum Eviction Algorithm**. By decoupling the read and write paths, DualCacheFF achieves **100% wait-free reads** and **zero-allocation evictions**, making it highly suitable for read-heavy, latency-sensitive applications.

## 🏗️ Architecture Overview

DualCacheFF is built upon the principle of **Data-Oriented Design (DOD)** and **Multi-Version Concurrency Control (MVCC)**. The system is strictly divided into a lightweight frontend handle and an exclusive background engine.

### 1. Wait-Free Read Path (The Frontend)
The frontend (`DualCacheFF`) holds an `ArcSwap` pointing to a read-only snapshot (`CacheView`). 
* **Zero Contention**: Read operations (`get`) never acquire a mutex or block. They perform a direct lookup in the snapshot and emit an asynchronous `Action::Hit` signal via a bounded channel.
* **Lazy Expiration**: Expiration checks are performed passively during reads. Expired items return `None` and emit an `Action::Delete` signal, offloading the cleanup to the background.

### 2. Asynchronous Write Engine (The Daemon)
All mutations (inserts, updates, evictions) are serialized and processed by a dedicated background thread (`DaemonEngine`).
* **Copy-On-Write (COW)**: The daemon batches incoming actions and applies them to a standby instance. It utilizes `Arc::make_mut` to ensure that the underlying `Vec` and `HashMap` are only cloned when necessary, achieving zero-copy for read-heavy workloads.
* **Atomic Publishing**: Once a batch is applied, the daemon publishes the new state via `ArcSwap::swap`, instantly updating the frontend's view.

## ⚙️ Core Algorithms

### The Pendulum Eviction Scan
Traditional LRU/LFU caches rely on doubly-linked lists or min-heaps, which suffer from poor cache locality and pointer-chasing overhead. DualCacheFF utilizes a contiguous array (`arena`) and a bidirectional scanning pointer (`evict_point`).

1. **Zero-Allocation Overwrite**: Once the cache reaches capacity, the underlying `Vec` never grows or shrinks. New items are written by overwriting existing victims in-place.
2. **Flat-Tax Decay**: When the pendulum pointer encounters a "hot" item (access count > system average), it deducts the average count (a "flat tax") and reverses direction. This naturally creates A/B zones (hot/cold separation) and prevents legacy items from starving new entries.
3. **O(1) Rank Promotion**: When an item is accessed (`Hit`), its logical rank is promoted by swapping indices within the `arena` array. This operation is strictly $O(1)$ and avoids mutating the `HashMap` index, eliminating write amplification.

### Tombstone Teleportation (Instant GC)
When an item is explicitly deleted or lazily expired, its physical node is marked as a tombstone (`epoch = 0`). To guarantee $O(1)$ reclamation without waiting for the pendulum to scan the entire array, the tombstone's rank is instantly swapped with the current `evict_point`. The next `Put` operation will immediately overwrite this tombstone.

## 🚀 Quick Start

Add `dual_cache_ff` to your `Cargo.toml`:

```toml
[dependencies]
dual_cache_ff = "0.1"
```

### Basic Usage

```rust
use dual_cache_ff::{DualCacheFF, Config};
use std::thread;
use std::time::Duration;

fn main() {
    // 1. Initialize configuration
    let config = Config {
        capacity: 100_000, // Maximum number of items
        duration: 60,      // TTL in seconds
    };

    // 2. Build the cache and start the background daemon
    let cache = DualCacheFF::build(config);

    // 3. Asynchronous, backpressured writes
    cache.put("user:1", "Alice");
    cache.put("user:2", "Bob");

    // Allow a brief moment for the daemon to process the batch
    thread::sleep(Duration::from_millis(10));

    // 4. Wait-free reads
    assert_eq!(cache.get(&"user:1"), Some("Alice"));
    
    // 5. Zero-copy iteration
    let items: Vec<_> = cache.iter().collect();
    println!("Cache contains {} items", items.len());
}
```

## 📊 Performance Characteristics

| Operation | Time Complexity | Concurrency Model | Memory Allocation |
| :--- | :--- | :--- | :--- |
| **`get`** | $O(1)$ | **Wait-Free** (ArcSwap load) | Zero |
| **`put`** | $O(1)$ | **Async** (Channel send) | Zero (after warmup) |
| **`delete`** | $O(1)$ | **Async** (Channel send) | Zero |
| **Eviction** | $O(1)$ | Exclusive to Daemon | Zero |

*Note: `put` and `delete` operations may block if the internal channel reaches capacity (backpressure), ensuring memory safety under extreme load.*

## Benchmark

2026/4/10 
$ cargo bench --bench throughput -- --verbose --output-format bencher

#### Gnuplot not found, using plotters backend
- test cache_throughput/Moka/uniform ... bench:   468757010 ns/iter (+/- 8921837)
- test cache_throughput/DualCacheFF/uniform ... bench:    27683901 ns/iter (+/- 455613)

#### Warning: Unable to complete 10 samples in 5.0s. You may wish to increase target time to 9.2s or enable flat sampling.
- test cache_throughput/Moka/zipf ... bench:   175735348 ns/iter (+/- 9346232)
- test cache_throughput/DualCacheFF/zipf ... bench:    80750417 ns/iter (+/- 2047880)

#### Warning: Unable to complete 10 samples in 5.0s. You may wish to increase target time to 7.0s.
- test cache_throughput/Moka/scan ... bench:   957736958 ns/iter (+/- 114978011)
- test cache_throughput/DualCacheFF/scan ... bench:    36916407 ns/iter (+/- 1171607)

#### uniform:  468ms vs  27ms → 16.9x
#### zipf:     175ms vs  80ms →  2.2x
#### scan:     957ms vs  36ms → 25.9x
---
*project supported by gemini 3.1 pro*
