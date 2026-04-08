# Research: Manage `~/local_python` with `uv`

## Relevant files

- `pyproject.toml`
- `uv.lock`
- `install-local-python.sh`
- `install.sh`
- `home/zsh/default.nix`
- `python/requirements-local_python.txt`
- `codex-notes/local-python-migration/research.md`
- `codex-notes/local-python-migration/plan.md`

## Current behavior

- Repo-level Python tooling is already managed by `uv` through `pyproject.toml` and `uv.lock`.
- `pyproject.toml` currently defines only the empty base project dependencies and a `dev` dependency group.
- `install-local-python.sh` manages `~/local_python` separately from the repo's `uv` environment.
- That script currently:
  - requires `python${.python-version}` to exist
  - creates `~/local_python` with `venv`
  - recreates the venv when the interpreter minor version changes
  - bootstraps `pip`
  - installs packages from `python/requirements-local_python.txt`
- `install.sh` invokes `./install-local-python.sh` on macOS during bootstrap.
- Shell startup only activates `~/local_python` when `~/local_python/bin/activate` exists, so missing env does not currently break startup.

## Existing dependency source

- `python/requirements-local_python.txt` is the source of truth for the `~/local_python` package set today.
- It is fully pinned and hash-locked.
- It includes packages intended for the user's personal `~/local_python` virtualenv, not the repo's development tooling.

## Execution flow

1. `install.sh` installs `uv` and Python via Homebrew on macOS.
2. `install.sh` runs `./install-local-python.sh`.
3. `install-local-python.sh` ensures the target interpreter version matches `.python-version`.
4. `install-local-python.sh` creates or recreates `~/local_python`.
5. `install-local-python.sh` installs packages into that environment from the requirements file.
6. New interactive shells source `~/local_python/bin/activate` if present.

## Constraints and invariants

- `~/local_python` must remain the target environment location unless the user explicitly asks to move it.
- The environment should continue to use the interpreter version from `.python-version` (`3.14` at the time of research).
- Bootstrap should remain idempotent.
- The repo already depends on `uv`, so reusing it is preferred over introducing another manager.
- The change should stay scoped to local Python environment management; unrelated repo Python tooling should not be reworked.

## Architectural patterns

- Repo-managed Python dependencies live in `pyproject.toml` / `uv.lock`.
- Bootstrap logic is kept in shell scripts at repo root.
- Environment-specific package installs for the user have historically been separated from repo dev dependencies.

## Naming and config conventions

- Dependency groups are declared under `[dependency-groups]` in `pyproject.toml`.
- Local environment bootstrap scripts use explicit environment variables such as `VENV_DIR`, `PYTHON_BIN`, and `REQUIRED_PYTHON`.
- Repo notes are stored under task-scoped directories in `codex-notes/`.

## Potential migration shape

- The user's mention of a "`local` section in `pyproject.toml`" aligns with adding a `local` dependency group.
- If that approach is used, `uv.lock` becomes the lock source for both repo dev dependencies and `~/local_python` dependencies.
- `install-local-python.sh` would need to switch from `pip install --requirement` to a `uv`-based sync/install flow that targets `~/local_python`.

## Risks and pitfalls

- Mixing personal `~/local_python` dependencies into the repo lockfile changes the meaning and lifecycle of `uv.lock`.
- `uv sync` defaults to the project environment, so the script must explicitly target `~/local_python` and avoid mutating `.venv`.
- If the selected `uv` command implicitly installs `dev` dependencies too, `~/local_python` could pick up unintended packages.
- The existing hash-locked requirements file and the `uv.lock` model are different lock mechanisms; keeping both would create dual sources of truth.
- `.python-version` is `3.14`, while editor settings still reference a `3.12` site-packages path in one VS Code settings file. That mismatch predates this change and may remain unless specifically addressed.

## Unknowns

- Whether the user wants `python/requirements-local_python.txt` removed entirely or kept as a generated artifact.
- Whether the `local` dependency group should be excluded from CI/dev sync by default.
- Which exact `uv` command shape is preferred for syncing an external venv rooted at `~/local_python`.
