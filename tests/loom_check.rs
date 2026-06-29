fn main() {
    let (tx, rx) = loom::sync::mpsc::channel::<i32>();
}
