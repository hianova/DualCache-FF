#![doc = " Static Configuration Policy for DualCacheCore"]
#![doc = " Uses a Trait-based Static Config pattern for maximum extensibility and zero runtime overhead."]
pub trait CachePolicy {
    type Evict: crate::core::policy::EvictionPolicy + Default;
    #[doc = " Hit count threshold to promote from Local TLS Cache to T2 Core Cache."]
    const T2_THRESHOLD: u16;
    #[doc = " Hit count threshold to promote from T2 to T1."]
    const T1_THRESHOLD: u16;
    #[doc = " Hit count threshold to promote from T1 to T0."]
    const T0_THRESHOLD: u16;
    #[doc = " Compile-Time Assertions"]
    #[doc = " Forces the user-defined thresholds to be powers of two."]
    const _ASSERT_POWER_OF_TWO: () = {
        assert!(
            Self::T2_THRESHOLD.is_power_of_two(),
            "T2 Threshold must be 2^n"
        );
        assert!(
            Self::T1_THRESHOLD.is_power_of_two(),
            "T1 Threshold must be 2^n"
        );
        assert!(
            Self::T0_THRESHOLD.is_power_of_two(),
            "T0 Threshold must be 2^n"
        );
    };
}
#[doc = " The default Exponential Policy scaling latency thresholds by 2^n."]
#[repr(C, align(64))]
pub struct DefaultExponentialPolicy;
impl CachePolicy for DefaultExponentialPolicy {
    type Evict = crate::core::policy::DefaultEvictionPolicy;
    const T2_THRESHOLD: u16 = 2;
    const T1_THRESHOLD: u16 = 16;
    const T0_THRESHOLD: u16 = 256;
}
