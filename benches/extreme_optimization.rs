use criterion::{criterion_group, criterion_main, Criterion, BenchmarkId, Throughput};
use std::sync::Arc;
use std::thread;

use dualcache_ff::componant::qsbr;
use dualcache_ff::core::engine::DualCacheCore;
use dualcache_ff::componant::config::DefaultExponentialPolicy;
use dualcache_ff::componant::tls::TlsRegistry;

// 2. Data Structure Overhead: test DualCacheCore put_t0 / put_t2 latency
fn bench_data_structure(c: &mut Criterion) {
    let mut group = c.benchmark_group("data_structure_latency");
    
    group.bench_function("put_t0_single_thread", |b| {
        let core: DualCacheCore<u64, u64, DefaultExponentialPolicy, 1024, 1024, 1024, 3072> = DualCacheCore::new();
        let node = Box::into_raw(Box::new(qsbr::ThreadStateNode::new()));
        qsbr::register_node(node);
        
        let mut i = 0;
        b.iter(|| {
            let _guard = qsbr::pin(node);
            core.put_t0(i, i, node);
            i = (i + 1) % 512;
            if i % 64 == 0 {
                core.try_reclaim(node);
            }
        });
    });

    group.bench_function("put_t2_single_thread", |b| {
        let core: DualCacheCore<u64, u64, DefaultExponentialPolicy, 1024, 1024, 1024, 3072> = DualCacheCore::new();
        let node = Box::into_raw(Box::new(qsbr::ThreadStateNode::new()));
        qsbr::register_node(node);
        
        let mut i = 0;
        b.iter(|| {
            let _guard = qsbr::pin(node);
            core.put(i, i, node);
            i = (i + 1) % 512;
            if i % 64 == 0 {
                core.try_reclaim(node);
            }
        });
    });
    
    group.finish();
}

// 3. TLS Parallel Overhead: test TlsRegistry get_block_mut contention
fn bench_tls(c: &mut Criterion) {
    let mut group = c.benchmark_group("tls_parallel_overhead");

    for threads in [1, 4, 8, 16].iter() {
        group.bench_with_input(BenchmarkId::new("get_block_mut_contention", threads), threads, |b, &threads| {
            let registry = Arc::new(Box::new(TlsRegistry::<u64, u64, 16, 128, 128>::new()));
            let mut handles = Vec::new();
            for _ in 0..threads {
                handles.push(registry.register_thread());
            }
            
            b.iter(|| {
                std::thread::scope(|s| {
                    for handle in &handles {
                        let reg = registry.clone();
                        s.spawn(move || {
                            for _ in 0..10_000 {
                                let block = reg.get_block_mut(handle);
                                criterion::black_box(block.op_count);
                            }
                        });
                    }
                });
            });
        });
    }

    group.finish();
}

criterion_group!(benches, bench_data_structure, bench_tls);
criterion_main!(benches);
