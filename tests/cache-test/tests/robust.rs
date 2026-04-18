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
    let cache = DualCacheFF::new(Config {
        capacity: 128,
        duration: 200,
    });

    for action in actions {
        match action {
            Action::Insert(k, v) => cache.insert(k, v),
            Action::Get(k) => {
                let _ = cache.get(&k);
            }
            Action::Remove(k) => cache.remove(&k),
            Action::Clear => cache.clear(),
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
