---
name: workflow-guardrails
description: Always enforce the user's global workflow preferences across any repository and any task, especially when working with git, branches, commits, cherry-picks, rebases, or pull requests. Use this skill for all work to keep PRs single-change and to rebase only when explicitly instructed.
---

# Workflow Guardrails

## Overview

Apply the user's global workflow preferences on every task in every repository. If a request conflicts with these guardrails, pause and ask for clarification.

## Guardrails

### One change per PR

- Keep each PR scoped to exactly one logical change.
- If there are multiple logical changes in the working tree, split them into separate branches/PRs and ask which change to proceed with first.
- If the user asks to add more scope to the current PR, ask whether to open a new PR instead.
- When creating or updating a PR, verify the diff only contains the single intended change.

### Rebase only when explicitly told

- Never rebase on your own.
- Rebase only if the user says "rebase" (or clearly instructs to rebase) in the current request.
- If a task suggests rebasing (e.g., "update branch", "sync with main"), ask whether to rebase or merge.
- If asked to cherry-pick, do not rebase unless explicitly instructed.

## Usage notes

- If a PR already exists but includes multiple changes, offer to split it by creating a new branch and cherry-picking the intended commit(s).
- If the user asks for a PR and the branch contains extra commits, propose creating a clean branch from `origin/main` (or the correct base) and cherry-picking the single change.
