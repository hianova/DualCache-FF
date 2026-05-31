use super::TlsProvider;
use crate::sync::atomic::{AtomicUsize, Ordering};
use crate::sync::index_types::TickType;
use core::cell::{Cell, RefCell};
use std::sync::Mutex;
use alloc::vec::Vec;

struct IdAllocator {
    free_list: Mutex<Vec<usize>>,
    next_id: AtomicUsize,
}

static ALLOCATOR: IdAllocator = IdAllocator {
    free_list: Mutex::new(Vec::new()),
    next_id: AtomicUsize::new(0),
};

struct ThreadIdGuard {
    id: usize,
}

impl Drop for ThreadIdGuard {
    fn drop(&mut self) {
        if let Ok(mut list) = ALLOCATOR.free_list.lock() {
            list.push(self.id);
        }
    }
}

thread_local! {
    static WORKER_ID: usize = {
        let id = if let Ok(mut list) = ALLOCATOR.free_list.lock() {
            list.pop().unwrap_or_else(|| ALLOCATOR.next_id.fetch_add(1, Ordering::Relaxed))
        } else {
            ALLOCATOR.next_id.fetch_add(1, Ordering::Relaxed)
        };
        
        GUARD.with(|g| {
            *g.borrow_mut() = Some(ThreadIdGuard { id });
        });
        id
    };

    static GUARD: RefCell<Option<ThreadIdGuard>> = const { RefCell::new(None) };

    /// Hit index buffer: batches 64 Cache-hit global indices before sending
    /// to Daemon via the hit queue.
    static HIT_BUF: RefCell<([usize; 64], usize)> = const { RefCell::new(([0; 64], 0)) };

    /// TLS probation filter: prevents single-hit items from reaching the
    /// Arena. A 4 KB sketch that decays periodically.
    static L1_FILTER: RefCell<([u8; 4096], usize)> = const { RefCell::new(([0; 4096], 0)) };

    /// Task 6 — last daemon_tick observed at TLS flush time.
    /// When `daemon_tick - LAST_FLUSH_TICK >= flush_tick_threshold`, the
    /// Worker force-drains its TLS buffer even if it is not full.
    static LAST_FLUSH_TICK: Cell<TickType> = const { Cell::new(0) };

    /// Intelligent warmup state. 0 = full fast pass. >= 100 = normal mode.
    static WARMUP_STATE: Cell<u8> = const { Cell::new(0) };
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
            f(&mut *filter.borrow_mut());
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
