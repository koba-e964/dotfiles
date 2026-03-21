---
name: stow-first-time-adopt
description: Manage first-time stow adoption safely. Use when introducing an existing local file into a stow-managed package so current content is preserved without keeping --adopt in recurring install scripts.
---

# Stow First-Time Adopt

## Overview

Use this skill when a file already exists on disk and is being moved under stow management.

## Rules

- Run `stow --adopt <package>` once for first-time migration so local file content is moved into the package.
- Keep recurring install commands (`install.sh` or similar) on plain `stow` without `--adopt`.
- Verify post-migration link targets point from the home path to the repo package file.

## Example

- First-time migration: `stow --target="$HOME" --verbose --adopt zed`
- Recurring install entry: `stow --target="${HOME}" --verbose zed`
