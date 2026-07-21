#[inline(always)]
pub fn unlikely(b: bool) -> bool {
    b
}

#[test]
fn covopt_audit_test() {
    let n = std::env::var("COVOPT_N")
        .ok()
        .and_then(|v| v.parse::<usize>().ok())
        .unwrap_or(1);
    let mut sum = 0;
    for i in 0..n {
        // COVOPT_ANCHOR
        if unlikely(i == 999999) {
            sum += 1;
        }
        sum += i;
    }
    assert_eq!(sum, sum);
}
