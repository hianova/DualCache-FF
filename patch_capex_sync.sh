sed -i '' 's/cache.insert(key, key);/cache.insert_sync(key, key);/g' benches/capex.rs
