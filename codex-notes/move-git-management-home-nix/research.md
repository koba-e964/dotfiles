# Research: move git management to home.nix

## Relevant files and modules
- `home/home.nix`
- `home/git/default.nix`
- `ec2/ec2.nix`
- `git/.gitconfig`
- `todo.txt`

## Current execution flow and config composition
- The default Home Manager profile is created from `flake.nix` via `homeConfigurations.default.modules = [ ./home/home.nix ]`.
- In `home/home.nix`, git is configured via `programs.git = import ./git;`.
- `home/git/default.nix` currently returns an almost-empty attrset (`{ # enable = true }`), so the default profile currently has no effective git configuration from nix.
- The EC2 profile is created from `flake.nix` via `homeConfigurations.ec2.modules = [ ./ec2/ec2.nix ]`.
- In `ec2/ec2.nix`, git is configured inline under `programs.git` with:
  - `enable = true`
  - `settings.init.defaultBranch = "main"`
  - `settings.user.name = "koba-e964"`
  - `settings.user.email = "3303362+koba-e964@users.noreply.github.com"`
  - `settings.push.autoSetupRemote = true`

## Data structures and invariants observed
- Nix modules are attrset-based; `programs.git` is configured either as inline attrs or by imported module attrs.
- Existing repo pattern already uses dedicated module directories for some programs (for example `home/zsh/default.nix` imported as `programs.zsh = import ./zsh;`).
- `home/home.nix` already expects git to be managed by `home/git/default.nix`, implying a desired separation exists but is not yet implemented.

## Existing architectural patterns and conventions
- Two profile roots exist (`home/` and `ec2/`) with similar `programs = { ... }` blocks.
- Formatting style uses 4-space indentation and trailing semicolons.
- Program-specific config is often isolated in `default.nix` under a program folder.

## Error handling / safety constraints
- Moving git config between modules must preserve effective values for current users to avoid behavior regressions.
- If git settings are removed from `ec2/ec2.nix` before being provided elsewhere, EC2 git behavior regresses.
- `git/.gitconfig` exists separately and includes additional fields (`signingkey`, `core.editor`, `filter.lfs`) not currently represented in nix program configs.

## Potential pitfalls
- "Move git management to home.nix" can be interpreted in multiple ways:
  - Move only EC2 inline config into `home/git/default.nix` and reference that module.
  - Define git directly in `home/home.nix` (inline) and stop using `home/git/default.nix`.
  - Consolidate all git behavior from `git/.gitconfig` into nix (broader scope).
- A direct shared import from `home/git/default.nix` into `ec2/ec2.nix` may unintentionally apply settings intended only for one environment if not carefully scoped.

## Constraints
- Requested task scope is tied to todo item `move git management to home.nix`.
- Current repo state already has committed and uncommitted unrelated history; this change should remain limited to git management migration plus todo item cleanup.

## Decisions recorded
- Resolved by user: task scope is to consolidate all behavior from `git/.gitconfig` into nix (broader scope), not just parity with existing EC2 inline settings.
- Resolved by user rule: if common part is >= 90%, consolidate; otherwise do not consolidate.
- Current decision: consolidate shared git configuration into one nix module and consume it from both default and EC2 profiles.
