#[cfg(not(feature = "std"))]
use alloc::{boxed::Box, vec::Vec};

use crate::sync::{Arc, ArcSlice};
use crate::sync::atomic::{AtomicBool, AtomicU32, Ordering};
use crate::sync::index_types::AtomicTick;
use core::hash::{Hash, BuildHasher};

use crate::storage::Cache;
use crate::filters::{T1, T2};
use crate::lossy_queue::{LossyQueue, OneshotAck};
use crate::cache::WorkerState;
use crate::core_cache::CoreCache;

// ── Command ───────────────────────────────────────────────────────────────

pub enum Command<K, V> {
    /// Single insert from Worker (goes through probation gate).
    Insert(K, V, u64, bool),
    /// Batch of (K, V, hash) from sharded worker buffers.
    BatchInsert(Vec<(K, V, u64, bool)>),
    /// Insert directly as a top priority item bypassing probation.
    InsertT1(K, V, u64),
    /// Remove by key+hash.
    Remove(K, u64),
    /// Blocking clear — caller spins on `OneshotAck::wait()`.
    Clear(Arc<OneshotAck>),
    /// Blocking maintenance flush — caller spins on `OneshotAck::wait()`.
    Sync(Arc<OneshotAck>),
    /// Signal Daemon to exit its run loop.
    Shutdown,
}

// ── Daemon ────────────────────────────────────────────────────────────────

pub struct Daemon<K, V, S> {
    pub hasher: S,
    pub core: CoreCache<K, V>,
    pub cmd_rx: Arc<LossyQueue<Command<K, V>>>,
    pub hit_rx: Arc<LossyQueue<[usize; 64]>>,
    /// Configurable poll interval in microseconds (1 000–10 000 µs).
    pub poll_us: u64,
    /// Monotonically increasing tick counter — incremented on every poll loop.
    pub daemon_tick: Arc<AtomicTick>,
}

unsafe impl<K: Send, V: Send, S: Send> Send for Daemon<K, V, S> {}

impl<K, V, S> Daemon<K, V, S>
where
    K: Hash + Eq + Send + Sync + Clone + 'static,
    V: Send + Sync + Clone + 'static,
    S: BuildHasher + Clone + Send + 'static,
{
    #[allow(clippy::too_many_arguments)]
    pub fn new(
        hasher: S,
        capacity: usize,
        t1: Arc<T1<K, V>>,
        t2: Arc<T2<K, V>>,
        cache: Arc<Cache<K, V>>,
        cmd_rx: Arc<LossyQueue<Command<K, V>>>,
        hit_rx: Arc<LossyQueue<[usize; 64]>>,
        epoch: Arc<AtomicU32>,
        duration: u32,
        poll_us: u64,
        worker_states: ArcSlice<WorkerState>,
        daemon_tick: Arc<AtomicTick>,
        is_cold_start: Arc<AtomicBool>,
    ) -> Self {
        Self {
            hasher,
            core: CoreCache::new(
                capacity,
                t1,
                t2,
                cache,
                epoch,
                duration,
                worker_states,
                is_cold_start,
            ),
            cmd_rx,
            hit_rx,
            poll_us,
            daemon_tick,
        }
    }

    /// Main Daemon event loop.
    pub fn run(mut self) {
        #[cfg(feature = "std")]
        let mut last_epoch_tick = std::time::Instant::now();

        loop {
            // ── Drain command queue (up to 8192 commands per poll) ────────
            let mut processed = 0u32;
            loop {
                match self.cmd_rx.try_recv() {
                    Some(Command::Shutdown) => return,
                    Some(cmd) => {
                        self.process_cmd(cmd);
                        processed += 1;
                        if processed >= 8192 {
                            break;
                        }
                    }
                    None => break,
                }
            }

            // ── Epoch tick ────────────────────────────────────────────────
            #[cfg(feature = "std")]
            {
                let now = std::time::Instant::now();
                if now.duration_since(last_epoch_tick)
                    >= std::time::Duration::from_millis(100)
                {
                    self.core.epoch.fetch_add(1, Ordering::Relaxed);
                    last_epoch_tick = now;
                }
            }
            #[cfg(not(feature = "std"))]
            {
                let tick = self.daemon_tick.load(Ordering::Relaxed);
                if tick % 100 == 0 {
                    self.core.epoch.fetch_add(1, Ordering::Relaxed);
                }
            }

            // ── Phase 1: Collect hit indices into accumulator ─────────────────
            while let Some(batch) = self.hit_rx.try_recv() {
                self.core.process_hits(&batch);
                if self.core.hit_accumulator.len() >= 8192 {
                    break;
                }
            }

            // ── Maintenance (GC + hit processing + eviction) ──────────────
            self.core.maintenance();

            // ── Advance daemon_tick ───────────────────────────────────────
            #[cfg(any(feature = "loom", loom))]
            {
                if processed > 0 {
                    self.daemon_tick.fetch_add(1, Ordering::Relaxed);
                }
            }
            #[cfg(not(any(feature = "loom", loom)))]
            {
                self.daemon_tick.fetch_add(1, Ordering::Relaxed);
            }

            // ── Idle sleep / spin ─────────────────────────────────────────
            if processed == 0 {
                #[cfg(any(feature = "loom", loom))]
                loom::thread::yield_now();
                #[cfg(all(feature = "std", not(any(feature = "loom", loom))))]
                std::thread::sleep(std::time::Duration::from_micros(self.poll_us));
                #[cfg(not(feature = "std"))]
                core::hint::spin_loop();
            }
        }
    }

    #[inline(always)]
    fn process_cmd(&mut self, cmd: Command<K, V>) -> bool {
        match cmd {
            Command::Insert(k, v, hash, is_t1) => {
                self.core.handle_admission_insert(k, v, hash, is_t1);
                true
            }
            Command::BatchInsert(batch) => {
                for (k, v, hash, is_t1) in batch {
                    self.core.handle_admission_insert(k, v, hash, is_t1);
                }
                true
            }
            Command::InsertT1(k, v, hash) => {
                self.core.handle_insert_t1(k, v, hash);
                true
            }
            Command::Remove(k, hash) => {
                self.core.handle_remove(k, hash);
                true
            }
            Command::Clear(ack) => {
                self.core.handle_clear();
                ack.signal();
                true
            }
            Command::Sync(ack) => {
                self.core.maintenance();
                ack.signal();
                true
            }
            Command::Shutdown => unreachable!("handled in run()"),
        }
    }
}
