---
name: commit
description: Write concise Conventional Commit messages using standard commit types. Use when the user asks to create or improve commit messages and needs clear scope without noisy generated prose.
---

# Commit

## Overview

Produce a conventional commit message with a precise subject and only the body content that adds real value.
Follow ordinary Conventional Commits conventions without restricting commit types.

## Commit Type Rules

- Use standard Conventional Commits types based on the change intent.
- Common types include `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, and `chore`.
- If multiple types seem valid, choose the one that best reflects user-facing impact.

## Message Format

Use this structure only when a body is useful:

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

- Prefer subject-only commits for small, obvious changes.
- Prefer the shortest clear subject the repository context supports.
- Include a body only when it explains non-obvious context, risk, migration notes, or verification that a maintainer would actually need.
- Do not add boilerplate sections just to fill a template.
- Mention concrete files/components when they clarify scope.
- Note any breaking changes explicitly in `Impact`.
- If no test was run, mention it only when validation would reasonably be expected.
- Never include `Prompt:` sections or meta-commentary about LLMs, agents, unstaged unrelated work, or process details that are not part of the commit's actual project change.
- Avoid LLM slop: generic "Why/What/Impact" filler, obvious restatements, and defensive notes that do not help future readers.

## Split Follow-Up Commits By Logical Concern

- Before committing follow-up work, decide whether the new work is the same logical concern as the existing commit or a distinct follow-up concern.
- Amending a commit is appropriate for same-change cleanup, review feedback that clearly belongs to the original change, or user-requested history cleanup.
- If a follow-up change fixes or completes the immediately preceding commit's logical change, amend that commit instead of creating a new commit.
- If the new work is a distinct concern, add a separate commit by default.
- If unsure whether to amend or split, ask the user before committing or rewriting history.

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
