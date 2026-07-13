use dualcache_ff::define_dualcache;

define_dualcache!(
    name: TestCache,
    key: u64,
    value: u64,
    t0: 16,
    t1: 128,
    tls_size: 100,
    threads: 1
);

#[test]
fn test_core_insert() {
    let n: usize = std::env::var("COVOPT_N")
        .unwrap_or_else(|_| "10".to_string())
        .parse()
        .unwrap_or(10);
    
    let cache = std::boxed::Box::new(TestCache::new());
    let handle = cache.register_thread();

    // Fill the cache (insert twice to pass probation filter)
    for i in 0..n as u64 {
        cache.insert(i, i, &handle);
        cache.insert(i, i, &handle);
    }
}
