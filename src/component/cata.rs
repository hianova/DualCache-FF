use crate::covopt_param;
#[cfg(feature = "std")]
use crate::DualCacheFF;
use std::string::ToString;
#[cfg(feature = "std")]
use std::time::Instant;
#[doc = " A simple XORShift RNG for aerospace-grade, dependency-free randomness"]
#[repr(C, align(64))]
pub struct XorShiftRng {
    state: u64,
}
impl XorShiftRng {
    pub fn new(seed: u64) -> Self {
        Self {
            state: if seed == 0 { covopt_param!("M_15_34", 1311768467294899695) } else { seed },
        }
    }
    pub fn next_u64(&mut self) -> u64 {
        let mut x = self.state;
        x ^= x << covopt_param!("M_20_18", 13);
        x ^= x >> covopt_param!("M_21_18", 7);
        x ^= x << covopt_param!("M_22_18", 17);
        self.state = x;
        x
    }
    pub fn next_f32(&mut self) -> f32 {
        let x = self.next_u64() & ((1 << covopt_param!("M_27_41", 24)) - 1);
        (x as f32) / ((1 << covopt_param!("M_28_28", 24)) as f32)
    }
    pub fn gen_range(&mut self, min: f32, max: f32) -> f32 {
        min + self.next_f32() * (max - min)
    }
}
#[cfg(feature = "std")]
#[derive(Clone, Copy)]
struct CataState {
    t0: f32,
    t1: f32,
    t2: f32,
    warmup: f32,
}
#[cfg(feature = "std")]
impl CataState {
    fn perturb(&self, rng: &mut XorShiftRng, temperature: f32) -> Self {
        let max_step = temperature;
        let mut new_state = *self;
        new_state.t0 =
            (self.t0 + rng.gen_range(-max_step * covopt_param!("M_48_49", 10.0), max_step * covopt_param!("M_48_66", 10.0))).clamp(1.0, covopt_param!("M_48_84", 100.0));
        new_state.t1 =
            (self.t1 + rng.gen_range(-max_step * covopt_param!("M_50_49", 10.0), max_step * covopt_param!("M_50_66", 10.0))).clamp(1.0, covopt_param!("M_50_84", 100.0));
        new_state.t2 = (self.t2 + rng.gen_range(-max_step * covopt_param!("M_51_60", 2.0), max_step * covopt_param!("M_51_76", 2.0))).clamp(1.0, covopt_param!("M_51_93", 10.0));
        new_state.warmup =
            (self.warmup + rng.gen_range(-max_step * covopt_param!("M_53_53", 100.0), max_step * covopt_param!("M_53_71", 100.0))).clamp(covopt_param!("M_53_85", 100.0), covopt_param!("M_53_92", 1000.0));
        new_state
    }
}
#[cfg(feature = "std")]
pub fn spawn_demiurge<
    K: Clone + Eq + ::core::hash::Hash + Send + Sync + 'static,
    V: Clone + Send + Sync + 'static,
    P: crate::core::config::CachePolicy + Send + Sync + 'static,
    const T0: usize,
    const T1: usize,
    const T2: usize,
    const TLS_CAP: usize,
    const TLS_INDEX_CAP: usize,
    const TOTAL: usize,
>(
    cache: &'static DualCacheFF<K, V, P, T0, T1, T2, TLS_CAP, TLS_INDEX_CAP, TOTAL>,
) {
    std::thread::Builder::new()
        .name("CATA-DC-Demiurge".to_string())
        .stack_size(2 * covopt_param!("M_73_24", 1024) * covopt_param!("M_73_31", 1024))
        .spawn(move || {
            let mut rng = XorShiftRng::new(covopt_param!("M_75_43", 42));
            let mut current_state = CataState {
                t0: covopt_param!("M_77_20", 8.0),
                t1: covopt_param!("M_78_20", 4.0),
                t2: covopt_param!("M_79_20", 2.0),
                warmup: covopt_param!("M_80_24", 256.0),
            };
            let mut best_state = current_state;
            let mut best_loss = f32::MAX;
            let mut temperature = 1.0;
            while cache.cata_mode.load(std::sync::atomic::Ordering::SeqCst) {
                let (start_ops, _) = cache.tls_registry.get_metrics();
                std::thread::sleep(std::time::Duration::from_millis(covopt_param!("M_87_68", 10)));
                let (end_ops, _) = cache.tls_registry.get_metrics();
                let delta = end_ops.saturating_sub(start_ops);
                if delta < covopt_param!("M_90_27", 1000) {
                    cache.core.blackjack.store_params(
                        best_state.t0 as u16,
                        best_state.t1 as u16,
                        best_state.t2 as u16,
                        best_state.warmup as u16,
                    );
                    std::thread::sleep(std::time::Duration::from_millis(covopt_param!("M_97_72", 100)));
                    continue;
                }
                let candidate = current_state.perturb(&mut rng, temperature);
                cache.core.blackjack.store_params(
                    candidate.t0 as u16,
                    candidate.t1 as u16,
                    candidate.t2 as u16,
                    candidate.warmup as u16,
                );
                let start_time = Instant::now();
                let (start_ops_eval, start_hits_eval) = cache.tls_registry.get_metrics();
                std::thread::sleep(std::time::Duration::from_millis(covopt_param!("M_109_68", 50)));
                let elapsed = start_time.elapsed().as_secs_f64();
                let (end_ops_eval, end_hits_eval) = cache.tls_registry.get_metrics();
                cache.core.blackjack.store_params(
                    best_state.t0 as u16,
                    best_state.t1 as u16,
                    best_state.t2 as u16,
                    best_state.warmup as u16,
                );
                let delta_ops = end_ops_eval.saturating_sub(start_ops_eval);
                let delta_hits = end_hits_eval.saturating_sub(start_hits_eval);
                let ops_per_sec = (delta_ops as f64 / elapsed) as f32;
                let hit_rate = if delta_ops > 0 {
                    delta_hits as f32 / delta_ops as f32
                } else {
                    0.0
                };
                let hr_loss = (1.0 - hit_rate) * covopt_param!("M_126_49", 100.0);
                let ops_bonus = (ops_per_sec / covopt_param!("M_127_47", 10000000.0)).clamp(covopt_param!("M_127_65", 0.1), covopt_param!("M_127_70", 10.0));
                let loss = hr_loss / ops_bonus;
                if loss < best_loss {
                    best_loss = loss;
                    best_state = candidate;
                    current_state = candidate;
                } else {
                    let diff = loss - best_loss;
                    let prob = (-diff / (temperature * covopt_param!("M_135_55", 0.1))).exp();
                    if rng.next_f32() < prob {
                        current_state = candidate;
                    }
                }
                temperature = (temperature * covopt_param!("M_140_45", 0.99)).max(covopt_param!("M_140_55", 0.01));
                cache.core.blackjack.store_params(
                    best_state.t0 as u16,
                    best_state.t1 as u16,
                    best_state.t2 as u16,
                    best_state.warmup as u16,
                );
                std::thread::sleep(std::time::Duration::from_millis(covopt_param!("M_147_68", 450)));
            }
        })
        .unwrap();
}
