fn main() {
    let (_tx, _rx) = loom::sync::mpsc::channel::<i32>();
}
