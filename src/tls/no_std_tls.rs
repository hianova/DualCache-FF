use super::TlsProvider;
use crate::sync::index_types::TickType;

#[derive(Clone)]
pub struct DefaultTls;

impl TlsProvider for DefaultTls {
    #[inline(always)]
    fn get_worker_id(&self) -> Option<usize> {
        None
    }

    #[inline(always)]
    fn with_hit_buf(&self, _f: &mut dyn FnMut(&mut ([usize; 64], usize))) {}

    #[inline(always)]
    fn with_l1_filter(&self, _f: &mut dyn FnMut(&mut ([u8; 4096], usize))) {}

    #[inline(always)]
    fn with_last_flush_tick(&self, _f: &mut dyn FnMut(&mut TickType)) {}

    #[inline(always)]
    fn with_warmup_state(&self, f: &mut dyn FnMut(&mut u8)) {
        // In no_std mode, bypass intelligent warmup by always passing 255
        let mut state = 255;
        f(&mut state);
    }
}
