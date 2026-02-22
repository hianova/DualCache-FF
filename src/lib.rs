use std::mem::MaybeUninit;
use std::thread;
use std::{collections::HashMap, sync::Arc};

use anyhow::Result;
use arc_swap::ArcSwap;
use crossbeam::channel::{self, Receiver, Sender};

pub struct DualCacheFF<K, V, T> {
    main: Paginated<T>,
    mirror: ArcSwap<Paginated<T>>,
    index: HashMap<K, usize>,
    ring_buffer: Vec<Node<K, V>>,
    ring_read: usize,
    ring_write: usize,
    counter_sum: usize,
    evict_point: usize,
    lazy_update: Sender<usize>,
}
pub struct Config {
    capacity: usize,
}

impl<K, V, T> From<Config> for DualCacheFF<K, V, T> {
    fn from(config: Config) -> Self {
        let (tx, rx): (Sender<usize>, Receiver<usize>) = channel::bounded(1000);
        thread::spawn(|| {
            Self::daemon(rx);
        });
        Self {
            main: Paginated {
                pages: Vec::with_capacity(config.capacity),
            },
            mirror: ArcSwap::from_pointee(Paginated {
                pages: Vec::with_capacity(config.capacity),
            }),
            index: HashMap::with_capacity(config.capacity),
            ring_buffer: Vec::with_capacity(config.capacity),
            ring_read: 0,
            ring_write: 0,
            counter_sum: 0,
            evict_point: 0,
            lazy_update: tx,
        }
    }
}
impl<K, V, T> DualCacheFF<K, V, T> {
    pub fn new() -> Self {
        let config = Config { capacity: 10 ^ 7 };
        DualCacheFF::from(config)
    }
    pub fn add(&mut self) -> Result<()> {
        Ok(())
    }
    pub fn get(&mut self) -> Result<()> {
        Ok(())
    }
    fn daemon(rx: Receiver<usize>) {}
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn add() {
        let result = DualCacheFF::<usize, usize, usize>::new().add();
        assert!(result.is_ok());
    }
    #[test]
    fn get() {
        let result = DualCacheFF::<usize, usize, usize>::new().get();
        assert!(result.is_ok());
    }
}

const PAGE_SIZE: usize = 1024;
const SHIFT: usize = 10;
const MASK: usize = 1023;

#[derive(Clone, Debug)]
pub struct Node<K, V> {
    pub key: K,
    pub value: Arc<V>,
    pub counter: u64,
    pub time_stamp: u64,
}
struct Paginated<T> {
    pages: Vec<Arc<Page<T>>>,
}
impl<T: Clone> Clone for Paginated<T> {
    fn clone(&self) -> Self {
        Self {
            pages: self.pages.clone(),
        }
    }
}
struct Page<T> {
    data: [T; PAGE_SIZE],
}
impl<T: Clone> Clone for Page<T> {
    fn clone(&self) -> Self {
        let mut new_page: MaybeUninit<Page<T>> = MaybeUninit::uninit();
        unsafe {
            std::ptr::copy_nonoverlapping(
                &self.data as *const T,
                new_page.as_mut_ptr() as *mut T,
                PAGE_SIZE,
            );
            new_page.assume_init()
        }
    }
}
