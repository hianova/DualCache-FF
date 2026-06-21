use dualcache_ff::{Config, DualCacheFF};
use dualcache_ff::daemon::{DaemonStatus, CacheTier};
use dualcache_ff::filters::BloomFilter;
use std::sync::atomic::{AtomicUsize, Ordering};
use std::sync::Arc;
use std::time::Duration;

struct DummyBloom {
    allow: bool,
}

impl BloomFilter<u64> for DummyBloom {
    fn might_contain(&self, _key: &u64) -> bool {
        self.allow
    }
}

#[test]
fn test_insights_features() {
    let cb_drops = Arc::new(AtomicUsize::new(0));
    let cb_drops_clone = cb_drops.clone();
    
    let config = Config::with_memory_budget(2, 60);
    let bloom = Arc::new(DummyBloom { allow: false });
    
    let (cache, daemon) = DualCacheFF::<u64, u64>::new_headless_with_callbacks(
        config,
        Default::default(),
        Default::default(),
        None,
        None,
        Some(bloom.clone() as Arc<dyn BloomFilter<u64> + Send + Sync>),
        Some(Arc::new(move |drops| {
            cb_drops_clone.store(drops, Ordering::Relaxed);
        }))
    );
    
    let handle = std::thread::spawn(move || { daemon.run() });
    
    // Test BloomFilter
    assert_eq!(cache.get(&10), None);
    // Even if inserted, bloom filter rejects read
    cache.insert(10, 100);
    cache.sync();
    assert_eq!(cache.get(&10), None);
    
    // Change bloom filter
    let mut cache_cloned = cache.clone();
    cache_cloned.bloom_filter = Some(Arc::new(DummyBloom { allow: true }));
    assert_eq!(cache_cloned.get(&10), Some(100));
    
    // Test get_or_load
    let loaded = cache_cloned.get_or_load(&20, || Ok::<u64, ()>(200)).unwrap();
    assert_eq!(loaded, 200);
    cache_cloned.sync();
    assert_eq!(cache_cloned.get(&20), Some(200));
    
    // Test get_or_load_singleflight
    let loaded_sf = cache_cloned.get_or_load_singleflight(&30, || Ok::<u64, ()>(300)).unwrap();
    assert_eq!(loaded_sf, 300);
    cache_cloned.sync();
    assert_eq!(cache_cloned.get(&30), Some(300));
    
    // Concurrent singleflight test
    let cache_sf = cache_cloned.clone();
    let cache_sf2 = cache_cloned.clone();
    
    let load_count = Arc::new(AtomicUsize::new(0));
    let l1 = load_count.clone();
    let l2 = load_count.clone();
    
    let t1 = std::thread::spawn(move || {
        cache_sf.get_or_load_singleflight(&40, || {
            std::thread::sleep(Duration::from_millis(50));
            l1.fetch_add(1, Ordering::Relaxed);
            Ok::<u64, ()>(400)
        }).unwrap()
    });
    
    let t2 = std::thread::spawn(move || {
        std::thread::sleep(Duration::from_millis(10));
        cache_sf2.get_or_load_singleflight(&40, || {
            l2.fetch_add(1, Ordering::Relaxed);
            Ok::<u64, ()>(401)
        }).unwrap()
    });
    
    let r1 = t1.join().unwrap();
    let r2 = t2.join().unwrap();
    assert_eq!(r1, 400);
    assert_eq!(r2, 400);
    assert_eq!(load_count.load(Ordering::Relaxed), 1); // Only loaded once!
    
    // Test boost_heat & get_with_weight
    cache_cloned.boost_heat(&10, 10);
    assert_eq!(cache_cloned.get_with_weight(&10, 5), Some(100));
    cache_cloned.sync();
    
    // Test get_heat_rank
    let rank = cache_cloned.get_heat_rank(&10);
    assert!(rank.is_some());
    
    let none_rank = cache_cloned.get_heat_rank(&999);
    assert_eq!(none_rank, None);
    
    // Test Session batches
    let session = cache_cloned.begin_cold_start_session();
    let mut t2_items = Vec::new();
    for i in 50..200 { t2_items.push((i, i * 10)); }
    session.warmup_batch_t2(t2_items);
    
    let mut core_items = Vec::new();
    for i in 250..400 { core_items.push((i, i * 10)); }
    session.warmup_batch_core(core_items);
    
    session.warmup_with_rank(70, 700, CacheTier::Tier2, 100);
    session.warmup_with_rank(71, 710, CacheTier::Core, 100);
    session.warmup_sync();
    
    assert_eq!(cache_cloned.get(&50), Some(500));
    assert_eq!(cache_cloned.get(&250), Some(2500));
    assert_eq!(cache_cloned.get(&70), Some(700));
    
    // Test shutdown gracefully timeout
    cache_cloned.shutdown_gracefully(Some(Duration::from_millis(10)));
    handle.join().unwrap();
    
    // Test restart daemon
    let status = cache_cloned.daemon_health();
    assert!(status == DaemonStatus::Stopped || status == DaemonStatus::ShuttingDown);
    
    cache_cloned.restart_daemon(dualcache_ff::components::DefaultSpawner, 1000);
    std::thread::sleep(Duration::from_millis(10));
    assert_eq!(cache_cloned.daemon_health(), DaemonStatus::Running);
    cache_cloned.shutdown_gracefully(None);
}
