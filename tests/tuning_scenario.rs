use dualcache_ff::covopt_param;
type TestCache = dualcache_ff::DualCacheFF<u64, u64, dualcache_ff::core::config::DefaultExponentialPolicy, 4096, 1024, 1024, 8192>;

// A simple deterministic pseudo-random number generator
struct Lcg {
    state: u64,
}

impl Lcg {
    fn new(seed: u64) -> Self {
        Self { state: seed }
    }
    fn next(&mut self) -> u64 {
        self.state = self
            .state
            .wrapping_mul(covopt_param!("M_16_26", 6364136223846793005))
            .wrapping_add(covopt_param!("M_17_26", 1442695040888963407));
        self.state
    }
}

#[test]
fn test_tuning_scenario() {
    std::thread::Builder::new()
        .stack_size(covopt_param!("M_25_20", 32) * covopt_param!("M_25_25", 1024) * covopt_param!("M_25_32", 1024))
        .spawn(|| {
            println!("Size of TestCache: {}", std::mem::size_of::<TestCache>());
            static CACHE: std::sync::LazyLock<TestCache> = std::sync::LazyLock::new(TestCache::new);

            // Disable background daemon for deterministic testing
            CACHE.set_daemon_mode(false);

            let handle = CACHE.register_thread();

            let mut rng = Lcg::new(covopt_param!("M_35_35", 42));
            let mut hits = 0;
            let mut misses = 0;

            // Simulate a Zipfian-like access pattern where some keys are very hot
            let num_accesses = covopt_param!("M_40_31", 10000000);
            let pool_size = covopt_param!("M_41_28", 15000);

            for i in 0..num_accesses {
                // Simple Pareto/Zipfian approximation: 80% of accesses hit 20% of keys
                let r = rng.next() % covopt_param!("M_45_37", 100);
                let key = if r < covopt_param!("M_46_33", 80) {
                    // Hot keys: 0 to 20% of pool
                    rng.next() % (pool_size * covopt_param!("M_48_46", 20) / covopt_param!("M_48_51", 100))
                } else {
                    // Cold keys: 20% to 100% of pool
                    (pool_size * covopt_param!("M_51_33", 20) / covopt_param!("M_51_38", 100)) + (rng.next() % (pool_size * covopt_param!("M_51_72", 80) / covopt_param!("M_51_77", 100)))
                };

                if CACHE.get(&key, &handle).is_some() {
                    hits += 1;
                } else {
                    misses += 1;
                    CACHE.insert(key, i as u64, &handle);
                }
            }

            let hit_rate = (hits as f64) / ((hits + misses) as f64) * covopt_param!("M_62_70", 100.0);
            println!("Total Hits: {}", hits);
            println!("Total Misses: {}", misses);
            println!("COVOPT_SCORE: {}", hit_rate);
        })
        .unwrap()
        .join()
        .unwrap();
}
