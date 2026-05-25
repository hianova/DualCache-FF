#[derive(Debug, Clone, Copy)]
pub struct Config {
    pub capacity: usize,
    pub t1_slots: usize,
    pub t2_slots: usize,
    /// TTL duration in epoch ticks (one tick ≈ 100 ms in std mode).
    pub duration: u32,
    pub threads: usize,
    /// Daemon poll interval in **microseconds** (1 000–10 000 µs = 1–10 ms).
    /// Controls the latency vs. idle-CPU trade-off.
    /// Lower = faster hit-signal delivery, higher CPU when idle.
    /// Higher = more efficient idle, but hotter TLS buffers may stall longer.
    pub poll_us: u64,
    /// TLS flush threshold in **daemon ticks**.
    /// A Worker forces a TLS buffer flush when it detects that the Daemon
    /// tick counter has advanced by at least this many ticks since the last
    /// flush, regardless of buffer fill level.
    ///
    /// Rule of thumb: `flush_tick_threshold ≈ 1ms / poll_us`.
    /// For poll_us = 1 000 µs (1 ms): threshold = 1.
    /// For poll_us = 5 000 µs (5 ms): threshold = 1 (flush every 5 ms).
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
