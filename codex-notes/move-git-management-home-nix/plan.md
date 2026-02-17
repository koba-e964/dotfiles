# Plan: move git management to home.nix

## Overview
Consolidate git configuration into a shared nix module under `common/` and have both default and EC2 Home Manager profiles consume that module. Migrate all behavior currently represented in `git/.gitconfig` into nix-managed `programs.git.settings`, preserving existing values.

This follows the approved rule: commonality is >= 90%, so consolidate.

## Files to change
- `common/git/default.nix`
- `home/home.nix`
- `ec2/ec2.nix`
- `todo.txt`

## Detailed implementation steps
1. Populate shared git module in `common/git/default.nix`.
- Define `enable = true`.
- Add `settings` entries to match `git/.gitconfig` behavior:
  - `user.name = "koba-e964"`
  - `user.email = "3303362+koba-e964@users.noreply.github.com"`
  - `user.signingkey = "7644C3550BFD7D42"`
  - `push.autoSetupRemote = true`
  - `core.editor = "vi"`
  - `init.defaultBranch = "main"`
  - `filter."lfs" = { required = true; clean = "git-lfs clean -- %f"; smudge = "git-lfs smudge -- %f"; process = "git-lfs filter-process"; }`

2. Ensure default profile consumes shared module.
- Update `home/home.nix` to set `programs.git = import ../common/git;`.
- Remove no-longer-needed `home/git/default.nix` module reference in `home/home.nix`.

3. Switch EC2 profile to shared module.
- Replace inline `programs.git` block in `ec2/ec2.nix` with `programs.git = import ../common/git;`.
- Preserve surrounding program entries (`tmux`, `zsh`, `gh`, `zoxide`) unchanged.

4. Update todo list.
- Remove `move git management to home.nix` from `todo.txt` after implementation.

5. Validate resulting diff.
- Confirm only intended files changed.
- Confirm no unrelated settings are modified.

## Alternatives considered
1. Keep separate git configs in `home/home.nix` and `ec2/ec2.nix`.
- Rejected because it duplicates shared logic and conflicts with approved >=90% consolidation rule.

2. Keep shared git module under `home/`.
- Rejected because `home/` is environment-specific; by user note, shared settings should be in `common/`.

3. Leave LFS filter out of nix and keep it only in `git/.gitconfig`.
- Rejected because requested scope is to consolidate all git behavior from `git/.gitconfig` into nix.

## Risks
- Some git settings may differ subtly between Home Manager generated config and hand-written `.gitconfig` ordering; semantic values should remain equivalent.
- If EC2 needs environment-specific git settings later, shared config may require an override mechanism.

## Test strategy
- Run `git diff` on changed files and confirm values match source `.gitconfig` intent.
- Optionally run a Home Manager eval/apply command later (outside this planning phase) to validate module evaluation.
- Spot-check generated behavior expectation:
  - default branch remains `main`
  - push auto setup remains enabled
  - git user/signing key values remain unchanged

## Assumptions
- User wants identical git settings on default and EC2 profiles unless explicitly stated otherwise.
- Keeping `git/.gitconfig` file in repository is acceptable even after nix consolidation (no deletion requested).
- `git-lfs` command strings should be preserved exactly as currently written.
- It is acceptable to introduce `common/git/default.nix` for shared module organization.

## Open questions
- None blocking for implementation under approved scope.

## Implementation Checklist
- [ ] Add full shared git settings to `common/git/default.nix`
- [ ] Update `home/home.nix` to import `../common/git`
- [ ] Update `ec2/ec2.nix` to import shared git module
- [ ] Remove `move git management to home.nix` from `todo.txt`
- [ ] Review final diff for scope correctness
