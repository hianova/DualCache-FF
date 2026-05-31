extern crate alloc;
use super::DaemonSpawner;

/// A default spawner using `std::thread::spawn` for `std` environments.
#[derive(Debug, Clone, Copy, Default)]
pub struct DefaultSpawner;

impl DaemonSpawner for DefaultSpawner {
    #[inline]
    fn spawn(&self, f: alloc::boxed::Box<dyn FnOnce() + Send + 'static>) {
        std::thread::spawn(move || f());
    }
}
