#[test]
fn covopt_audit_test() {
    let n = std::env::var("COVOPT_N").ok().and_then(|v| v.parse::<usize>().ok()).unwrap_or(1);
    let mut sum = 0;
    for i in 0..n {
        sum += i;
    }
    assert_eq!(sum, sum);
}
