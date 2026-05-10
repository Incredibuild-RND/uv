/// Return the application version.
///
/// This should be in sync with uv's version based on the Crate version.
//
// CI note: this file is intentionally touched on the
// Incredibuild-RND/uv fork to flip `any_rust_changed=1` in the CI
// plan step, which unblocks the bench workflow so we can validate
// ib_console acceleration on cargo-run benchmarks. Safe to drop on
// the next upstream sync.
pub fn version() -> &'static str {
    env!("CARGO_PKG_VERSION")
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_get_version() {
        assert_eq!(version().to_string(), env!("CARGO_PKG_VERSION").to_string());
    }
}
