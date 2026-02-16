# Research: Manage `~/local_python` in dotfiles

## Relevant files
- `home/zsh/default.nix`
- `tentative-install-python.sh`
- `install.sh`
- `vscode/Library/Application Support/Code/User/settings.json`
- `todo.txt`

## Current behavior
- Shell startup unconditionally runs `source $HOME/local_python/bin/activate` in `home/zsh/default.nix`.
- Python package installation for that environment is handled outside the main setup flow by `tentative-install-python.sh`.
- `tentative-install-python.sh` installs directly via `pip3 install ...` and does not ensure the target virtualenv exists.
- `install.sh` does not create or synchronize `~/local_python`.
- VS Code points `python.analysis.extraPaths` to `~/local_python/lib/python3.12/site-packages`.

## Gaps / risks
- Partial management: shell assumes environment exists, but setup does not guarantee it.
- Reproducibility risk: package versions are pinned in an ad-hoc script not integrated into standard install flow.
- Bootstrap fragility: fresh machine can fail at shell startup if `~/local_python` is missing.
- Drift risk: manual `pip3 install` can diverge from tracked state.

## Existing conventions
- Bootstrap logic is centralized in `install.sh`.
- User environment is managed via Home Manager (`home/home.nix`, module imports under `home/`).
- Repo already tracks operational TODO in `todo.txt`; this Python item is listed there.

## Constraints
- Keep change scope to one logical change (workflow guardrail).
- Avoid destructive operations in user home.
- Maintain compatibility with existing VS Code path that expects Python 3.12 site-packages in `~/local_python`.

## Unknowns
- Whether user wants this environment managed by Nix packages instead of pip. Current repo intent suggests continuing with `~/local_python` but managing it consistently via dotfiles.
