use std::sync::Mutex;

pub static TEST_LOCK: Mutex<()> = Mutex::new(());

pub mod common;

mod it {
    mod concurrent;
    mod coverage;
    mod pressure;
    mod robust;
    mod stability;
    mod static_cache;
    mod test_hash;
    mod unsafe_spec;
    mod miri_core;
}
