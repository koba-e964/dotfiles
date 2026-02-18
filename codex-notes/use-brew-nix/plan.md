# Plan: Use brew-nix (casks only, safe rollout)

## Overview
Adopt `brew-nix` only for Homebrew casks while keeping risk low by introducing a quarantine list for casks that fail builds/updates. Do not force migration of all Homebrew formulae in this change; preserve current bootstrap behavior to avoid environment breakage during cask migration.

This plan follows the user requirement:
- casks via brew-nix,
- ordinary packages can be managed by Home Manager (handled incrementally, not bulk-migrated in this risky step).

## Files to change
- `flake.nix`
- `home/home.nix`
- `home/brew-casks.nix` (new)
- `todo.txt`

## Detailed implementation steps
1. Add brew-nix inputs to flake.
- Add `brew-nix` and `brew-api` to `flake.nix` inputs.
- Wire `brew-nix` input exactly as documented in upstream README (`brew-nix.inputs.brew-api.follows = "brew-api"`).

2. Make `inputs` available to Home Manager modules.
- In `homeConfigurations.default`, add `extraSpecialArgs = { inherit inputs; };` (or equivalent) so `home/home.nix` can reference flake inputs.
- Keep EC2 config unchanged (brew-nix is macOS-only).

3. Add dedicated casks module for Darwin user profile.
- Create `home/brew-casks.nix` that:
  - enables brew-nix overlay via `nixpkgs.overlays = [ inputs.brew-nix.overlays.default ];`
  - defines two explicit lists:
    - `stableCasks` (initially from installed casks that are known-good)
    - `quarantinedCasks` (known failing/unreliable casks, excluded from installation)
  - installs only `stableCasks` via `home.packages` using `pkgs.brewCasks.<name>`.

4. Integrate cask module into home profile.
- Import `./brew-casks.nix` from `home/home.nix`.
- Do not touch EC2 profile.

5. Seed conservative initial cask set.
- Start with currently installed casks discovered on this machine:
  - `background-music`, `docker`, `docker-desktop`, `r`, `r-app`, `slack`, `visual-studio-code`, `wine-crossover`, `wireshark`, `wireshark-app`
- Put potentially problematic items into `quarantinedCasks` first if they are known to fail (user-maintained list).
- Keep quarantine explicit and commented to support gradual promotion to stable list.

6. Remove completed todo item.
- Delete `Use brew-nix` from `todo.txt`.

7. Validate scope.
- Confirm only the above files changed.
- Confirm EC2 and install script behavior are untouched in this change.

## Alternatives considered
1. Full migration now: move all brew formulae from `install.sh` to Home Manager in the same PR.
- Rejected for this step due to high risk and user concern about environment breakage.

2. Use nix-darwin homebrew module instead of brew-nix.
- Rejected because requested direction is brew-nix for casks.

3. Keep casks imperative in `brew install --cask`.
- Rejected because it does not satisfy the todo goal and remains non-declarative.

## Risks
- Some casks in brew-nix may require manual overrides (missing hash/variant constraints).
- Cask app discoverability/launch behavior may differ from Homebrew-managed app installs.
- Disk usage can increase due to Nix generations containing cask artifacts.

## Test strategy
- Static validation:
  - `nix flake check` (or at minimum `nix eval`) to verify configuration evaluates.
- Runtime validation on Darwin profile:
  - `nix run .#home-manager -- switch --flake .#default --impure --extra-experimental-features "nix-command flakes"`
- Post-apply checks:
  - confirm expected apps are available for stable casks
  - confirm quarantined casks are not installed via brew-nix.

## Assumptions
- User will maintain/adjust the quarantine list over time.
- This step intentionally prioritizes safe cask migration over complete package-source consolidation.

## Open questions
- Which installed casks should start in `quarantinedCasks` based on your known failures?

## Implementation Checklist
- [ ] Add `brew-nix` + `brew-api` flake inputs
- [ ] Pass `inputs` into default Home Manager configuration
- [ ] Add `home/brew-casks.nix` with stable/quarantine cask lists
- [ ] Import casks module from `home/home.nix`
- [ ] Remove `Use brew-nix` from `todo.txt`
- [ ] Verify changed-file scope and config consistency
