fn main() {
    let (tx, rx) = loom::sync::mpsc::sync_channel::<i32>(1);
}
