#[macro_export]
macro_rules! AI {
    // 暫時什麼都不做，或呼叫 todo! 提示未實作
    () => {
        todo!("AI generation not yet implemented")
    };
    // 如果需要接受參數，也一併定義
    ($($arg:tt)*) => {
        todo!("AI generation not yet implemented")
    };
}
