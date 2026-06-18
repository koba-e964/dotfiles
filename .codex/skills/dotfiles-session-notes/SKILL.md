---
name: dotfiles-session-notes
description: Repo-specific operational notes for /Users/kobas-mac/srcview/dotfiles. Use when working on this repo's date tag workflow, zsh history ignorePatterns behavior, or the user preference to beep on completion.
allowed-tools:
  - Bash(git log:*)
  - Bash(git tag:*)
  - Bash(git show-ref:*)
---

# Dotfiles Session Notes

## Overview

Capture session-specific behavior and preferences for this dotfiles repo so changes remain consistent and user expectations are met.

## Date Tags

- Use one lightweight date tag per workday, formatted `YYYY.MM.DD`, pointing at the final commit from that day's batch.
- Interpret workdays and calendar-day boundaries in the `Asia/Tokyo` timezone.
- Do not create a date tag on the same calendar day as the commits it would tag.
- Create a date tag only after the next calendar day has started.
- Before creating tags, list the exact tag names and commit hashes, then ask the user for confirmation.

## Zsh History Ignore Patterns

- Prefer `programs.zsh.history.ignorePatterns` for the pattern list in `home/zsh/default.nix`.
- `HISTORY_IGNORE` only filters when writing the history file; to prevent entries from being added at all, define a `zshaddhistory` hook.
- Ensure extended globbing is enabled (`setopt EXTENDED_GLOB`) and use `[[ $1 != ${~HISTORY_IGNORE} ]]` inside the hook.
- The patterns use extended glob syntax like `ls#( *)#`, so keep `setopt extendedglob` within the hook as well.
- To disable extended globbing in the current shell session, run `unsetopt EXTENDED_GLOB`.
- In Nix multi-line strings (like `initContent`), escape zsh variables as `''${VAR}` to avoid Nix interpolation, e.g. `''${HISTORY_IGNORE:-}`.
- `zshaddhistory` receives the command line with a trailing newline; strip it (e.g. `local line=''${1%%$'\n'}`) before matching ignore patterns.
- If ignored commands still show on Up/Down, clear in-memory history with `history -c` then reload with `fc -R`.

## EC2 Home Manager Profile

- `flake.nix` defines `homeConfigurations.ec2` for EC2 using `x86_64-linux` and modules `[ ./ec2/ec2.nix ]`.
- `nix run .#home-manager` on EC2 requires `apps.x86_64-linux.home-manager` (and/or packages) to be exported; add `packages.${ec2System}.home-manager` and `apps.${ec2System}.home-manager` alongside the Darwin outputs in `flake.nix`.
- `ec2/ec2.nix` installs `codex`, `git`, `ripgrep`, `termux`, plus existing tools.
- `nix flake check` may fail without access to the Nix cache; rerun with escalated permissions if the cache DB can't be opened.
