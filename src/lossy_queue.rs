/// State Turnstile MPSC LossyQueue — zero external dependencies.
///
/// Replaces `crossbeam_channel::bounded` with a wait-free, lossy ring buffer
/// designed specifically for the DualCache-FF Worker→Daemon pipeline.
///
/// # Design Rationale
/// crossbeam_channel is a general-purpose channel with thread wake-up
/// machinery (Parker/Unparker), select! support, and complex state machines.
/// DualCache-FF only needs an extreme-speed, lossy, single-direction pipe.
///
/// # State Turnstile (per-slot AtomicU8)
/// Each slot carries a 3-state gate to prevent Daemon from reading
/// half-written data and to prevent Ring Buffer wraparound corruption:
///
///   EMPTY(0) ──[Producer CAS]──► WRITING(1) ──[store]──► READY(2)
///     ▲                                                        │
///     └──────────────[Daemon store after read]────────────────┘
///
/// # MPSC guarantee
/// Multiple producers atomically CAS EMPTY→WRITING to claim unique slots.
/// A single Daemon reads sequentially from `head`. No locks required.
///
/// # Lossy guarantee
/// If a slot is not EMPTY (e.g., WRITING or READY — ring buffer lapped),
/// the producer immediately returns Err(item). No blocking, ever.
use core::cell::UnsafeCell;
use core::mem::MaybeUninit;
use core::sync::atomic::{AtomicBool, AtomicUsize, AtomicU8, Ordering};

#[cfg(not(feature = "std"))]
use alloc::{boxed::Box, sync::Arc, vec::Vec};
#[cfg(feature = "std")]
use std::sync::Arc;

// ── Slot state constants ───────────────────────────────────────────────────

const EMPTY: u8 = 0;
const WRITING: u8 = 1;
const READY: u8 = 2;

// ── Slot ──────────────────────────────────────────────────────────────────

struct Slot<T> {
    state: AtomicU8,
    data: UnsafeCell<MaybeUninit<T>>,
}

unsafe impl<T: Send> Send for Slot<T> {}
unsafe impl<T: Send> Sync for Slot<T> {}

// ── LossyQueue ────────────────────────────────────────────────────────────

/// MPSC wait-free lossy ring buffer.
pub struct LossyQueue<T> {
    mask: usize,
    /// Producer cursor — FAA, unbounded (wraps via mask).
    tail: AtomicUsize,
    /// Consumer (Daemon) cursor — single-threaded advance.
    head: AtomicUsize,
    buffer: Box<[Slot<T>]>,
}

unsafe impl<T: Send> Send for LossyQueue<T> {}
unsafe impl<T: Send> Sync for LossyQueue<T> {}

impl<T> LossyQueue<T> {
    /// Create a new queue with the given capacity (must be a power of two).
    pub fn new(capacity: usize) -> Self {
        assert!(
            capacity.is_power_of_two(),
            "LossyQueue capacity must be a power of two"
        );
        let mut buf = Vec::with_capacity(capacity);
        for _ in 0..capacity {
            buf.push(Slot {
                state: AtomicU8::new(EMPTY),
                data: UnsafeCell::new(MaybeUninit::uninit()),
            });
        }
        Self {
            mask: capacity - 1,
            tail: AtomicUsize::new(0),
            head: AtomicUsize::new(0),
            buffer: buf.into_boxed_slice(),
        }
    }

    /// Worker path — try to enqueue an item.
    ///
    /// Uses FAA to claim a slot index, then CAS EMPTY→WRITING as a physical
    /// gate. If the slot is occupied (ring buffer lapped or concurrent writer),
    /// returns `Err(item)` immediately — never blocks.
    #[inline(always)]
    pub fn try_send(&self, item: T) -> Result<(), T> {
        let tail = self.tail.load(Ordering::Relaxed);
        let head = self.head.load(Ordering::Acquire);

        // Pre-check: if physically full, don't even try to FAA.
        // This prevents tail from flying away and causing massive overlaps.
        if tail.wrapping_sub(head) >= self.buffer.len() {
            return Err(item);
        }

        // FAA claims a position.
        let idx = self.tail.fetch_add(1, Ordering::Relaxed) & self.mask;
        let slot = &self.buffer[idx];

        // Physical gate: only proceed if the slot is truly empty.
        if slot
            .state
            .compare_exchange(EMPTY, WRITING, Ordering::Acquire, Ordering::Relaxed)
            .is_err()
        {
            return Err(item);
        }

        unsafe { (*slot.data.get()).write(item) };
        slot.state.store(READY, Ordering::Release);
        Ok(())
    }

    /// Blocking send for critical commands (Sync, Clear).
    /// Spins until the item is successfully enqueued.
    pub fn send_blocking(&self, mut item: T) {
        loop {
            match self.try_send(item) {
                Ok(_) => return,
                Err(returned_item) => {
                    item = returned_item;
                    core::hint::spin_loop();
                }
            }
        }
    }

    /// Daemon path — try to dequeue one item.
    ///
    /// Single-consumer: only Daemon ever calls this.
    /// Reads from `head`, returns `None` if the slot is not yet READY.
    #[inline(always)]
    pub fn try_recv(&self) -> Option<T> {
        let idx = self.head.load(Ordering::Relaxed) & self.mask;
        let slot = &self.buffer[idx];

        if slot.state.load(Ordering::Acquire) == READY {
            // Safe read: we are the exclusive consumer.
            let item = unsafe { (*slot.data.get()).assume_init_read() };

            // Reset gate and advance head.
            slot.state.store(EMPTY, Ordering::Release);
            self.head.fetch_add(1, Ordering::Relaxed);
            Some(item)
        } else {
            None
        }
    }
}

impl<T> Drop for LossyQueue<T> {
    fn drop(&mut self) {
        // Drain any READY items that were never consumed.
        loop {
            let idx = self.head.load(Ordering::Relaxed) & self.mask;
            let slot = &self.buffer[idx];
            if slot.state.load(Ordering::Acquire) == READY {
                unsafe { (*slot.data.get()).assume_init_drop() };
                slot.state.store(EMPTY, Ordering::Relaxed);
                self.head.fetch_add(1, Ordering::Relaxed);
            } else {
                break;
            }
        }
    }
}

// ── OneshotAck ────────────────────────────────────────────────────────────

/// Lightweight one-shot acknowledgment channel.
///
/// Replaces `crossbeam_channel::bounded(1)` used for `Sync` and `Clear`
/// command round-trips. Works in both `std` and `no_std` environments.
///
/// The caller creates an `Arc<OneshotAck>`, sends it in a `Command`, and
/// blocks on `wait()`. The Daemon calls `signal()` after processing.
pub struct OneshotAck {
    ready: AtomicBool,
}

impl OneshotAck {
    /// Allocate a new, unsignalled ack handle.
    pub fn new() -> Arc<Self> {
        Arc::new(Self {
            ready: AtomicBool::new(false),
        })
    }

    /// Daemon: signal that the command has been processed.
    #[inline(always)]
    pub fn signal(&self) {
        self.ready.store(true, Ordering::Release);
    }

    /// Caller: spin until the signal arrives.
    ///
    /// In `std` mode this is a brief spin (Sync/Clear commands are rare).
    /// In `no_std` / RTOS mode the RTOS scheduler preempts the spinning task.
    #[inline(always)]
    pub fn wait(&self) {
        while !self.ready.load(Ordering::Acquire) {
            core::hint::spin_loop();
        }
    }
}
