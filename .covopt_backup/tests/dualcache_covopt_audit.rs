macro_rules! likely {
    ($b:expr) => {
        $b
    };
}

use dualcache_ff::core::arena::Arena;
use dualcache_ff::core::cache_tier::CacheTier;
use dualcache_ff::core::policy::DefaultEvictionPolicy;
dualcache_ff::define_dualcache!(AuditCache, u64, u64, T0 = 1024, TOTAL = 16384);

pub struct AuditBenchToken;
#[no_std_tool_macros::auto_static(capacity = 1, partition = "audit_bench")]
pub struct AuditWrapper(pub AuditCache);

#[test]
fn covopt_audit_test() {
    let _n = std::env::var("COVOPT_N")
        .ok()
        .and_then(|v| v.parse::<usize>().ok())
        .unwrap_or(1);

    let mut token = AuditBenchToken;
    AuditWrapper::insert_large_std(|| AuditWrapper(dualcache_ff::DualCacheFF::new()), &mut token);
    let cache = &AuditWrapper::get(0, &AuditBenchToken).unwrap().0;
    cache.set_daemon_mode(true);
    let handle = cache.register_thread();

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
    for i in 0..1000 {
        let key = (i as u64) ^ (_n as u64);
        let hash = (key as usize).wrapping_mul(0x9E3779B9);
        cache.insert(key, key, &handle);
        if likely!(cache.get(&key, &handle).is_some()) {
            total += 1;
        }
        if likely!(tier.get_slot(&arena, hash, &key, &guard).is_some()) {
            total += 1;
        }
        // COVOPT_ANCHOR
        std::hint::black_box(total);
    }
}
