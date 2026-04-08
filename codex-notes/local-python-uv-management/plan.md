# Plan: Manage `~/local_python` with `uv` dependency groups

## Overview

Replace the separate `pip` requirements flow for `~/local_python` with a `uv`-managed `local` dependency group in `pyproject.toml`, then update the bootstrap script to create and synchronize `~/local_python` from that group while preserving the existing target path and Python version checks.

## Files to change

- `pyproject.toml`
- `uv.lock`
- `install-local-python.sh`
- `python/requirements-local_python.txt`
- `codex-notes/local-python-uv-management/plan.md`

## Detailed implementation steps

1. Add a `local` dependency group to `pyproject.toml`.
   - Move the packages currently listed in `python/requirements-local_python.txt` into `[dependency-groups].local`.
   - Keep versions pinned exactly to the currently locked versions so the migration changes the manager, not the package set.
   - Leave the existing `dev` group intact.

2. Regenerate `uv.lock` so it includes the new `local` group.
   - Use the repo's existing `uv` workflow so the lockfile becomes the single source of truth for both repo tooling and `~/local_python`.
   - Verify that the locked versions for the migrated packages match the existing pinned versions unless `uv` forces a conflict resolution.

3. Rewrite `install-local-python.sh` to use `uv` instead of direct `pip` installs.
   - Keep the current interpreter discovery and version validation based on `.python-version`.
   - Keep the logic that recreates `~/local_python` when the Python minor version changes.
   - Replace `ensurepip` and `pip install --requirement` with a `uv` command that installs the `local` dependency group into `~/local_python`.
   - Ensure the script explicitly targets `~/local_python` and does not sync the repo's default `.venv`.
   - Keep the script idempotent.

4. Remove the old requirements file after migration.
   - Delete `python/requirements-local_python.txt` once `pyproject.toml` and `uv.lock` fully replace it.
   - Avoid keeping dual dependency sources.

5. Verify bootstrap compatibility.
   - Confirm `install.sh` does not need behavior changes beyond continuing to call `./install-local-python.sh`.
   - Confirm shell activation behavior in `home/zsh/default.nix` remains valid with the `uv`-managed environment layout.

## Alternatives considered

Keep `python/requirements-local_python.txt` and teach `uv` to consume it.
- Rejected because it preserves two sources of truth and does not align with the user's request to manage this through `pyproject.toml`.

Use `[tool.uv]` custom metadata or a nonstandard `[local]` table instead of a dependency group.
- Rejected because dependency groups are the standard place for installable package sets, while a custom section would still require bespoke parsing in the bootstrap script.

Move `~/local_python` packages into the base project dependencies.
- Rejected because those packages are user-environment tooling, not required to develop this repo.

## Risks

- `uv` may not provide a single direct equivalent to `pip install -r` for an external venv; the script must use a command shape that explicitly targets `~/local_python`.
- Locking these packages into `uv.lock` may introduce transitive differences versus the current hash-locked requirements file.
- Some packages may not resolve cleanly on Python `3.14`; if that happens, the migration may require a version adjustment or a narrower Python constraint.
- Deleting the requirements file removes a fallback path, so the `uv` flow must be verified before cleanup is finalized.

## Test strategy

- Run `uv lock` and confirm it completes successfully.
- Run `sh -n install-local-python.sh install.sh`.
- Run `./install-local-python.sh`.
- Verify:
  - `~/local_python/bin/python` exists.
  - `~/local_python/bin/python --version` matches `.python-version`.
  - Representative commands such as `~/local_python/bin/python -m pip show ruff` and `~/local_python/bin/python -m pip show podman-compose` still succeed after sync.
- Confirm repo `.venv` is not created or modified unintentionally by the local Python sync script.

## Assumptions

- The user wants `~/local_python` to remain a separate environment outside the repo root.
- A `local` dependency group in `pyproject.toml` is the intended interpretation of the requested "`local` section".
- `uv` is installed during bootstrap and is available when `install-local-python.sh` runs.
- It is acceptable for `uv.lock` to track user-local tooling dependencies in this repo.

## Open questions

- Which `uv` command shape is the most reliable for syncing an external venv at `~/local_python` without touching `.venv`?
- Whether any packages in the current local environment set should remain outside repo-tracked dependency management.

## Implementation Checklist

- [x] Add a pinned `local` dependency group to `pyproject.toml`.
- [x] Regenerate `uv.lock` to include the `local` group.
- [x] Rewrite `install-local-python.sh` to create and sync `~/local_python` with `uv`.
- [x] Remove `python/requirements-local_python.txt`.
- [x] Run syntax and bootstrap verification commands.
