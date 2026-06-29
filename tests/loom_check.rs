#[cfg(loom)]
use loom::model::Builder;
#[cfg(loom)]
use dualcache_ff::core::slot::Slot;
#[cfg(loom)]
use dualcache_ff::core::arena::Arena;
#[cfg(loom)]
use dualcache_ff::core::qsbr;
#[cfg(loom)]
use dualcache_ff::core::cache_tier::CacheTier;

#[cfg(loom)]
#[test]
fn test_slot_concurrent_insert_micro() {
    let mut builder = Builder::new();
    builder.preemption_bound = Some(2);

    builder.check(|| {
        let _dummy = qsbr::register_thread();

        let arena = loom::sync::Arc::new(Arena::<u32, u32, 4>::new());
        let slot = loom::sync::Arc::new(Slot::<u32, u32>::new());
        
        let a1 = arena.clone();
        let s1 = slot.clone();
        let t1 = loom::thread::spawn(move || {
            let node = qsbr::register_thread();
            s1.insert(&a1, 100, 1, 10, node);
        });

        let a2 = arena.clone();
        let s2 = slot.clone();
        let t2 = loom::thread::spawn(move || {
            let node = qsbr::register_thread();
            s2.insert(&a2, 200, 2, 20, node);
        });

        t1.join().unwrap();
        t2.join().unwrap();
    });
}

#[cfg(loom)]
#[test]
fn test_arena_alloc_free_micro() {
    let mut builder = Builder::new();
    builder.preemption_bound = Some(2);

    builder.check(|| {
        let _dummy = qsbr::register_thread();

        let arena = loom::sync::Arc::new(Arena::<u32, u32, 4>::new());
        let a1 = arena.clone();
        
        let t1 = loom::thread::spawn(move || {
            let node = qsbr::register_thread();
            if let Some(idx) = a1.alloc(1, 10, node) {
                unsafe { a1.free(idx); }
            }
        });

        let a2 = arena.clone();
        let t2 = loom::thread::spawn(move || {
            let node = qsbr::register_thread();
            if let Some(idx) = a2.alloc(2, 20, node) {
                unsafe { a2.free(idx); }
            }
        });

        t1.join().unwrap();
        t2.join().unwrap();
    });
}

#[cfg(loom)]
#[test]
fn test_qsbr_reclaim_micro() {
    let mut builder = Builder::new();
    builder.preemption_bound = Some(2);

    builder.check(|| {
        let _dummy = qsbr::register_thread();

        let t1 = loom::thread::spawn(move || {
            let node = qsbr::register_thread();
            let _guard = qsbr::pin(node);
            qsbr::retire(100, node);
        });

        let t2 = loom::thread::spawn(move || {
            let node = qsbr::register_thread();
            qsbr::try_reclaim(node, |_idx| {});
        });

        t1.join().unwrap();
        t2.join().unwrap();
    });
}

#[cfg(loom)]
#[test]
fn test_cache_tier_micro() {
    let mut builder = Builder::new();
    builder.preemption_bound = Some(2);

    builder.check(|| {
        let _dummy = qsbr::register_thread();

        // CAPACITY=4, WAYS=4 => 1 set of 4 slots.
        let tier = loom::sync::Arc::new(CacheTier::<u32, u32, 4, 4>::new());
        let arena = loom::sync::Arc::new(Arena::<u32, u32, 6>::new());
        
        let t1_tier = tier.clone();
        let t1_arena = arena.clone();
        let t1 = loom::thread::spawn(move || {
            let node = qsbr::register_thread();
            t1_tier.insert(&t1_arena, 10, 1, 100, node);
            let guard = qsbr::pin(node);
            let _ = t1_tier.get_slot(&t1_arena, 10, &1, &guard);
        });

        let t2_tier = tier.clone();
        let t2_arena = arena.clone();
        let t2 = loom::thread::spawn(move || {
            let node = qsbr::register_thread();
            t2_tier.insert(&t2_arena, 20, 2, 200, node);
            let guard = qsbr::pin(node);
            let _ = t2_tier.get_slot(&t2_arena, 20, &2, &guard);
        });

        t1.join().unwrap();
        t2.join().unwrap();
    });
}
