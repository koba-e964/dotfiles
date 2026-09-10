# Global Agent Instructions

## Git And Validation

- Always use `pre-commit` for repositories you edit.
- If a repository has `.pre-commit-config.yaml`, run `pre-commit install` so checks run from `git commit`.
- If a repository does not have `.pre-commit-config.yaml`, add a focused one unless the user explicitly asks not to.
- When adding pre-commit hooks, keep them fast and focused.
- Pin third-party hook repositories to commit hashes, with a tag comment when known.

## Worktrees And Agent Instructions

- When the current task is for a repository-specific file or note, use the current working repository as the default destination. Do not switch to the repository that stores these global instructions unless the user explicitly names it as the target.
- For a repository named `XXX`, create worktrees under `../XXX-worktrees/WORKTREE-NAME/`.
- `~/.codex/AGENTS.md` must be present as a symlink created by `stow`.
- When handling local issue notes in a repository, first check that repository for `issues/README.md`, `issues/TEMPLATE.md`, existing `issues/*.md`, or an existing issue-note convention. If none exists and the user asks for an issue note, create `issues/<short-kebab-name>.md` in the current repository.
- `issues/*.md` may be written in the language natural for the current repository or user request, including Japanese. Use English only when the local repository instructions require it.
- When moving previously displayed or user-provided content into an issue note, preserve its structure and level of detail unless the user explicitly asks for a summary or shorter version.
- In the dotfiles repository itself, follow `issues/README.md` and use `issues/TEMPLATE.md`.

## Learning Notes

- Maintain reusable learning notes in the user's learning-notes tree when a conversation produces a durable concept, workflow, rule, implementation pattern, or pitfall.
- Do not hard-code a machine-specific learning-notes path in instructions or generated notes. Locate the tree from the current project instructions, an existing learning-notes root, or an explicit user-provided location.
- Treat each learning-notes topic like a small skill package: use a short kebab-case topic directory, keep `SKILL.md` as an index, and put detailed items in separate files.
- Update learning notes proactively after explaining or researching something reusable, unless the user explicitly asks not to write notes.
