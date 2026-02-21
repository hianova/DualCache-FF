use std::collections::HashMap;
use std::thread;

use anyhow::Result;
use crossbeam::channel::{self, Receiver, Sender};

pub struct DualCacheFf<K, V> {
    main: Paginated,
    mirror: Paginated,
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

impl<K, V> From<Config> for DualCacheFf<K, V> {
    fn from(config: Config) -> Self {
        let (tx, rx): (Sender<usize>, Receiver<usize>) = channel::bounded(1000);
        thread::spawn(|| {
            Self::daemon(rx);
        });
        Self {
            main: Paginated {
                pages: Vec::with_capacity(config.capacity),
            },
            mirror: Paginated {
                pages: Vec::with_capacity(config.capacity),
            },
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
impl<K, V> DualCacheFf<K, V> {
    pub fn new() -> Self {
        let config = Config { capacity: 10 ^ 7 };
        DualCacheFf::from(config)
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
        let result = DualCacheFf::<usize, usize>::new().add();
        assert!(result.is_ok());
    }
    #[test]
    fn get() {
        let result = DualCacheFf::<usize, usize>::new().get();
        assert!(result.is_ok());
    }
}

#[derive(Clone, Debug)]
pub struct Node<K, V> {
    pub key: K,
    pub value: V,
    pub counter: u64,
    pub time_stamp: u64,
}
struct Paginated {
    pages: Vec<Page>,
}
struct Page {}
