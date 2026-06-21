# Global Agent Instructions

## Git And Validation

- Use `pre-commit` in repositories that provide `.pre-commit-config.yaml`.
- Before committing, run `pre-commit run --all-files` and fix failures unless the user explicitly asks to skip it.
- When adding pre-commit hooks, keep them fast and focused.
- Pin third-party hook repositories to commit hashes, with a tag comment when known.
