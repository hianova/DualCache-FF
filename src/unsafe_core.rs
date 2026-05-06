use parking_lot::RwLock;
use std::sync::atomic::{AtomicUsize, AtomicU64};

pub struct Node<K, V> {
    pub key: K,
    pub value: V,
    pub expire_at: u32,
}

pub struct T1 {
    pub mask: usize,
    pub slots: Box<[AtomicUsize]>,
}

impl T1 {
    pub fn new(slots_count: usize) -> Self {
        let mut slots = Vec::with_capacity(slots_count);
        for _ in 0..slots_count {
            slots.push(AtomicUsize::new(usize::MAX));
        }
        Self {
            mask: slots_count - 1,
            slots: slots.into_boxed_slice(),
        }
    }
}

pub struct T2 {
    pub mask: usize,
    pub slots: Box<[AtomicUsize]>,
}

impl T2 {
    pub fn new(slots_count: usize) -> Self {
        let mut slots = Vec::with_capacity(slots_count);
        for _ in 0..slots_count {
            slots.push(AtomicUsize::new(usize::MAX));
        }
        Self {
            mask: slots_count - 1,
            slots: slots.into_boxed_slice(),
        }
    }
}

pub struct L3<K, V> {
    pub index_mask: usize,
    pub index: Box<[AtomicU64]>,
    pub nodes: Box<[RwLock<Option<Node<K, V>>>]>,
}

impl<K, V> L3<K, V> {
    pub fn new(capacity: usize) -> Self {
        let index_size = (capacity * 2).next_power_of_two();
        let mut index = Vec::with_capacity(index_size);
        for _ in 0..index_size {
            index.push(AtomicU64::new(0));
        }

        let mut nodes = Vec::with_capacity(capacity);
        for _ in 0..capacity {
            nodes.push(RwLock::new(None));
        }

        Self {
            index_mask: index_size - 1,
            index: index.into_boxed_slice(),
            nodes: nodes.into_boxed_slice(),
        }
    }
}
