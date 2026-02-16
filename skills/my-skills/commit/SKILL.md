---
name: commit
description: Write comprehensive conventional commit messages using only chore, feat, or fix. Use when the user asks to create or improve commit messages and needs clear scope, intent, and impact in the commit subject and body.
---

# Commit

## Overview

Produce a conventional commit message with a precise subject and informative body.
Allow only `chore`, `feat`, and `fix` as commit types.

## Commit Type Rules

- `feat`: Use for user-visible functionality or new capabilities.
- `fix`: Use for bug fixes and behavior corrections.
- `chore`: Use for maintenance, tooling, refactors without behavior changes, docs/process updates.
- If multiple types seem valid, choose the one that best reflects user-facing impact. Prefer `feat`/`fix` over `chore` when behavior changes.

## Message Format

Use this structure:

```text
<type>(<optional-scope>): <imperative summary>

Why:
- <problem, risk, or context>

What:
- <main change 1>
- <main change 2>

Impact:
- <behavior/performance/compatibility notes>
- <testing or validation performed>
```

## Subject Line Rules

- Keep the subject under 72 characters when practical.
- Use imperative mood: `add`, `update`, `remove`, `fix`.
- Be specific; avoid vague text like `update stuff`.

## Body Rules

- Always include `Why`, `What`, and `Impact` sections for a comprehensive message.
- Mention concrete files/components when they clarify scope.
- Note any breaking changes explicitly in `Impact`.
- If no test was run, say so directly in `Impact`.

## Examples

```text
feat(auth): add refresh token rotation on login

Why:
- Session replay risk increases when long-lived refresh tokens are reused.

What:
- Generate a new refresh token on each successful refresh.
- Revoke the previous token after rotation.
- Add token family tracking in the auth repository layer.

Impact:
- Improves account security for stolen-token scenarios.
- Adds one extra DB write during refresh flow.
- Verified with auth integration tests.
```

```text
fix(cli): handle empty config path without panic

Why:
- Passing an empty `--config` flag currently dereferences a nil pointer.

What:
- Add guard clause before file open.
- Return explicit usage error for empty config path.
- Add regression test for empty and whitespace-only values.

Impact:
- Prevents crash and returns actionable error text.
- No behavior change for valid config paths.
- Verified with unit tests for config parsing.
```

```text
chore(repo): align lint scripts across packages

Why:
- Inconsistent lint commands make CI and local checks diverge.

What:
- Standardize `lint` and `lint:fix` scripts in all package manifests.
- Remove deprecated eslint flags and update shared config reference.

Impact:
- No runtime behavior changes.
- Reduces CI noise and local setup friction.
- Verified by running workspace lint command.
```
