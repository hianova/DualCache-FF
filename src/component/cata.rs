#[cfg(feature = "std")]
use crate::DualCacheFF;
#[cfg(feature = "std")]
use std::time::Instant;

/// A simple XORShift RNG for aerospace-grade, dependency-free randomness
pub struct XorShiftRng {
    state: u64,
}

impl XorShiftRng {
    pub fn new(seed: u64) -> Self {
        Self { state: if seed == 0 { 0x1234567890abcdef } else { seed } }
    }

    pub fn next_u64(&mut self) -> u64 {
        let mut x = self.state;
        x ^= x << 13;
        x ^= x >> 7;
        x ^= x << 17;
        self.state = x;
        x
    }

    pub fn next_f32(&mut self) -> f32 {
        let x = self.next_u64() & ((1 << 24) - 1);
        (x as f32) / ((1 << 24) as f32)
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
        new_state.t0 = (self.t0 + rng.gen_range(-max_step * 10.0, max_step * 10.0)).clamp(1.0, 100.0);
        new_state.t1 = (self.t1 + rng.gen_range(-max_step * 10.0, max_step * 10.0)).clamp(1.0, 100.0);
        new_state.t2 = (self.t2 + rng.gen_range(-max_step * 2.0, max_step * 2.0)).clamp(1.0, 10.0);
        new_state.warmup = (self.warmup + rng.gen_range(-max_step * 100.0, max_step * 100.0)).clamp(100.0, 1000.0);
        new_state
    }
}

#[cfg(feature = "std")]
pub fn spawn_demiurge<
    K, V, 
    const T2: usize, const T1: usize, const T0: usize, const TOTAL: usize,
    
>(
    cache: &'static DualCacheFF<K, V, T2, T1, T0, TOTAL>
) 
where 
    K: core::cmp::Eq + core::hash::Hash + Clone + Send + Sync + 'static,
    V: Clone + Send + Sync + 'static,
    
{
    std::thread::Builder::new()
        .name("CATA-DC-Demiurge".to_string())
        .stack_size(2 * 1024 * 1024)
        .spawn(move || {
            let mut rng = XorShiftRng::new(42);
            let mut current_state = CataState {
                t0: 8.0,
                t1: 4.0,
                t2: 2.0,
                warmup: 256.0,
            };
            
            let mut best_state = current_state;
            let mut best_loss = f32::MAX;
            let mut temperature = 1.0;

            while cache.cata_mode.load(std::sync::atomic::Ordering::SeqCst) {
                // Check if workload is active
                let (start_ops, _) = cache.get_metrics();
                std::thread::sleep(std::time::Duration::from_millis(10));
                let (end_ops, _) = cache.get_metrics();
                let delta = end_ops.saturating_sub(start_ops);
                
                if delta < 1000 {
                    // Workload is inactive (e.g. during warmup). Keep best parameters and sleep.
                    cache.core.blackjack.store_params(
                        best_state.t0 as u16,
                        best_state.t1 as u16,
                        best_state.t2 as u16,
                        best_state.warmup as u16,
                    );
                    std::thread::sleep(std::time::Duration::from_millis(100));
                    continue;
                }

                let candidate = current_state.perturb(&mut rng, temperature);
                
                // Apply candidate parameters
                cache.core.blackjack.store_params(
                    candidate.t0 as u16,
                    candidate.t1 as u16,
                    candidate.t2 as u16,
                    candidate.warmup as u16,
                );

                // Benchmark window (50ms)
                let start_time = Instant::now();
                let (start_ops_eval, start_hits_eval) = cache.get_metrics();
                
                std::thread::sleep(std::time::Duration::from_millis(50));
                
                let elapsed = start_time.elapsed().as_secs_f64();
                let (end_ops_eval, end_hits_eval) = cache.get_metrics();
                
                // Restore best parameters immediately to restore maximum performance
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
                
                // Loss function
                let hr_loss = (1.0 - hit_rate) * 100.0;
                let ops_bonus = (ops_per_sec / 10_000_000.0).clamp(0.1, 10.0);
                let loss = hr_loss / ops_bonus;

                // Acceptance criteria (Simulated Annealing)
                if loss < best_loss {
                    best_loss = loss;
                    best_state = candidate;
                    current_state = candidate;
                } else {
                    let diff = loss - best_loss;
                    let prob = (-diff / (temperature * 0.1)).exp();
                    if rng.next_f32() < prob {
                        current_state = candidate;
                    }
                }
                
                // Decay temperature
                temperature = (temperature * 0.99).max(0.01);
                
                // Re-apply best parameters just to be safe
                cache.core.blackjack.store_params(
                    best_state.t0 as u16,
                    best_state.t1 as u16,
                    best_state.t2 as u16,
                    best_state.warmup as u16,
                );
                
                // Stable execution window (450ms)
                std::thread::sleep(std::time::Duration::from_millis(450));
            }
        }).unwrap();
}
