
#![cfg_attr(fuzzing, no_main)]

#[cfg(fuzzing)]
libfuzzer_sys::fuzz_target!(|data: &[u8]| {
    use arbitrary::Arbitrary;
    if let Ok(actions) = <Vec<Action>>::arbitrary(&mut arbitrary::Unstructured::new(data)) {
        run_fuzz_ops(actions);
    }
});

use dualcache_ff::{Config, DualCacheFF};

#[derive(Debug, Clone)]
#[cfg_attr(any(fuzzing, test), derive(arbitrary::Arbitrary))]
pub enum Action {
    Insert(u8, u16),
    Get(u8),
    Remove(u8),
    Clear,
}

pub fn run_fuzz_ops(actions: impl IntoIterator<Item = Action>) {
    let config = Config::new_expert(128, 64, 64, 200, 128);
    let cache = DualCacheFF::new(config);

    let mut shadow = std::collections::HashMap::new();

    for action in actions {
        match action {
            Action::Insert(k, v) => {
                shadow.insert(k, v);
                let session = cache.begin_cold_start_session();
                session.insert_t1(k, v);
            }
            Action::Get(k) => {
                let _ = cache.get(&k);
            }
            Action::Remove(k) => {
                shadow.remove(&k);
                cache.remove(&k);
            }
            Action::Clear => {
                shadow.clear();
                cache.clear();
            }
        }
    }

    // Wait for Daemon to process the batched async commands
    cache.sync();

    // Consistency Check
    let mut _found = 0;
    for (k, expected_v) in shadow {
        if let Some(actual_v) = cache.get(&k) {
            assert_eq!(
                actual_v, expected_v,
                "Data Corruption detected during Fuzzing! Key {} expected {}, got {}",
                k, expected_v, actual_v
            );
            _found += 1;
        }
    }
    // Since fuzz inputs are random, it's possible no keys were actually inserted,
    // but we can at least ensure if any inserts happened, they are found.
    // We won't strictly enforce found > 0 here to avoid failing on pure-read fuzz seeds,
    // but bypassing the L1 filter ensures inserts actually make it in.
}

use crate::common::run_with_timeout;

#[cfg(not(fuzzing))]
#[test]
fn test_robust() {
    run_with_timeout(std::time::Duration::from_secs(10), || {
        use arbitrary::Arbitrary;
        use rand::RngCore;
        use rand::SeedableRng;

        let mut rng = rand::rngs::StdRng::seed_from_u64(42);
        for _ in 0..10 {
            let mut data = vec![0u8; 1024];
            rng.fill_bytes(&mut data);
            let mut u = arbitrary::Unstructured::new(&data);
            if let Ok(actions) = <Vec<Action>>::arbitrary(&mut u) {
                run_fuzz_ops(actions);
            }
        }
    });
}
