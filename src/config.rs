#[derive(Debug, Clone, Copy)]
pub struct Config {
    pub capacity: usize,
    pub t1_slots: usize,
    pub t2_slots: usize,
    /// TTL duration in epoch ticks (one tick ≈ 100 ms in std mode).
    pub duration: u32,
    pub threads: usize,
    /// Daemon poll interval in **microseconds** (1 000–10 000 µs = 1–10 ms).
    pub poll_us: u64,
    /// TLS flush threshold in **daemon ticks**.
    pub flush_tick_threshold: u64,
}

impl Config {
    /// Budget-based constructor: specify RAM and TTL, the engine picks sizes.
    pub fn with_memory_budget(ram_mb: usize, duration: u32) -> Self {
        // Assume total overhead per item is ~128 bytes
        let raw_capacity = (ram_mb * 1024 * 1024) / 128;
        let capacity = raw_capacity.next_power_of_two().max(256);

        Self {
            capacity,
            // T1 fits in L1 cache: max 2048 × 8-byte pointers = 16 KB
            t1_slots: 2048,
            // T2 intercepts warm data: 20% of capacity (80/20 rule)
            t2_slots: (capacity / 5).next_power_of_two().max(4096),
            duration,
            #[cfg(feature = "std")]
            threads: std::thread::available_parallelism()
                .map(|p| p.get())
                .unwrap_or(16),
            #[cfg(not(feature = "std"))]
            threads: 8,
            poll_us: 1_000,
            flush_tick_threshold: 1,
        }
    }

    /// Expert constructor with explicit physical-law assertions.
    pub fn new_expert(
        capacity: usize,
        t1_slots: usize,
        t2_slots: usize,
        duration: u32,
        threads: usize,
    ) -> Self {
        // Physical Law 1: Bitmask routing requires powers of two
        assert!(capacity.is_power_of_two(), "Capacity MUST be a power of two");
        assert!(t1_slots.is_power_of_two(), "T1 slots MUST be a power of two");
        assert!(t2_slots.is_power_of_two(), "T2 slots MUST be a power of two");

        // Physical Law 2: T1 absolutely cannot exceed L1 cache
        assert!(
            t1_slots <= 4096,
            "T1 size exceeds L1 Cache physical limits! Max slots: 4096"
        );

        Self {
            capacity,
            t1_slots,
            t2_slots,
            duration,
            threads,
            poll_us: 1_000,
            flush_tick_threshold: 1,
        }
    }

    /// Builder: set Daemon poll interval (1 000–10 000 µs).
    pub fn with_poll_us(mut self, poll_us: u64) -> Self {
        let clamped = if poll_us < 1_000 {
            1_000
        } else if poll_us > 10_000 {
            10_000
        } else {
            poll_us
        };
        self.poll_us = clamped;
        self
    }

    /// Builder: set TLS flush threshold in daemon ticks.
    pub fn with_flush_tick_threshold(mut self, ticks: u64) -> Self {
        self.flush_tick_threshold = if ticks < 1 { 1 } else { ticks };
        self
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_config_poll_clamping() {
        let c1 = Config::with_memory_budget(1024, 8).with_poll_us(500);
        assert_eq!(c1.poll_us, 1_000);

        let c2 = Config::with_memory_budget(1024, 8).with_poll_us(15_000);
        assert_eq!(c2.poll_us, 10_000);

        let c3 = Config::with_memory_budget(1024, 8).with_poll_us(5_000);
        assert_eq!(c3.poll_us, 5_000);
    }

    #[test]
    fn test_config_flush_tick() {
        let c1 = Config::with_memory_budget(1024, 8).with_flush_tick_threshold(0);
        assert_eq!(c1.flush_tick_threshold, 1);

        let c2 = Config::with_memory_budget(1024, 8).with_flush_tick_threshold(10);
        assert_eq!(c2.flush_tick_threshold, 10);
    }

    #[test]
    fn test_config_memory_budget_asserts() {
        let config = Config::with_memory_budget(1024, 8); // 1024 MB
        assert!(config.capacity > 0);
        assert!(config.capacity.is_power_of_two());
        assert!(config.t1_slots.is_power_of_two());
        assert!(config.t2_slots.is_power_of_two());
        assert!(config.t1_slots <= 4096);
        assert_eq!(config.duration, 8);
        assert!(config.threads >= 1);
    }

    #[test]
    fn test_config_new_expert_valid() {
        let config = Config::new_expert(1024, 512, 1024, 60, 4);
        assert_eq!(config.capacity, 1024);
        assert_eq!(config.t1_slots, 512);
        assert_eq!(config.t2_slots, 1024);
        assert_eq!(config.duration, 60);
        assert_eq!(config.threads, 4);
    }

    #[test]
    #[should_panic(expected = "Capacity MUST be a power of two")]
    fn test_config_new_expert_invalid_capacity() {
        Config::new_expert(1000, 512, 1024, 60, 4);
    }

    #[test]
    #[should_panic(expected = "T1 slots MUST be a power of two")]
    fn test_config_new_expert_invalid_t1() {
        Config::new_expert(1024, 500, 1024, 60, 4);
    }

    #[test]
    #[should_panic(expected = "T2 slots MUST be a power of two")]
    fn test_config_new_expert_invalid_t2() {
        Config::new_expert(1024, 512, 1000, 60, 4);
    }

    #[test]
    #[should_panic(expected = "T1 size exceeds L1 Cache physical limits")]
    fn test_config_new_expert_invalid_t1_size() {
        Config::new_expert(1024, 8192, 1024, 60, 4);
    }
}
