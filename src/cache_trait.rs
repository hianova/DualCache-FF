pub trait ConcurrentCache<K, V> {
    fn get(&self, key: &K) -> Option<V>;
    fn put(&self, key: K, value: V);
}
