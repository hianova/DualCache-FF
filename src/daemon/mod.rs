use crate::sync::arc::Arc;
use crate::sync::thread::{self, JoinHandle};
#[cfg(not(loom))]
use std::time::Duration;
use ::core::hash::Hash;

use crossbeam_channel::Receiver;

#[allow(clippy::large_enum_variant)]
pub enum DaemonMessage<K, V> {
    Hit(usize, u8),           // hash, weight
    HitBatch([(usize, u8); 32], u8), // batch of hits
    Promote(usize, K, V, u8), // hash, key, value, tier (0=T0, 2=T2)
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
        }
    }

    /// Spawn the daemon thread. Returns the Daemon handle.
    pub fn spawn<K, V, P, const CAP2: usize, const CAP1: usize, const CAP0: usize, const TOTAL_CAP: usize>(
        core: Arc<crate::core::DualCacheCore<K, V, P, CAP2, CAP1, CAP0, TOTAL_CAP>>, 
        rx: Receiver<DaemonMessage<K, V>>,
        broadcast_txs: alloc::vec::Vec<crossbeam_channel::Sender<(usize, u8)>>,
        daemon_node: *mut crate::core::qsbr::ThreadStateNode
    ) -> Self
    where
        K: Clone + Eq + Hash + Send + Sync + 'static,
        V: Clone + Send + Sync + 'static,
        P: crate::core::config::CachePolicy + Send + Sync + 'static,
    {
        let daemon_node_ptr = daemon_node as usize;
        let handle = thread::spawn(move || {
            let daemon_node = daemon_node_ptr as *mut crate::core::qsbr::ThreadStateNode;
            let mut batch = alloc::vec::Vec::with_capacity(1024);
            loop {
                let mut disconnected = false;

                // 1. Log Compaction (High Fidelity Compression)
                #[cfg(not(loom))]
                let recv_res = rx.recv_timeout(Duration::from_millis(10));
                #[cfg(loom)]
                let recv_res = {
                    thread::yield_now();
                    rx.try_recv().map_err(|e| match e {
                        crossbeam_channel::TryRecvError::Empty => crossbeam_channel::RecvTimeoutError::Timeout,
                        crossbeam_channel::TryRecvError::Disconnected => crossbeam_channel::RecvTimeoutError::Disconnected,
                    })
                };

                match recv_res {
                    Ok(msg) => {
                        Self::compress_and_push(&mut batch, msg);
                        while batch.len() < 1024 {
                            if let Ok(next_msg) = rx.try_recv() {
                                Self::compress_and_push(&mut batch, next_msg);
                            } else {
                                break;
                            }
                        }
                    }
                    Err(crossbeam_channel::RecvTimeoutError::Disconnected) => disconnected = true,
                    Err(crossbeam_channel::RecvTimeoutError::Timeout) => {},
                }

                // 2. Process batch and Broadcast
                for msg in batch.drain(..) {
                    match msg {
                        DaemonMessage::Hit(hash, weight) => {
                            core.record_remote_hit(hash, weight);
                            for tx in &broadcast_txs {
                                let _ = tx.try_send((hash, weight));
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
                    }
                }

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
