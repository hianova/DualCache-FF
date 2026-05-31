#![cfg(not(feature = "loom"))]

#[global_allocator]
static ALLOC: dhat::Alloc = dhat::Alloc;

use dualcache_ff::{Config, DualCacheFF};
use std::thread::sleep;
use std::time::Duration;

mod common;
use common::run_with_timeout;

#[test]
fn test_memory_stability() {
    run_with_timeout(Duration::from_secs(15), || {
        let _profiler = dhat::Profiler::builder().testing().build();

        // ── Dummy Pre-initialization Phase ──────────────────────────────────────
        // Warm up any lazy std/thread-local allocations so they don't skew our leak detection.
        {
            let config = Config::new_expert(256, 64, 64, 200, 2);
            let cache = DualCacheFF::new(config);
            cache.insert(999, vec![0u8; 10]);
            let _ = cache.get(&999);
            drop(cache);
        }
        sleep(Duration::from_millis(50));

        // ── Standard Mode Leak Test ─────────────────────────────────────────────
        let initial_stats = dhat::HeapStats::get();
        let initial_bytes = initial_stats.curr_bytes;

        {
            let config = Config::new_expert(1024, 256, 256, 200, 4);
            let cache = DualCacheFF::new(config);

            for i in 0..1000 {
                cache.insert(i, vec![0u8; 128]);
            }

            for i in 0..5000 {
                let _ = cache.get(&(i % 1000));
            }

            // Drop the cache. This should send Command::Shutdown to the background thread.
            drop(cache);
        }

        // Wait for the background thread to finish and all memory to be reclaimed
        sleep(Duration::from_millis(100));

        let final_stats = dhat::HeapStats::get();
        let final_bytes = final_stats.curr_bytes;

        let delta = final_bytes.saturating_sub(initial_bytes);
        
        assert_eq!(
            delta, 0,
            "Standard Mode Memory leak detected! Initial: {}, Final: {}, Delta: {}",
            initial_bytes,
            final_bytes,
            delta
        );

        // ── Headless (no_std) Mode Leak Test ────────────────────────────────────
        let initial_stats_headless = dhat::HeapStats::get();
        let initial_bytes_headless = initial_stats_headless.curr_bytes;

        {
            let config = Config::new_expert(1024, 256, 256, 200, 4);
            let (cache, daemon) = DualCacheFF::new_headless(config);

            for i in 0..1000 {
                cache.insert(i, vec![0u8; 128]);
            }

            // Spawn a thread to manually drive the daemon
            let daemon_handle = std::thread::spawn(move || {
                daemon.run();
            });

            for i in 0..5000 {
                let _ = cache.get(&(i % 1000));
            }

            cache.sync();

            // Drop the cache. This should send Command::Shutdown to the daemon.
            drop(cache);

            // Ensure the daemon thread exited cleanly (no thread leak!)
            daemon_handle.join().unwrap();
        }

        // Now everything should be dropped and all memory reclaimed
        sleep(Duration::from_millis(50));

        let final_stats_headless = dhat::HeapStats::get();
        let final_bytes_headless = final_stats_headless.curr_bytes;

        let delta_headless = final_bytes_headless.saturating_sub(initial_bytes_headless);
        
        assert_eq!(
            delta_headless, 0,
            "Headless Mode Memory leak detected! Initial: {}, Final: {}, Delta: {}",
            initial_bytes_headless,
            final_bytes_headless,
            delta_headless
        );
    });
}
