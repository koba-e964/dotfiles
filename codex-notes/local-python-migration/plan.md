# Plan: Manage `~/local_python` consistently from dotfiles

## Overview
Integrate `~/local_python` management into this repo by replacing the ad-hoc installer with tracked requirements and an idempotent sync script, then wire it into the main bootstrap flow and make shell activation safe when the environment is absent.

## Files to change
- `tentative-install-python.sh`
- `install.sh`
- `home/zsh/default.nix`
- `todo.txt`
- `python/requirements-local_python.txt` (new)

## Detailed implementation steps
1. Add `python/requirements-local_python.txt` with pinned packages currently installed in `tentative-install-python.sh`.
   - Include hashes for all locked artifacts (similar integrity guarantees to `uv.lock`).
   - Exact method:
     - Use `pip hash` against the chosen distribution files and write entries as:
       - `package==X.Y.Z --hash=sha384:...`
       - add multiple `--hash` values if multiple allowed artifacts are needed.
     - Install with `python -m pip install --require-hashes -r python/requirements-local_python.txt`.
     - `pip hash` supports `sha384`, and pip fails closed on hash mismatch.
2. Rewrite `tentative-install-python.sh` into an idempotent manager script:
   - Note: It would be no longer "tentative": rename it.
   - Ensure `~/local_python` exists (`python3 -m venv` when missing).
   - Use `~/local_python/bin/python -m pip` for all installs so host `pip3` is never used directly.
   - Upgrade pip to the pinned version inside that venv.
   - Install packages from the tracked requirements file with `--require-hashes`.
   - Exit non-zero on failures (`set -eu`) so bootstrap fails fast instead of leaving partial state.
3. Call `./tentative-install-python.sh` from `install.sh` so local Python setup is part of standard dotfiles bootstrap.
4. Update `home/zsh/default.nix` to activate `~/local_python` only when `bin/activate` exists.
5. Mark the matching `todo.txt` item as done (or remove that item).

## Non-goals
- Do not migrate `~/local_python` tooling into Nix packages in this change.
- Do not change VS Code settings unless Python major/minor version handling is explicitly requested.
- Do not rename `tentative-install-python.sh` in this change (keep scope limited).

## Alternatives considered
- Move all Python tooling to Nix packages only.
  - Rejected for now because current workflow and VS Code settings already depend on `~/local_python`.
- Keep ad-hoc `pip3 install` without integration into `install.sh`.
  - Rejected because it does not solve partial management/reproducibility.

## Risks
- Network/package index failures during bootstrap can fail setup.
- If system Python changes major/minor version, VS Code extra path may need adjustment.
- Creating a venv with a different Python minor version could mismatch hard-coded editor paths.
- Hash-locked requirements require hash updates when versions are intentionally changed.

## Test strategy
- Run shell syntax check for changed scripts (`sh -n install.sh tentative-install-python.sh`).
- Execute `./tentative-install-python.sh` once and confirm:
  - `~/local_python/bin/activate` exists.
  - `~/local_python/bin/python -m pip show ruff` and `podman-compose` succeed.
  - Hash enforcement is active (intentional hash mismatch should fail, then restore).
- Open a new shell and confirm startup succeeds both when `~/local_python` exists and when activation file is absent.
- Confirm Home Manager module still evaluates syntactically by ensuring no Nix syntax regression in modified block.

## Assumptions
- Python 3 is available during bootstrap (already installed by `install.sh`).
- Keeping `~/local_python` as the target location is desired.

## Open questions
- None blocking for initial implementation. The hash-locking request is feasible with pip `--require-hashes` and per-line `--hash=sha384:...`.

## Implementation Checklist
- [ ] Add tracked requirements file for `~/local_python` packages.
- [ ] Add hashes to locked requirements and enforce `--require-hashes`.
- [ ] Make `tentative-install-python.sh` idempotent and requirements-driven.
- [ ] Invoke local Python sync in `install.sh`.
- [ ] Guard zsh activation to avoid startup failures on fresh machines.
- [ ] Update `todo.txt` to reflect completion.
