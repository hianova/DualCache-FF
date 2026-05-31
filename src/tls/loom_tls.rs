use super::TlsProvider;
use crate::sync::atomic::Ordering;
use crate::sync::index_types::TickType;
use core::cell::{Cell, RefCell};
use alloc::{vec, vec::Vec, boxed::Box};

loom::lazy_static! {
    static ref NEXT_THREAD_ID: loom::sync::atomic::AtomicUsize = loom::sync::atomic::AtomicUsize::new(0);
}

loom::thread_local! {
    static WORKER_ID: usize = NEXT_THREAD_ID.fetch_add(1, Ordering::Relaxed);

    /// Hit index buffer: batches 64 Cache-hit global indices before sending
    /// to Daemon via the hit queue.
    static HIT_BUF: RefCell<([usize; 64], usize)> = RefCell::new(([0; 64], 0));

    /// TLS probation filter: prevents single-hit items from reaching the
    /// Arena. A 4 KB sketch that decays periodically.
    /// Heap-allocated under Loom via `vec!` to prevent virtual coroutine stack overflow.
    static L1_FILTER: RefCell<(Box<[u8]>, usize)> = RefCell::new((vec![0u8; 4096].into_boxed_slice(), 0));

    /// Task 6 — last daemon_tick observed at TLS flush time.
    /// When `daemon_tick - LAST_FLUSH_TICK >= flush_tick_threshold`, the
    /// Worker force-drains its TLS buffer even if it is not full.
    static LAST_FLUSH_TICK: Cell<TickType> = Cell::new(0);

    /// Intelligent warmup state. 0 = full fast pass. >= 100 = normal mode.
    static WARMUP_STATE: Cell<u8> = Cell::new(0);
}

#[derive(Clone)]
pub struct DefaultTls;

impl TlsProvider for DefaultTls {
    #[inline(always)]
    fn get_worker_id(&self) -> Option<usize> {
        Some(WORKER_ID.with(|id| *id))
    }

    #[inline(always)]
    fn with_hit_buf(&self, f: &mut dyn FnMut(&mut ([usize; 64], usize))) {
        HIT_BUF.with(|buf| {
            f(&mut *buf.borrow_mut());
        });
    }

    #[inline(always)]
    fn with_l1_filter(&self, f: &mut dyn FnMut(&mut ([u8; 4096], usize))) {
        L1_FILTER.with(|filter| {
            let mut state = filter.borrow_mut();
            let mut arr = [0u8; 4096];
            arr.copy_from_slice(&state.0);
            let mut temp = (arr, state.1);
            f(&mut temp);
            state.0.copy_from_slice(&temp.0);
            state.1 = temp.1;
        });
    }

    #[inline(always)]
    fn with_last_flush_tick(&self, f: &mut dyn FnMut(&mut TickType)) {
        LAST_FLUSH_TICK.with(|cell| {
            let mut val = cell.get();
            f(&mut val);
            cell.set(val);
        });
    }

    #[inline(always)]
    fn with_warmup_state(&self, f: &mut dyn FnMut(&mut u8)) {
        WARMUP_STATE.with(|cell| {
            let mut val = cell.get();
            f(&mut val);
            cell.set(val);
        });
    }
}
