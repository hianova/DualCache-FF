use crate::covopt_param;
use ::core::hash::Hash;
use std::thread::{self, JoinHandle};
pub enum DaemonMessage<K, V> {
    Hit(usize, u8),
    HitBatch(std::boxed::Box<([(usize, u8); 32], u8)>),
    Promote(usize, K, V, u8),
    #[doc = " Dynamically adjust Daemon poll interval (Power-Saving Mode) - missing from v0.5.0"]
    SetPollInterval(u64),
    #[doc = " Zero-cost callbacks / blocking maintenance flush - missing from v0.5.0"]
    Sync(std::sync::Arc<OneshotAck>),
    #[doc = " Graceful shutdown - missing from v0.5.0"]
    Shutdown,
}
#[doc = " The Daemon manages background tasks like TLS-to-Core promotion"]
#[doc = " and QSBR memory reclamation."]
#[repr(C, align(64))]
pub struct Daemon {
    handle: Option<JoinHandle<()>>,
}
impl Daemon {
    pub fn join(&mut self) {
        if let Some(handle) = self.handle.take() {
            let _ = handle.join();
        }
    }
    fn compress_and_push<K, V>(
        batch: &mut std::vec::Vec<DaemonMessage<K, V>>,
        msg: DaemonMessage<K, V>,
    ) {
        match msg {
            DaemonMessage::Hit(hash, weight) => {
                if let Some(DaemonMessage::Hit(last_hash, last_weight)) = batch.last_mut()
                    && *last_hash == hash
                {
                    *last_weight = last_weight.saturating_add(weight);
                    return;
                }
                batch.push(DaemonMessage::Hit(hash, weight));
            }
            DaemonMessage::HitBatch(boxed) => {
                let (arr, len) = *boxed;
                for &(hash, weight) in arr[..(len as usize)].iter() {
                    let mut found = false;
                    if let Some(DaemonMessage::Hit(last_hash, last_weight)) = batch.last_mut()
                        && *last_hash == hash
                    {
                        *last_weight = last_weight.saturating_add(weight);
                        found = true;
                    }
                    if !found {
                        batch.push(DaemonMessage::Hit(hash, weight));
                    }
                }
            }
            DaemonMessage::Promote(hash, key, val, tier) => {
                batch.push(DaemonMessage::Promote(hash, key, val, tier));
            }
            DaemonMessage::SetPollInterval(ms) => {
                batch.push(DaemonMessage::SetPollInterval(ms));
            }
            DaemonMessage::Sync(ack) => {
                batch.push(DaemonMessage::Sync(ack));
            }
            DaemonMessage::Shutdown => {
                batch.push(DaemonMessage::Shutdown);
            }
        }
    }
    #[doc = " Spawn the daemon thread. Returns the Daemon handle."]
    #[inline(never)]
    pub fn spawn<
        K,
        V,
        P,
        const CAP2: usize,
        const CAP1: usize,
        const CAP0: usize,
        const TOTAL_CAP: usize,
    >(
        core: &'static crate::core::DualCacheCore<K, V, P, CAP2, CAP1, CAP0, TOTAL_CAP>,
        rx: std::sync::Arc<
            no_std_tool::collections::mpsc_queue::BoundedQueue<DaemonMessage<K, V>, 65536>,
        >,
        broadcast_txs: std::vec::Vec<
            std::sync::Arc<no_std_tool::collections::mpsc_queue::BoundedQueue<(usize, u8), 1024>>,
        >,
        daemon_node: *mut crate::core::qsbr::ThreadStateNode,
    ) -> Self
    where
        K: Clone + Eq + Hash + Send + Sync + 'static,
        V: Clone + Send + Sync + 'static,
        P: crate::core::config::CachePolicy + Send + Sync + 'static,
    {
        let daemon_node_ptr = daemon_node as usize;
        let handle = thread::spawn(move || {
            let daemon_node = daemon_node_ptr as *mut crate::core::qsbr::ThreadStateNode;
            let mut batch = std::vec::Vec::with_capacity(covopt_param!("M_98_57", 65536));
            let mut _poll_ms = covopt_param!("M_99_31", 10);
            let mut empty_spins = 0u32;
            let batch_limit = covopt_param!("M_101_30", 65536);
            loop {
                let mut disconnected = false;
                let msg_opt = rx.pop();
                match msg_opt {
                    Some(msg) => {
                        empty_spins = 0;
                        Self::compress_and_push(&mut batch, msg);
                        while batch.len() < batch_limit {
                            if let Some(next_msg) = rx.pop() {
                                Self::compress_and_push(&mut batch, next_msg);
                            } else {
                                break;
                            }
                        }
                    }
                    None => {
                        empty_spins = empty_spins.saturating_add(1);
                        if std::sync::Arc::strong_count(&rx) == 1 {
                            disconnected = true;
                        } else {
                            if empty_spins < covopt_param!("M_122_45", 100) {
                                core::hint::spin_loop();
                            } else if empty_spins < covopt_param!("M_124_52", 200) {
                                std::thread::yield_now();
                            } else {
                                let shift = core::cmp::min((empty_spins - covopt_param!("M_127_74", 200)) / covopt_param!("M_127_81", 10), covopt_param!("M_127_85", 6));
                                let backoff = 1u64 << shift;
                                let sleep_ms = core::cmp::min(backoff, _poll_ms);
                                thread::sleep(std::time::Duration::from_millis(sleep_ms));
                            }
                        }
                    }
                }
                let mut last_hash: Option<usize> = None;
                for msg in batch.drain(..) {
                    match msg {
                        DaemonMessage::Hit(hash, weight) => {
                            core.record_remote_hit(hash, weight);
                            if let Some(prev) = last_hash {
                                core.set_prefetch_hint(prev, hash);
                            }
                            last_hash = Some(hash);
                            for tx in &broadcast_txs {
                                let _ = tx.push((hash, weight));
                            }
                        }
                        DaemonMessage::HitBatch(_) => unreachable!(),
                        DaemonMessage::Promote(_hash, key, value, tier) => {
                            if tier == 0 {
                                unsafe { core.put_t0(key, value, daemon_node); }
                            } else {
                                unsafe { core.put(key, value, daemon_node, 1); }
                            }
                        }
                        DaemonMessage::SetPollInterval(ms) => {
                            _poll_ms = ms;
                        }
                        DaemonMessage::Sync(ack) => {
                            ack.signal();
                        }
                        DaemonMessage::Shutdown => {
                            disconnected = true;
                        }
                    }
                }
                let _guard = unsafe { crate::core::qsbr::pin(daemon_node) };
                crate::core::qsbr::daemon_reclaim(|batch| {
                    if batch.is_empty() {
                        return;
                    }
                    unsafe {
                        for i in 0..batch.len() {
                            let idx = batch[i];
                            core.arena.drop_node(idx as usize);
                            if i < batch.len() - 1 {
                                core.arena.set_next_free(idx, batch[i + 1]);
                            }
                        }
                        core.arena.free_batch(batch[0], batch[batch.len() - 1]);
                        core.arena.allocated_count.fetch_sub(batch.len(), core::sync::atomic::Ordering::Relaxed);
                    }
                });
                if disconnected {
                    let node_ref = unsafe { &*daemon_node };
                    node_ref.active.store(false, Ordering::Release);
                    break;
                }
            }
        });
        Self {
            handle: Some(handle),
        }
    }
}
use core::sync::atomic::{AtomicBool, Ordering};
use std::sync::Arc;
#[repr(align(64))]
#[repr(C)]
pub struct OneshotAck {
    ready: AtomicBool,
}
impl OneshotAck {
    pub fn new() -> Arc<Self> {
        Arc::new(Self {
            ready: AtomicBool::new(false),
        })
    }
    #[inline(always)]
    pub fn signal(&self) {
        self.ready.store(true, Ordering::Release);
    }
    #[inline(always)]
    pub fn wait(&self) {
        let mut spins = 0;
        while !self.ready.load(Ordering::Acquire) {
            if spins < covopt_param!("M_217_23", 100) {
                core::hint::spin_loop();
                spins += 1;
            } else {
                std::thread::yield_now();
            }
        }
    }
}
#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn test_daemon_compress_and_push() {
        let mut batch: std::vec::Vec<DaemonMessage<u64, u64>> = std::vec::Vec::new();
        Daemon::compress_and_push(&mut batch, DaemonMessage::Hit(1, covopt_param!("M_232_68", 10)));
        Daemon::compress_and_push(&mut batch, DaemonMessage::Hit(1, covopt_param!("M_233_68", 5)));
        Daemon::compress_and_push(&mut batch, DaemonMessage::Hit(2, covopt_param!("M_234_68", 5)));
        let mut arr = [(0usize, 0u8); 32];
        arr[0] = (2, covopt_param!("M_236_21", 5));
        arr[1] = (covopt_param!("M_237_18", 3), covopt_param!("M_237_21", 10));
        Daemon::compress_and_push(&mut batch, DaemonMessage::HitBatch(std::boxed::Box::new((arr, 2))));
    }
}
