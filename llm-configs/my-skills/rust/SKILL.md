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

## API design

- Prefer concrete borrowed string parameters like `&str` over polymorphic `impl Into<String>`.
- Use `impl Into<String>` only when there is a concrete ergonomic or ownership reason that justifies monomorphization cost.

## Validation

- Use `pre-commit` for Rust repositories.
- Add Rust pre-commit hooks for:
  - `cargo fmt --check`
  - `cargo clippy --all-targets --all-features -- -D warnings`
- After dependency or manifest changes, run:
  - `cargo fmt --check`
  - `cargo test`
  - `cargo clippy --all-targets --all-features -- -D warnings`
- Use `cargo tree -e features` when deciding whether features can be reduced.
