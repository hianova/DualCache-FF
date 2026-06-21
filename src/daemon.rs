#[cfg(not(feature = "std"))]
use alloc::{boxed::Box, vec::Vec};

use crate::sync::Arc;
use crate::sync::atomic::Ordering;
use crate::sync::index_types::AtomicTick;
use core::hash::{Hash, BuildHasher};

use crate::lossy_queue::{LossyQueue, OneshotAck};
use crate::core_cache::CoreCache;
use crate::shared_core::SharedCore;

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
    /// Dynamically adjust Daemon poll interval (Power-Saving Mode).
    SetPollInterval(u64),
    /// Signal Daemon to exit its run loop.
    Shutdown,
}

// ── Daemon ────────────────────────────────────────────────────────────────

pub struct Daemon<K, V, S> {
    pub hasher: S,
    pub core: Arc<SharedCore<K, V>>,
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
        core: Arc<SharedCore<K, V>>,
        cmd_rx: Arc<LossyQueue<Command<K, V>>>,
        hit_rx: Arc<LossyQueue<[usize; 64]>>,
        poll_us: u64,
        daemon_tick: Arc<AtomicTick>,
    ) -> Self {
        Self {
            hasher,
            core,
            cmd_rx,
            hit_rx,
            poll_us,
            daemon_tick,
        }
    }

    /// Main Daemon event loop.
    pub fn run(mut self) {
        #[cfg(feature = "std")]
        if let Ok(mut guard) = self.core.daemon_thread.lock() {
            *guard = Some(std::thread::current());
        }

        #[cfg(feature = "std")]
        let mut last_epoch_tick = std::time::Instant::now();

        loop {
            // If suspend mode is manually toggled, wait here until resumed.
            while self.core.is_suspended.load(Ordering::Acquire) {
                #[cfg(feature = "std")]
                std::thread::park();
                #[cfg(not(feature = "std"))]
                core::hint::spin_loop();
            }

            let mut processed = 0u32;
            let mut has_commands = false;

            // Only acquire the lock if we actually have work or periodic maintenance
            // Actually, we acquire the lock to do anything.
            let mut core = self.core.acquire_lock();

            // ── Drain command queue (up to 8192 commands per poll) ────────
            loop {
                match self.cmd_rx.try_recv() {
                    Some(cmd) => {
                        if !Self::process_cmd(&mut core, cmd, &mut self.poll_us) {
                            return; // Shutdown triggers false
                        }
                        processed += 1;
                        has_commands = true;
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
                let elapsed = now.duration_since(last_epoch_tick).as_millis() as u64;
                if elapsed >= 100 {
                    let ticks = (elapsed / 100) as u32;
                    core.epoch.fetch_add(ticks, Ordering::Relaxed);
                    last_epoch_tick += std::time::Duration::from_millis((ticks as u64) * 100);
                }
            }
            #[cfg(not(feature = "std"))]
            {
                let tick = self.daemon_tick.load(Ordering::Relaxed);
                if tick % 100 == 0 {
                    core.epoch.fetch_add(1, Ordering::Relaxed);
                }
            }

            // ── Phase 1: Collect hit indices into accumulator ─────────────────
            while let Some(batch) = self.hit_rx.try_recv() {
                core.process_hits(&batch);
                has_commands = true;
                if core.hit_accumulator.len() >= 8192 {
                    break;
                }
            }

            // ── Maintenance (GC + hit processing + eviction) ──────────────
            core.maintenance();

            // ── Advance daemon_tick ───────────────────────────────────────
            self.daemon_tick.fetch_add(1, Ordering::Relaxed);

            // Release the lock before we potentially park
            drop(core);

            // ── Idle sleep / park ─────────────────────────────────────────
            if !has_commands {
                #[cfg(feature = "std")]
                {
                    self.core.is_parked.store(true, Ordering::Release);
                    // double check to prevent lost wakeups
                    if self.cmd_rx.is_empty() && self.hit_rx.is_empty() && !self.core.is_suspended.load(Ordering::Acquire) {
                        std::thread::park_timeout(std::time::Duration::from_millis(100));
                    }
                    self.core.is_parked.store(false, Ordering::Release);
                }
                #[cfg(not(feature = "std"))]
                core::hint::spin_loop();
            }
        }
    }

    #[inline(always)]
    fn process_cmd(core: &mut CoreCache<K, V>, cmd: Command<K, V>, poll_us: &mut u64) -> bool {
        match cmd {
            Command::Insert(k, v, hash, is_t1) => {
                core.handle_admission_insert(k, v, hash, is_t1);
                true
            }
            Command::BatchInsert(batch) => {
                for (k, v, hash, is_t1) in batch {
                    core.handle_admission_insert(k, v, hash, is_t1);
                }
                true
            }
            Command::InsertT1(k, v, hash) => {
                core.handle_insert_t1(k, v, hash);
                true
            }
            Command::Remove(k, hash) => {
                core.handle_remove(k, hash);
                true
            }
            Command::Clear(ack) => {
                core.handle_clear();
                ack.signal();
                true
            }
            Command::Sync(ack) => {
                core.maintenance();
                ack.signal();
                true
            }
            Command::SetPollInterval(us) => {
                *poll_us = us;
                true
            }
            Command::Shutdown => false,
        }
    }
}
