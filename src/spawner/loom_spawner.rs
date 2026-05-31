extern crate alloc;
use super::DaemonSpawner;

/// A default spawner using `loom::thread::spawn` for `loom` environments.
#[derive(Debug, Clone, Copy, Default)]
pub struct DefaultSpawner;

impl DaemonSpawner for DefaultSpawner {
    #[inline]
    fn spawn(&self, f: alloc::boxed::Box<dyn FnOnce() + Send + 'static>) {
        loom::thread::spawn(move || f());
    }
}
