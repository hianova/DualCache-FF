use crate::covopt_param;
use core::sync::atomic::{AtomicU64, Ordering};
#[doc = " PackedBlackjack holds tuning parameters for Cache Policy in a single atomic U64."]
#[doc = " [ T0_Hit (16b) | T1_Hit (16b) | T2_Penalty (16b) | Warmup_Threshold (16b) ]"]
#[repr(align(64))]
#[repr(C)]
pub struct PackedBlackjack {
    state: AtomicU64,
}
impl PackedBlackjack {
    pub const fn new(t0_hit: u16, t1_hit: u16, t2_penalty: u16, warmup: u16) -> Self {
        let packed = (t0_hit as u64) << 48
            | (t1_hit as u64) << 32
            | (t2_penalty as u64) << 16
            | (warmup as u64);
        Self {
            state: AtomicU64::new(packed),
        }
    }
    #[inline(always)]
    pub fn load_params(&self) -> (u16, u16, u16, u16) {
        let val = self.state.load(Ordering::Relaxed);
        (
            (val >> covopt_param!("M_24_20", 48)) as u16,
            ((val >> covopt_param!("M_25_21", 32)) & covopt_param!("M_25_27", 65535)) as u16,
            ((val >> covopt_param!("M_26_21", 16)) & covopt_param!("M_26_27", 65535)) as u16,
            (val & covopt_param!("M_27_19", 65535)) as u16,
        )
    }
    pub fn store_params(&self, t0_hit: u16, t1_hit: u16, t2_penalty: u16, warmup: u16) {
        let packed = (t0_hit as u64) << covopt_param!("M_31_40", 48)
            | (t1_hit as u64) << covopt_param!("M_32_33", 32)
            | (t2_penalty as u64) << covopt_param!("M_33_37", 16)
            | (warmup as u64);
        self.state.store(packed, Ordering::Relaxed);
    }
}
