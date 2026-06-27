sed -i '' 's/cache.insert(key, key);/cache.insert(key, key); std::thread::yield_now();/g' benches/capex.rs
