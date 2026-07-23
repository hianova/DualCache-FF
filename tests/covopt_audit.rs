#[inline(always)]
pub fn unlikely(b: bool) -> bool {
    b
}

use dualcache_ff::core::cache_tier::CacheTier;
use dualcache_ff::core::policy::DefaultEvictionPolicy;
use dualcache_ff::core::arena::Arena;

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
    let guard = dualcache_ff::core::qsbr::pin(node);
    
    let mut total = 0;
    for i in 0..n {
        let hash = i.wrapping_mul(0x9E3779B9);
        if tier.get_slot(&arena, hash, &(i as u64), &guard).is_some() {
            total += 1;
        }
    }
    std::hint::black_box(total);
}
