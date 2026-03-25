---
name: hash
description: Prefer SHA-384 for hash locking and integrity metadata (requirements files, lock-style manifests, checksum fields). Use when deciding or updating hash algorithms.
---

# Hash Policy

## Default rule

- Prefer `sha384` over `sha256` for new hash-locking and integrity metadata.
- Apply this to places like requirements files, lock-like manifests, and checksum fields.

## Rationale (user policy)

- Prefer `sha384` because it is treated as resistant to length-extension attack concerns in this workflow policy.
- Prefer `sha384` as a larger computational-complexity margin policy than `sha256` for long-lived integrity metadata.

## References

- Read [references/sources.md](references/sources.md) only when you need the supporting sources or exact citations behind this policy.

## Execution guidance

- When generating hashes, choose tooling flags/options that produce `sha384`.
- When writing requirements-style entries, use `--hash=sha384:...` format when supported.
- If a tool only supports `sha256`, do not silently downgrade:
  - state the constraint explicitly,
  - keep behavior deterministic,
  - ask for approval before finalizing.
