use core::ops::{Deref, DerefMut};

/// A wrapper that perfectly aligns its contents to a CPU cache line (64 bytes).
/// This prevents false sharing when elements are placed in an array or accessed concurrently.
#[repr(C, align(64))]
#[derive(Debug, Clone, Default)]
pub struct CacheAligned<T>(pub T);

impl<T> CacheAligned<T> {
    #[inline(always)]
    pub const fn new(inner: T) -> Self {
        Self(inner)
    }
}

impl<T> Deref for CacheAligned<T> {
    type Target = T;

    #[inline(always)]
    fn deref(&self) -> &Self::Target {
        &self.0
    }
}

impl<T> DerefMut for CacheAligned<T> {
    #[inline(always)]
    fn deref_mut(&mut self) -> &mut Self::Target {
        &mut self.0
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use core::mem;

    #[test]
    fn test_cache_alignment() {
        let aligned = CacheAligned::new(100u32);
        let ptr_addr = &aligned as *const _ as usize;
        assert_eq!(ptr_addr % 64, 0, "Address is not 64-byte aligned");
        assert_eq!(mem::size_of::<CacheAligned<u32>>(), 64);
        assert_eq!(mem::align_of::<CacheAligned<u32>>(), 64);
    }

    #[test]
    fn test_deref_mut() {
        let mut aligned = CacheAligned::new(100u32);
        assert_eq!(*aligned, 100);
        *aligned = 200;
        assert_eq!(*aligned, 200);
        
        let val = aligned.0;
        assert_eq!(val, 200);
    }
}
