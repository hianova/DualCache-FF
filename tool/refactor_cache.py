import re

def refactor_cache():
    with open('src/cache.rs', 'r') as f:
        content = f.read()

    # Imports
    content = content.replace('use crate::tls::{TlsProvider, DefaultTls};', 'use crate::components::{DefaultTls, DefaultSpawner};')
    content = content.replace('use crate::spawner::{DaemonSpawner, DefaultSpawner};', '')

    # Struct Definition
    content = content.replace('pub struct DualCacheFF<K, V, S = RandomState, Tls: TlsProvider = DefaultTls> {', 'pub struct DualCacheFF<K, V, S = RandomState> {')
    content = content.replace('pub tls: Tls,', 'pub tls: DefaultTls,')

    # Clone impl
    content = content.replace('impl<K, V, S: Clone, Tls: TlsProvider + Clone> Clone for DualCacheFF<K, V, S, Tls> {', 'impl<K, V, S: Clone> Clone for DualCacheFF<K, V, S> {')

    # DualCacheFF<K, V, RandomState, DefaultTls>
    content = content.replace('DualCacheFF<K, V, RandomState, DefaultTls>', 'DualCacheFF<K, V, RandomState>')
    
    # DualCacheFF<K, V, S, Tls>
    content = content.replace('DualCacheFF<K, V, S, Tls>', 'DualCacheFF<K, V, S>')
    
    # impl<K, V, Tls> DualCacheFF<K, V, RandomState, Tls> ...
    content = re.sub(r'impl<K, V, Tls> DualCacheFF<K, V, RandomState, Tls>\s*where\s*K: Hash \+ Eq \+ Send \+ Sync \+ Clone \+ \'static,\s*V: Send \+ Sync \+ Clone \+ \'static,\s*Tls: TlsProvider \+ \'static,', 
                     r'''impl<K, V> DualCacheFF<K, V, RandomState>
where
    K: Hash + Eq + Send + Sync + Clone + 'static,
    V: Send + Sync + Clone + 'static,''', content)

    # impl<K, V, S, Tls: TlsProvider> ...
    content = content.replace('impl<K, V, S, Tls: TlsProvider> DualCacheFF<K, V, S, Tls>', 'impl<K, V, S> DualCacheFF<K, V, S>')
    content = content.replace('impl<K, V, S, Tls: TlsProvider> Drop for DualCacheFF<K, V, S, Tls>', 'impl<K, V, S> Drop for DualCacheFF<K, V, S>')

    # ColdStartSession
    content = content.replace('pub struct ColdStartSession<\'a, K, V, S, Tls: TlsProvider> {', 'pub struct ColdStartSession<\'a, K, V, S> {')
    content = content.replace('impl<\'a, K, V, S, Tls: TlsProvider> ColdStartSession<\'a, K, V, S, Tls>', 'impl<\'a, K, V, S> ColdStartSession<\'a, K, V, S>')
    content = content.replace('ColdStartSession<\'_, K, V, S, Tls>', 'ColdStartSession<\'_, K, V, S>')
    
    # pub fn new_with_tls(config: Config, tls: Tls)
    content = content.replace('pub fn new_with_tls(config: Config, tls: Tls)', 'pub fn new_with_tls(config: Config, tls: DefaultTls)')
    
    # new_headless_with_tls
    content = re.sub(r'pub fn new_headless_with_tls\s*\(\s*config: Config,\s*tls: Tls,\s*\)', r'pub fn new_headless_with_tls(config: Config, tls: DefaultTls)', content)

    # new_with_spawner
    content = re.sub(r'pub fn new_with_spawner<Sp: DaemonSpawner \+ \'static>\(config: Config, spawner: Sp\)', r'pub fn new_with_spawner(config: Config, spawner: DefaultSpawner)', content)

    # new_with_tls_and_spawner
    content = re.sub(r'pub fn new_with_tls_and_spawner<Sp: DaemonSpawner \+ \'static>\(config: Config, tls: Tls, spawner: Sp\)', r'pub fn new_with_tls_and_spawner(config: Config, tls: DefaultTls, spawner: DefaultSpawner)', content)

    # with_hit_buf
    content = content.replace('fn with_hit_buf<F, R>(&self, mut f: F) -> Option<R>\n    where\n        F: FnMut(&mut ([usize; 64], usize)) -> R,', 'fn with_hit_buf<F, R>(&self, f: F) -> Option<R>\n    where\n        F: FnOnce(&mut ([usize; 64], usize)) -> R,')
    content = content.replace('self.tls.with_hit_buf(&mut |buf| {\n            res = Some(f(buf));\n        });', 'res = Some(self.tls.with_hit_buf(f));')

    # with_l1_filter
    content = content.replace('fn with_l1_filter<F, R>(&self, mut f: F) -> Option<R>\n    where\n        F: FnMut(&mut ([u8; 4096], usize)) -> R,', 'fn with_l1_filter<F, R>(&self, f: F) -> Option<R>\n    where\n        F: FnOnce(&mut ([u8; 4096], usize)) -> R,')
    content = content.replace('self.tls.with_l1_filter(&mut |filter| {\n            res = Some(f(filter));\n        });', 'res = Some(self.tls.with_l1_filter(f));')

    # with_last_flush_tick
    content = content.replace('fn with_last_flush_tick<F, R>(&self, mut f: F) -> Option<R>\n    where\n        F: FnMut(&mut TickType) -> R,', 'fn with_last_flush_tick<F, R>(&self, f: F) -> Option<R>\n    where\n        F: FnOnce(&mut TickType) -> R,')
    content = content.replace('self.tls.with_last_flush_tick(&mut |tick| {\n            res = Some(f(tick));\n        });', 'res = Some(self.tls.with_last_flush_tick(f));')

    # warmup_state
    content = content.replace('self.tls.with_warmup_state(&mut |s| *s = s.saturating_add(10));', 'self.tls.with_warmup_state(|s| *s = s.saturating_add(10));')
    content = content.replace('self.tls.with_warmup_state(&mut |s| *s = s.saturating_sub(10));', 'self.tls.with_warmup_state(|s| *s = s.saturating_sub(10));')
    content = content.replace('self.tls.with_warmup_state(&mut |s| warmup_state = *s);', 'self.tls.with_warmup_state(|s| warmup_state = *s);')


    with open('src/cache.rs', 'w') as f:
        f.write(content)

if __name__ == '__main__':
    refactor_cache()
