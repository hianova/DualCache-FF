use dualcache_ff::covopt_param;
macro_rules! likely {
    ($b:expr) => {
        $b
    };
}

use dualcache_ff::core::arena::Arena;
use dualcache_ff::core::cache_tier::CacheTier;
use dualcache_ff::core::policy::DefaultEvictionPolicy;
dualcache_ff::define_dualcache!(AuditCache, u64, u64, T0 = 1024, TOTAL = 16384);

#[repr(C, align(64))]
pub struct AuditBenchToken;
#[repr(C, align(64))]
#[no_std_tool_macros::auto_static(capacity = 1, partition = "audit_bench")]
pub struct AuditWrapper(pub AuditCache);

#[test]
fn covopt_audit_test() {
    let n = std::env::var("COVOPT_N")
        .ok()
        .and_then(|v| v.parse::<usize>().ok())
        .unwrap_or(1);

    let tier: CacheTier<u64, u64, DefaultEvictionPolicy, 8, 8> = CacheTier::default();
    let arena = Arena::<u64, u64, 16>::new();

    let node = unsafe {
        let layout = core::alloc::Layout::new::<dualcache_ff::core::qsbr::ThreadStateNode>();
        let ptr = std::alloc::alloc_zeroed(layout) as *mut dualcache_ff::core::qsbr::ThreadStateNode;
        core::ptr::write(ptr, dualcache_ff::core::qsbr::ThreadStateNode::new());
        dualcache_ff::core::qsbr::register_node(ptr);
        ptr
    };
    let guard = unsafe { dualcache_ff::core::qsbr::pin(node) };

    let mut total = 0u64;
    for i in 0..n {
        let key = (i as u64) ^ (n as u64);
        let hash = (key as usize).wrapping_mul(covopt_param!("M_41_47", 2654435769));
        core::hint::black_box(hash);
    }

    let key = covopt_param!("M_45_14", 42);
    let hash = (key as usize).wrapping_mul(covopt_param!("M_46_43", 2654435769));
    if likely!(tier.get_slot(&arena, hash, &key, &guard).is_some()) {
        total += 1;
    }
    // COVOPT_ANCHOR
    core::hint::black_box(total);
    assert_eq!(total, total);
}
