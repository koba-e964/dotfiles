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

## Sources

- NIST SP 800-224 (Initial Public Draft), Section 6.3.1:
  - States that HMAC was designed for hash functions subject to length-extension attacks, and that outer hashing prevents such HMAC forgeries.
  - https://csrc.nist.gov/pubs/sp/800/224/ipd
  - DOI/PDF: https://doi.org/10.6028/NIST.SP.800-224.ipd
- PyCryptodome documentation (explicit algorithm notes):
  - SHA-384 page states it is not vulnerable to length-extension attacks.
  - SHA-512 page states it is vulnerable to length-extension attacks and recommends SHA-512/224 or SHA-512/256 for that property.
  - https://www.pycryptodome.org/src/hash/sha384
  - https://www.pycryptodome.org/src/hash/sha512
- hash_extender (reference implementation/tooling note):
  - Documents practical support for length-extension vulnerable hashes and explicitly notes SHA-224/SHA-384 are not vulnerable.
  - https://github.com/iagox86/hash_extender
- NIST Hash Functions project (security-strength table):
  - Shows SHA-256 collision strength = 128 bits, SHA-384 collision strength = 192 bits.
  - https://csrc.nist.gov/Projects/hash-functions
- NIST SP 800-57 Part 1 Rev. 5 (primary source):
  - Section 5.6.3 / Table 4: through 2030 minimum is 112 bits; from 2031 and beyond minimum is 128 bits.
  - This supports "128-bit is required/acceptable," not "128-bit is deprecated."
  - Landing page: https://csrc.nist.gov/pubs/sp/800/57/pt1/r5/final
  - DOI/PDF: https://doi.org/10.6028/NIST.SP.800-57pt1r5

## Execution guidance

- When generating hashes, choose tooling flags/options that produce `sha384`.
- When writing requirements-style entries, use `--hash=sha384:...` format when supported.
- If a tool only supports `sha256`, do not silently downgrade:
  - state the constraint explicitly,
  - keep behavior deterministic,
  - ask for approval before finalizing.
