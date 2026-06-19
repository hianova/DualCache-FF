use std::time::Duration;
use std::thread;

pub fn run_with_timeout<F, T>(timeout: Duration, f: F) -> T
where
    F: FnOnce() -> T + Send + 'static,
    T: Send + 'static,
{
    let _guard = crate::TEST_LOCK.lock().unwrap();
    let (tx, rx) = std::sync::mpsc::channel();
    let handle = thread::spawn(move || {
        let res = f();
        let _ = tx.send(res);
    });
    match rx.recv_timeout(timeout) {
        Ok(res) => {
            let _ = handle.join();
            res
        },
        Err(_) => {
            panic!("Test timed out after {:?}", timeout);
        }
    }
}
