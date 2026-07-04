use std::thread::{self, JoinHandle};
use std::time::Duration;
use ::core::hash::Hash;



#[allow(clippy::large_enum_variant)]
pub enum DaemonMessage<K, V> {
    Hit(usize, u8),           // hash, weight
    HitBatch([(usize, u8); 32], u8), // batch of hits
    Promote(usize, K, V, u8), // hash, key, value, tier (0=T0, 2=T2)
    /// Dynamically adjust Daemon poll interval (Power-Saving Mode) - missing from v0.5.0
    SetPollInterval(u64),
    /// Zero-cost callbacks / blocking maintenance flush - missing from v0.5.0
    Sync(alloc::sync::Arc<OneshotAck>),
    /// Graceful shutdown - missing from v0.5.0
    Shutdown,
}

/// The Daemon manages background tasks like TLS-to-Core promotion
/// and QSBR memory reclamation.
pub struct Daemon {
    _handle: JoinHandle<()>,
}

impl Daemon {
    fn compress_and_push<K, V>(batch: &mut alloc::vec::Vec<DaemonMessage<K, V>>, msg: DaemonMessage<K, V>) {
        match msg {
            DaemonMessage::Hit(hash, weight) => {
                if let Some(DaemonMessage::Hit(last_hash, last_weight)) = batch.last_mut()
                    && *last_hash == hash {
                        *last_weight = last_weight.saturating_add(weight);
                        return;
                    }
                batch.push(DaemonMessage::Hit(hash, weight));
            }
            DaemonMessage::HitBatch(arr, len) => {
                for &(hash, weight) in arr[..(len as usize)].iter() {
                    let mut found = false;
                    if let Some(DaemonMessage::Hit(last_hash, last_weight)) = batch.last_mut()
                        && *last_hash == hash {
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

    /// Spawn the daemon thread. Returns the Daemon handle.
    pub fn spawn<K, V, P, const CAP2: usize, const CAP1: usize, const CAP0: usize, const TOTAL_CAP: usize>(
        core: &'static crate::core::DualCacheCore<K, V, P, CAP2, CAP1, CAP0, TOTAL_CAP>, 
        rx: ::alloc::sync::Arc<no_std_tool::collections::mpsc_queue::BoundedQueue<DaemonMessage<K, V>, 65536>>,
        broadcast_txs: alloc::vec::Vec<::alloc::sync::Arc<no_std_tool::collections::mpsc_queue::BoundedQueue<(usize, u8), 1024>>>,
        daemon_node: *mut crate::componant::qsbr::ThreadStateNode
    ) -> Self
    where
        K: Clone + Eq + Hash + Send + Sync + 'static,
        V: Clone + Send + Sync + 'static,
        P: crate::componant::config::CachePolicy + Send + Sync + 'static,
    {
        let daemon_node_ptr = daemon_node as usize;
        let handle = thread::spawn(move || {
            let daemon_node = daemon_node_ptr as *mut crate::componant::qsbr::ThreadStateNode;
            let mut batch = alloc::vec::Vec::with_capacity(65536);
            let mut poll_ms = 10;
            loop {
                let mut disconnected = false;

                // 1. Log Compaction (High Fidelity Compression)
                let msg_opt = rx.pop();
                
                match msg_opt {
                    Some(msg) => {
                        Self::compress_and_push(&mut batch, msg);
                        while batch.len() < 65536 {
                            if let Some(next_msg) = rx.pop() {
                                Self::compress_and_push(&mut batch, next_msg);
                            } else {
                                break;
                            }
                        }
                    }
                    None => {
                        if ::alloc::sync::Arc::strong_count(&rx) == 1 {
                            disconnected = true;
                        } else {
                            thread::sleep(Duration::from_millis(poll_ms));
                        }
                    }
                }

                // 2. Process batch and Broadcast
                for msg in batch.drain(..) {
                    match msg {
                        DaemonMessage::Hit(hash, weight) => {
                            core.record_remote_hit(hash, weight);
                            for tx in &broadcast_txs {
                                let _ = tx.push((hash, weight));
                            }
                        }
                        DaemonMessage::HitBatch(_, _) => unreachable!(),
                        DaemonMessage::Promote(_hash, key, value, tier) => {
                            if tier == 0 {
                                core.put_t0(key, value, daemon_node);
                            } else {
                                core.put(key, value, daemon_node);
                            }
                        }
                        DaemonMessage::SetPollInterval(ms) => {
                            poll_ms = ms;
                        }
                        DaemonMessage::Sync(ack) => {
                            ack.signal();
                        }
                        DaemonMessage::Shutdown => {
                            disconnected = true;
                        }
                    }
                }

                // Pin daemon node so it updates its QSBR epoch and participates in GC
                let _guard = crate::componant::qsbr::pin(daemon_node);

                if disconnected {
                    break;
                }

                // 3. Perform background QSBR reclamation to free old memory
                core.try_reclaim(daemon_node);
            }
        });
        Self { _handle: handle }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_daemon_compress_and_push() {
        let mut batch: alloc::vec::Vec<DaemonMessage<u64, u64>> = alloc::vec::Vec::new();
        Daemon::compress_and_push(&mut batch, DaemonMessage::Hit(1, 10));
        Daemon::compress_and_push(&mut batch, DaemonMessage::Hit(1, 5));
        Daemon::compress_and_push(&mut batch, DaemonMessage::Hit(2, 5));
        
        let mut arr = [(0usize, 0u8); 32];
        arr[0] = (2, 5);
        arr[1] = (3, 10);
        Daemon::compress_and_push(&mut batch, DaemonMessage::HitBatch(arr, 2));
    }
}

use core::sync::atomic::{AtomicBool, Ordering};
use ::alloc::sync::Arc;

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
            if spins < 100 {
                core::hint::spin_loop();
                spins += 1;
            } else {
                std::thread::yield_now();
            }
        }
    }
}
