---
name: rust
description: Apply Rust project conventions when editing Cargo.toml, Rust dependencies, crates, binaries, libraries, tests, or Lambda/server binaries written in Rust.
---

# Rust Policy

## Cargo package metadata

- Set `publish = false` in `Cargo.toml` unless there is a specific reason the crate should be published.
- Keep `edition` current when the configured toolchain supports it.

## Dependency hygiene

- Prefer the latest compatible crate versions.
- If a crate is intentionally not latest, add a concise comment or note explaining why.
- Prefer warning-free version requirements:
  - Do not include semver build metadata in Cargo dependency requirements because Cargo ignores it and warns.
  - Use `Cargo.lock` to record the exact resolved artifact, including build metadata when present.
- Minimize transitive dependencies:
  - Use `default-features = false` by default.
  - Enable only the features the code actually needs.
  - If default features are kept, add a concise comment or note explaining why.

## Validation

- Use `pre-commit` when the repository has `.pre-commit-config.yaml`.
- Prefer adding fast Rust checks, especially `cargo fmt --check`, to pre-commit so they run before commits.
- After dependency or manifest changes, run:
  - `pre-commit run --all-files`
  - `cargo fmt --check`
  - `cargo test`
  - `cargo clippy --all-targets --all-features -- -D warnings`
- Use `cargo tree -e features` when deciding whether features can be reduced.
