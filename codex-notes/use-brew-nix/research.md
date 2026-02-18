# Research: Use brew-nix

## Relevant files and modules
- `todo.txt`
- `install.sh`
- `flake.nix`
- `home/home.nix`
- `home/zsh/default.nix`
- `ec2/zsh/default.nix`

## Current behavior and execution flow
- Bootstrap entrypoint is `install.sh`.
- On macOS (`uname == Darwin`), `install.sh`:
  - Installs Homebrew if missing.
  - Runs `brew install` with a long list of formulae.
  - Later installs Nix and applies Home Manager (`nix run .#home-manager ... switch ...`).
- Home Manager config (`home/home.nix`) currently manages user packages via `home.packages` but does not manage Homebrew formulae/casks.
- `flake.nix` only wires `nixpkgs` + `home-manager`; there is no `nix-darwin` or `nix-homebrew` input.

## Existing Homebrew coupling in shell config
- `home/zsh/default.nix` includes Homebrew-specific behavior:
  - `brew --prefix` used for completion path.
  - Hardcoded `/opt/homebrew/...` PATH exports (ruby, openssl, postgresql, gem bins).
- `ec2/zsh/default.nix` also contains a `brew --prefix` completion block even though EC2 target is Linux.

## Data structures and invariants
- System split:
  - `homeConfigurations.default` targets `aarch64-darwin`.
  - `homeConfigurations.ec2` targets `x86_64-linux`.
- Repo pattern:
  - Home Manager modules are user-level and currently responsible for dotfile and user tool config.
  - OS-level package bootstrap remains shell-script driven (`install.sh`).

## Architectural constraints
- Home Manager alone does not provide first-class management of Homebrew formula/cask state equivalent to nix-darwin’s `homebrew.*` module.
- Full "brew managed by nix" typically requires introducing `nix-darwin` and/or `nix-homebrew` and moving system activation to darwin-rebuild.
- This repository currently has no darwin system configuration tree; introducing one is a larger structural change than a simple package list edit.

## Potential pitfalls
- Replacing `brew install` in `install.sh` without a replacement mechanism will break bootstrapping on fresh macOS hosts.
- Moving to nix-darwin may impact activation workflow (`nix run .#home-manager ...`) and require additional privileges/setup.
- Mixing script-managed brew and nix-managed brew simultaneously can create drift if both remain authoritative.

## Naming and style conventions observed
- Nix files use 4-space indentation.
- Module composition uses relative imports and explicit attrsets.
- Todo items are removed once completed.

## Scope decisions from user
- "Use brew-nix" is limited to Homebrew casks.
- Ordinary Homebrew formula packages should be handled by Home Manager (`home.packages`) instead of `brew install`.
- This implies a split model:
  - casks via brew-nix style integration,
  - regular packages via nixpkgs/Home Manager.

## Remaining unknowns
- Exact integration method for casks in this repo (for example, introducing `brew-nix` as a flake input/module vs another minimal mechanism compatible with the current Home Manager workflow).
- Whether the `install.sh` Homebrew bootstrap should remain only for cask runtime prerequisites or be reduced further.

## Key reality summary
- Today, Homebrew is imperative (`install.sh`) while Nix is user-level declarative (Home Manager).
- Achieving true "brew-nix" in a declarative sense likely implies introducing darwin-level Nix modules not currently present.
