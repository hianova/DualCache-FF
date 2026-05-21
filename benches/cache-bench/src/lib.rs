use std::hash::Hash;

pub trait Cache<K, V>: Send + Sync {
    fn get(&self, key: &K) -> Option<V>;
    fn insert(&self, key: K, value: V);
    fn sync(&self);
    fn name(&self) -> &'static str;
}

// 为 Moka 实现该 trait
impl<K, V> Cache<K, V> for moka::sync::Cache<K, V>
where
    K: Eq + Hash + Send + Sync + 'static,
    V: Clone + Send + Sync + 'static,
{
    fn get(&self, key: &K) -> Option<V> {
        self.get(key)
    }

    fn insert(&self, key: K, value: V) {
        self.insert(key, value);
    }

    fn sync(&self) {
        self.run_pending_tasks();
    }

    fn name(&self) -> &'static str {
        "Moka"
    }
}

use dualcache_ff::DualCacheFF;

impl<K, V> Cache<K, V> for DualCacheFF<K, V>
where
    K: Eq + Hash + Clone + Send + Sync + 'static,
    V: Clone + Send + Sync + 'static,
{
    fn get(&self, key: &K) -> Option<V> {
        self.get(key)
    }

    fn insert(&self, key: K, value: V) {
        DualCacheFF::insert(self, key, value);
    }

    fn sync(&self) {
        DualCacheFF::sync(self);
    }

    fn name(&self) -> &'static str {
        "DualCacheFF"
    }
}

use tinyufo::TinyUfo;

impl<K, V> Cache<K, V> for TinyUfo<K, V>
where
    K: Eq + Hash + Clone + Send + Sync + 'static,
    V: Clone + Send + Sync + 'static,
{
    fn get(&self, key: &K) -> Option<V> {
        self.get(key)
    }

    fn insert(&self, key: K, value: V) {
        self.put(key, value, 1);
    }

    fn sync(&self) {}

    fn name(&self) -> &'static str {
        "TinyUFO"
    }
}
