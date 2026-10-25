koba-e964's dotfiles

# Install
```
./install.sh
```

# Python environments

| Purpose | Definition | Environment | Setup / execution |
| --- | --- | --- | --- |
| Repository development | Root `pyproject.toml`, `uv.lock`, `.python-version` | `.venv` | `uv sync`, `uv run python script.py` |
| Personal tools and libraries | `python/local/{pyproject.toml,uv.lock,.python-version}` | `~/local_python` | `./install-local-python.sh`, then `python script.py` in a new shell |
| PyPy scripts | `home/home.nix`, `flake.lock` | Home Manager user profile | `pypy3 script.py` |

The personal environment uses CPython 3.14. Its installer uses uv to obtain the
interpreter and synchronize its own lockfile, independently of the repository's
`.venv` and any currently activated environment. To add a personal dependency:

```sh
uv add --project python/local --no-sync PACKAGE
./install-local-python.sh
```

New zsh sessions activate `~/local_python` only if no virtual environment or Nix
shell is already active. VS Code defaults to its interpreter; an interpreter
already selected for a workspace can be changed with **Python: Select Interpreter**.

# PyPy (macOS)

PyPy is installed globally for the user by Home Manager. From any directory:

```sh
pypy3 xxx.py
```

The regular `python` command continues to use CPython.

The interpreter is pinned by `flake.lock`. The current pin provides PyPy 7.3.20
(Python 3.11 compatible) for Apple Silicon. This environment is separate from
`~/local_python`; it does not install dependencies from the root `pyproject.toml`
or the personal CPython project in `python/local/`.

Use scripts and dependencies compatible with Python 3.11. CPython extension
modules may need PyPy-specific builds and do not necessarily benefit from its JIT.
