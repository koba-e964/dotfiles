# Global Agent Instructions

## Git And Validation

- Always use `pre-commit` for repositories you edit.
- If a repository has `.pre-commit-config.yaml`, run `pre-commit install` so checks run from `git commit`.
- If a repository does not have `.pre-commit-config.yaml`, add a focused one unless the user explicitly asks not to.
- When adding pre-commit hooks, keep them fast and focused.
- Pin third-party hook repositories to commit hashes, with a tag comment when known.
