use crossbeam_epoch::Atomic;
use std::sync::atomic::AtomicU64;

pub struct Node<K, V> {
    pub key: K,
    pub value: V,
    pub expire_at: u32,
}

pub struct T1<K, V> {
    pub mask: usize,
    pub slots: Box<[Atomic<Node<K, V>>]>,
}

impl<K, V> T1<K, V> {
    pub fn new(slots_count: usize) -> Self {
        let mut slots = Vec::with_capacity(slots_count);
        for _ in 0..slots_count {
            slots.push(Atomic::null());
        }
        Self {
            mask: slots_count - 1,
            slots: slots.into_boxed_slice(),
        }
    }
}

pub struct T2<K, V> {
    pub mask: usize,
    pub slots: Box<[Atomic<Node<K, V>>]>,
}

impl<K, V> T2<K, V> {
    pub fn new(slots_count: usize) -> Self {
        let mut slots = Vec::with_capacity(slots_count);
        for _ in 0..slots_count {
            slots.push(Atomic::null());
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
    pub nodes: Box<[Atomic<Node<K, V>>]>,
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
            nodes.push(Atomic::null());
        }

        Self {
            index_mask: index_size - 1,
            index: index.into_boxed_slice(),
            nodes: nodes.into_boxed_slice(),
        }
    }
}
