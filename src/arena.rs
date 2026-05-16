#[cfg(not(feature = "std"))]
use alloc::{vec, vec::Vec};

/// Slot allocator with QSBR epoch tracking support.
///
/// Tracks per-slot rank (frequency score) in a flat array for O(1)
/// eviction candidate selection. The free_list stack provides O(1)
/// slot allocation and reclamation.
pub struct Arena {
    pub(crate) capacity: usize,
    pub(crate) cursor: usize,
    pub(crate) rank: Vec<u8>,
    pub hashes: Vec<u64>,
    pub(crate) free_list: Vec<usize>,
    pub(crate) count_sum: u64,
}

unsafe impl Send for Arena {}
unsafe impl Sync for Arena {}

impl Arena {
    pub fn new(capacity: usize) -> Self {
        Self {
            capacity,
            cursor: 0,
            rank: vec![0; capacity],
            hashes: vec![0; capacity],
            free_list: (0..capacity).collect(),
            count_sum: 0,
        }
    }

    #[inline(always)]
    pub fn pop_free_slot(&mut self) -> Option<usize> {
        self.free_list.pop()
    }

    #[inline(always)]
    pub fn push_free_slot(&mut self, idx: usize) {
        self.free_list.push(idx);
    }

    #[inline(always)]
    pub fn free_list_empty(&self) -> bool {
        self.free_list.is_empty()
    }

    #[inline(always)]
    pub fn free_list_len(&self) -> usize {
        self.free_list.len()
    }

    #[inline(always)]
    pub fn set_hash(&mut self, idx: usize, hash: u64) {
        self.hashes[idx] = hash;
    }

    #[inline(always)]
    pub fn get_hash(&self, idx: usize) -> u64 {
        self.hashes[idx]
    }

    #[inline(always)]
    pub fn set_rank(&mut self, idx: usize, rank: u8) {
        let old = self.rank[idx];
        self.rank[idx] = rank;
        self.count_sum = self.count_sum - old as u64 + rank as u64;
    }

    #[inline(always)]
    pub fn get_rank(&self, idx: usize) -> u8 {
        self.rank[idx]
    }

    #[inline(always)]
    pub fn decrement_rank(&mut self, idx: usize) {
        if self.rank[idx] > 0 {
            self.rank[idx] -= 1;
            self.count_sum -= 1;
        }
    }

    #[inline(always)]
    pub fn count_sum(&self) -> u64 {
        self.count_sum
    }

    #[inline(always)]
    pub fn cursor(&self) -> usize {
        self.cursor
    }

    #[inline(always)]
    pub fn advance_cursor(&mut self) {
        self.cursor = (self.cursor + 1) % self.capacity;
    }

    pub fn clear(&mut self) {
        self.free_list = (0..self.capacity).collect();
        self.rank.fill(0);
        self.cursor = 0;
        self.count_sum = 0;
    }
}
