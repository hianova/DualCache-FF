use std::cell::RefCell;
use std::sync::atomic::{AtomicBool, Ordering};
use std::sync::Arc;
use std::thread;
use std::time::Duration;
use dualcache_ff::{Config, DaemonSpawner, DualCacheFF, TlsProvider};

// ── Mock Spawner implementation ──────────────────────────────────────────
struct MockSpawner {
    spawned: Arc<AtomicBool>,
}

impl DaemonSpawner for MockSpawner {
    fn spawn(&self, f: Box<dyn FnOnce() + Send + 'static>) {
        self.spawned.store(true, Ordering::Relaxed);
        thread::spawn(move || f());
    }
}

// ── Mock TLS Provider implementation ──────────────────────────────────────
thread_local! {
    static MOCK_WORKER_ID: RefCell<Option<usize>> = const { RefCell::new(None) };
    static MOCK_HIT_BUF: RefCell<([usize; 64], usize)> = const { RefCell::new(([0; 64], 0)) };
    static MOCK_L1_FILTER: RefCell<([u8; 4096], usize)> = const { RefCell::new(([0; 4096], 0)) };
    static MOCK_LAST_FLUSH_TICK: RefCell<u64> = const { RefCell::new(0) };
}

struct MockTlsProvider;

impl TlsProvider for MockTlsProvider {
    fn get_worker_id(&self) -> Option<usize> {
        MOCK_WORKER_ID.with(|id| *id.borrow())
    }

    fn with_hit_buf(&self, f: &mut dyn FnMut(&mut ([usize; 64], usize))) {
        MOCK_HIT_BUF.with(|buf| f(&mut *buf.borrow_mut()));
    }

    fn with_l1_filter(&self, f: &mut dyn FnMut(&mut ([u8; 4096], usize))) {
        MOCK_L1_FILTER.with(|filter| f(&mut *filter.borrow_mut()));
    }

    fn with_last_flush_tick(&self, f: &mut dyn FnMut(&mut u64)) {
        MOCK_LAST_FLUSH_TICK.with(|tick| f(&mut *tick.borrow_mut()));
    }
}

fn set_mock_worker_id(id: usize) {
    MOCK_WORKER_ID.with(|cell| {
        *cell.borrow_mut() = Some(id);
    });
}

// ── Integration Tests ─────────────────────────────────────────────────────

#[test]
fn test_custom_spawner() {
    let spawned_flag = Arc::new(AtomicBool::new(false));
    let spawner = MockSpawner {
        spawned: spawned_flag.clone(),
    };

    let config = Config::new_expert(256, 128, 128, 10, 4);
    let cache: DualCacheFF<String, String> = DualCacheFF::new_with_spawner(config, spawner);

    // Verify spawner was invoked
    assert!(spawned_flag.load(Ordering::Relaxed));

    // Basic functional verification
    cache.insert("key1".to_string(), "val1".to_string());
    cache.sync();

    // Verify lookup works
    assert_eq!(cache.get(&"key1".to_string()), Some("val1".to_string()));
}

#[test]
fn test_custom_tls_provider() {
    let config = Config::new_expert(256, 128, 128, 10, 4);
    let (cache, daemon) = DualCacheFF::new_headless_with_tls(config, MockTlsProvider);

    // Run daemon manually in another thread
    let daemon_handle = thread::spawn(move || {
        daemon.run();
    });

    // Worker thread setup
    let cache_clone = cache.clone();
    let worker_handle = thread::spawn(move || {
        set_mock_worker_id(1);
        
        // Lookup must miss initially
        assert_eq!(cache_clone.get(&"key2".to_string()), None);

        // Perform insert
        cache_clone.insert("key2".to_string(), "val2".to_string());
        cache_clone.sync();

        // Perform lookups to build hits batch
        for _ in 0..100 {
            assert_eq!(cache_clone.get(&"key2".to_string()), Some("val2".to_string()));
        }

        cache_clone.sync();
        
        // Assert hit counts and TLS states inside Mock TLS
        MOCK_HIT_BUF.with(|buf| {
            // Hit buf should be empty after sync
            assert_eq!(buf.borrow().1, 0);
        });
    });

    worker_handle.join().unwrap();

    // Explicitly drop cache to shutdown daemon
    drop(cache);
    let _ = daemon_handle.join();
}
