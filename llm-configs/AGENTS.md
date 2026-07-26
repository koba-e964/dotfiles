# Global Agent Instructions

## Git And Validation

- Always use `pre-commit` for repositories you edit.
- If a repository has `.pre-commit-config.yaml`, run `pre-commit install` so checks run from `git commit`.
- If a repository does not have `.pre-commit-config.yaml`, add a focused one unless the user explicitly asks not to.
- When adding pre-commit hooks, keep them fast and focused.
- Pin third-party hook repositories to commit hashes, with a tag comment when known.

## Worktrees And Agent Instructions

- For a repository named `XXX`, create worktrees under `../XXX-worktrees/WORKTREE-NAME/`.
- `AGENTS.md` must be present as a symlink created by `stow`.

## Learning Notes

- Maintain reusable learning notes in the user's learning-notes tree when a conversation produces a durable concept, workflow, rule, implementation pattern, or pitfall.
- Do not hard-code a machine-specific learning-notes path in instructions or generated notes. Locate the tree from the current project instructions, an existing learning-notes root, or an explicit user-provided location.
- Treat each learning-notes topic like a small skill package: use a short kebab-case topic directory, keep `SKILL.md` as an index, and put detailed items in separate files.
- Update learning notes proactively after explaining or researching something reusable, unless the user explicitly asks not to write notes.
