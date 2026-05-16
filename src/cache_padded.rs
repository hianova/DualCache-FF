use core::ops::{Deref, DerefMut};

/// Cache-line-aligned wrapper to prevent false sharing between worker slots.
///
/// Replaces `crossbeam_utils::CachePadded` with zero external dependencies.
/// Uses `#[repr(C, align(N))]` directly:
/// - 128 bytes on Apple Silicon / ARM (128-byte cache line)
/// -  64 bytes on x86_64 and everything else (64-byte cache line)
#[cfg_attr(any(target_arch = "aarch64", target_arch = "arm"), repr(C, align(128)))]
#[cfg_attr(not(any(target_arch = "aarch64", target_arch = "arm")), repr(C, align(64)))]
pub struct CachePadded<T>(pub T);

impl<T> CachePadded<T> {
    #[inline(always)]
    pub fn new(val: T) -> Self {
        Self(val)
    }

    #[inline(always)]
    pub fn into_inner(self) -> T {
        self.0
    }
}

impl<T> Deref for CachePadded<T> {
    type Target = T;
    #[inline(always)]
    fn deref(&self) -> &T {
        &self.0
    }
}

impl<T> DerefMut for CachePadded<T> {
    #[inline(always)]
    fn deref_mut(&mut self) -> &mut T {
        &mut self.0
    }
}
