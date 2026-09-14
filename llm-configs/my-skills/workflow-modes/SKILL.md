---
name: workflow-modes
description: Apply explicitly requested commit+review, vibe, or plan workflow modes to repository work; do not activate for ordinary tasks without a mode request.
---

# Workflow Modes

Use this skill only when the user explicitly requests `$workflow-modes`, commit+review mode, vibe mode, or plan mode.

## Shared rules

- State the active mode and current step before taking repository actions.
- Keep logical changes scoped and preserve unrelated user changes.
- After implementation, show the literal patch (`git diff`; for untracked files use a no-index diff) rather than only a summary.
- Run the repository's required formatting, tests, linting, and pre-commit checks before committing.
- Before commit, inspect `git status --short --untracked-files=all` and search for unreviewed-change markers.
- Use concise Conventional Commit messages.

## Commit+review mode

Use one logical change at a time. Implement it, validate it, show the literal diff, and pause for explicit approval before committing. If the user approves, commit immediately, record the commit in the progress artifact when one exists, report the next step, and continue working on that next step without waiting for another approval. Pause again only after the next logical change has been implemented, validated, and shown as a literal diff.

## Vibe mode

Iterate through the requested work without approval pauses. After each validated logical change, show the literal diff and commit it. Continue until the requested scope is complete; push only at the end unless the user explicitly requests an earlier push. Keep the current step and substeps visible.

## Plan mode

Create or maintain one concise Markdown checklist in the repository when progress tracking is requested. Divide each logical step into concrete checkbox substeps, mark only implemented and validated work complete, show the current step, and record approval gates or commit hashes when relevant. Use exactly three checkbox states: `[ ]` for todo, `[-]` for doing, and `[x]` for done. Do not use plan tracking for ordinary one-step tasks unless requested.

Before presenting a plan for approval, review it with the `agents/self-contained-plan-validator.toml` subagent against the complete plan and the task context available to the implementer. The review must check that a fresh implementer can execute the plan without relying on unstated conversation context, including the objective, scope, affected files, required behavior, implementation steps, validation commands, acceptance criteria, assumptions, and unresolved decisions. It should treat ordinary repository references as valid when the plan names the path and explains what to inspect or change, and report missing or ambiguous information rather than rewriting the plan. Address BLOCKER findings and any applicable WARNING findings in the plan, then rerun the review after those edits. Do not present the plan for approval until the review reports no remaining BLOCKER findings. Repeat the review after any later plan revision that changes the implementation scope or requirements.

Use the states as a strict transition: begin each item as `[ ]`, change it to `[-]` when work starts, and change it to `[x]` only after implementation is validated and the user approves. Make that final `[-]` to `[x]` update in the same commit as the implementation. Do not mark unrelated items complete while committing another logical slice.

Formatting, tests, Clippy, and pre-commit are workflow validation requirements, not task-plan items. Run them as required before commits without adding them as checklist work.

Plan files describe the task, not the workflow mode. Do not put commit+review, vibe-mode, or plan-mode operating instructions in a task plan. Keep mode mechanics in this skill; task plans may record implementation commit hashes when that is useful for task history.

### Example

For a request to add ergonomic variable names, a task plan may contain:

```markdown
# Ergonomic variable names

Current step: Step 1 — add a named-parser API.

## Step 1: Add a named-parser API

- [ ] Add a parsed-formula result with a display-name mapping.
- [ ] Preserve the legacy numeric parser.
- [ ] Add parser tests for names such as `x`, `y`, and `tmp`.
```

The plan should not contain items such as “show the diff,” “pause for approval,” or “commit after approval.” Those are applied by this skill according to the active mode.

When modes conflict, follow the most recent explicit user mode request and preserve repository-local instructions.
