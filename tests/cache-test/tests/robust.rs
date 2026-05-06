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
#[cfg_attr(feature = "arbitrary", derive(arbitrary::Arbitrary))]
#[cfg_attr(any(fuzzing, test), derive(arbitrary::Arbitrary))]
pub enum Action {
    Insert(u8, u16),
    Get(u8),
    Remove(u8),
    Clear,
}

pub fn run_fuzz_ops(actions: impl IntoIterator<Item = Action>) {
    let mut config = Config::adaptive_config::<u8, u16>();
    config.capacity = 128;
    config.duration = 200;
    let cache = DualCacheFF::new(config);

    let mut shadow = std::collections::HashMap::new();

    for action in actions {
        match action {
            Action::Insert(k, v) => {
                shadow.insert(k, v);
                cache.insert(k, v);
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
    std::thread::sleep(std::time::Duration::from_millis(50));

    // Consistency Check
    for (k, expected_v) in shadow {
        if let Some(actual_v) = cache.get(&k) {
            assert_eq!(
                actual_v, expected_v,
                "Data Corruption detected during Fuzzing! Key {} expected {}, got {}",
                k, expected_v, actual_v
            );
        }
    }
}

#[cfg(not(fuzzing))]
#[test]
fn test_robust() {
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
}
