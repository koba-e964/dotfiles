---
name: pre-commit-go
description: Configure or update pre-commit for Go repos, including repo-pinned hooks for gofmt/staticcheck and brief README setup notes. Use when adding or switching to pre-commit hooks in Go projects.
---

# Pre-Commit Go

## Overview

Add or update `.pre-commit-config.yaml` for Go projects using repo-based hooks pinned to exact commit SHAs, with version comments for traceability.

## Workflow

1. Pick hook repo(s). Prefer `https://github.com/TekWizely/pre-commit-golang` for Go tooling.
2. Select hook IDs:
   - `go-fmt` (add `args: ["-w"]` if auto-fixing is desired)
   - `go-staticcheck-repo-mod` for `staticcheck ./...` per module
3. Lock versions by setting `rev` to a commit SHA and add an inline `# frozen: vX.Y.Z` tag comment.
4. Keep README setup minimal:
   - `pre-commit install`
   - `pre-commit run --all-files`
5. Run `pre-commit run --all-files` to verify hooks.

## Notes

- Pre-commit has no separate lock file; version pinning happens in `.pre-commit-config.yaml` via `rev`.
- Prefer repo-based hooks over local hooks; they avoid relying on locally installed binaries and make CI reproducible.

## Example

```yaml
repos:
  - repo: https://github.com/TekWizely/pre-commit-golang
    rev: <commit-sha>  # frozen: vX.Y.Z
    hooks:
      - id: go-fmt
        args: ["-w"]
      - id: go-staticcheck-repo-mod
```
