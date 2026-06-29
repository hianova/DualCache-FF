use std::sync::atomic::AtomicU32;

pub struct Arena<const N: usize> {
    next_free: [AtomicU32; N],
}

impl<const N: usize> Arena<N> {
    pub const fn new() -> Self {
        let mut next_free = [const { AtomicU32::new(0) }; N];
        let mut i = 0;
        while i < N - 1 {
            next_free[i] = AtomicU32::new((i + 1) as u32);
            i += 1;
        }
        next_free[N - 1] = AtomicU32::new(u32::MAX);
        Self { next_free }
    }
}

fn main() {}
