fn main() {
    cfg_rust_features::emit!([
        "arbitrary_self_types",
        "unstable_features",
    ]).unwrap();
}
