use crate::core::slot::Slot;
use ::core::sync::atomic::Ordering;
pub trait EvictionPolicy: Send + Sync {
    fn find_victim_idx<'a, K, V>(
        &self,
        set: &'a [Slot<K, V>],
        hash: usize,
    ) -> (usize, &'a Slot<K, V>);
}
#[doc = " The default Pseudo-LFU with Ring-Clock decay policy from v0.2.0"]
#[repr(C, align(64))]
pub struct DefaultEvictionPolicy;
impl DefaultEvictionPolicy {
    pub const fn new() -> Self {
        Self
    }
}
impl Default for DefaultEvictionPolicy {
    fn default() -> Self {
        Self::new()
    }
}
impl EvictionPolicy for DefaultEvictionPolicy {
    #[inline(always)]
    fn find_victim_idx<'a, K, V>(
        &self,
        set: &'a [Slot<K, V>],
        hash: usize,
    ) -> (usize, &'a Slot<K, V>) {
        let mut min_hits = u16::MAX;
        let mut candidates = [0; 8];
        let mut candidates_len = 0;
        for (i, slot) in set.iter().enumerate() {
            let hits = slot.hits.load(Ordering::Relaxed);
            if hits < min_hits {
                min_hits = hits;
                candidates_len = 0;
                candidates[candidates_len] = i;
                candidates_len += 1;
            } else if hits == min_hits && candidates_len < 8 {
                candidates[candidates_len] = i;
                candidates_len += 1;
            }
        }
        let victim_idx = if candidates_len > 1 {
            candidates[hash % candidates_len]
        } else {
            candidates[0]
        };
        if min_hits > 0 {
            for slot in set {
                let h = slot.hits.load(Ordering::Relaxed);
                slot.hits.store(h.saturating_sub(1), Ordering::Relaxed);
            }
        }
        (victim_idx, unsafe { set.get_unchecked(victim_idx) })
    }
}
