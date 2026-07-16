use std::vec::Vec;
use criterion::{BenchmarkId, Criterion, criterion_group};
use std::sync::Arc;

use dualcache_ff::component::tls::TlsRegistry;
use dualcache_ff::core::config::DefaultExponentialPolicy;
use dualcache_ff::core::engine::DualCacheCore;
use dualcache_ff::core::qsbr;

// 2. Data Structure Overhead: test DualCacheCore put_t0 / put_t2 latency
fn bench_data_structure(c: &mut Criterion) {
    let mut group = c.benchmark_group("data_structure_latency");

    group.bench_function("put_t0_single_thread", |b| {
        dualcache_ff::define_core_cache!(
            CoreType,
            u64,
            u64,
            DefaultExponentialPolicy,
            T0 = 1024,
            TOTAL = 3072
        );
        let core: CoreType =
            DualCacheCore::new(dualcache_ff::core::policy::DefaultEvictionPolicy::new());
        let node = Box::into_raw(Box::new(qsbr::ThreadStateNode::new()));
        qsbr::register_node(node);

        let mut i = 0;
        b.iter(|| {
            let _guard = qsbr::pin(node);
            core.put_t0(i, i, node);
            i = (i + 1) % 512;
            if i % 64 == 0 {
                core.sync_reclaim();
            }
        });
    });

    group.bench_function("put_t2_single_thread", |b| {
        dualcache_ff::define_core_cache!(
            CoreType2,
            u64,
            u64,
            DefaultExponentialPolicy,
            T0 = 1024,
            TOTAL = 3072
        );
        let core: CoreType2 =
            DualCacheCore::new(dualcache_ff::core::policy::DefaultEvictionPolicy::new());
        let node = Box::into_raw(Box::new(qsbr::ThreadStateNode::new()));
        qsbr::register_node(node);

        let mut i = 0;
        b.iter(|| {
            let _guard = qsbr::pin(node);
            core.put(i, i, node, 1);
            i = (i + 1) % 512;
            if i % 64 == 0 {
                core.sync_reclaim();
            }
        });
    });

    group.finish();
}

// 3. TLS Parallel Overhead: test TlsRegistry get_block_mut contention
fn bench_tls(c: &mut Criterion) {
    let mut group = c.benchmark_group("tls_parallel_overhead");

    for threads in [1, 4, 8, 16].iter() {
        group.bench_with_input(
            BenchmarkId::new("get_block_mut_contention", threads),
            threads,
            |b, &threads| {
                let registry = Arc::new(Box::new(TlsRegistry::<u64, u64, 128, 128>::default()));
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
            },
        );
    }

    group.finish();
}

criterion_group!(benches, bench_data_structure, bench_tls);

fn main() {
    std::thread::Builder::new()
        .stack_size(32 * 1024 * 1024)
        .spawn(|| {
            benches();
        })
        .unwrap()
        .join()
        .unwrap();
}
