---
name: research-plan-implement
description: Enforce a strict Research → Plan → Annotate → Implement workflow. Prevent premature implementation. Require explicit written research and planning artifacts before any code changes. Use this skill for all non-trivial engineering tasks.
---

# Research → Plan → Annotate → Implement Workflow

## Overview

This skill enforces a structured engineering workflow to maximize correctness, maintainability, and alignment with user intent.

The agent must always progress through these phases in order:

1. Research
2. Plan
3. Annotation cycle (human review)
4. Feature list creation
5. Implementation (only after explicit approval)

The agent must NEVER skip phases or implement early.

The plan document is the source of truth for implementation.
The todo/progress list must live in a separate JSON file named `feature_list.json`, not inside `plan.md`.

Approval gate between phases:

- Generate `research.md` first, then pause for explicit user approval.
- Do not generate `plan.md` until the user approves `research.md`.
- After generating `plan.md` and `feature_list.json`, pause again and wait for explicit plan approval before implementation.

---

# Phase 0: Activation Criteria

Activate this skill automatically when:

- The user requests implementation of a feature
- The user requests refactoring
- The user requests architectural changes
- The user requests bug fixes (unless trivial and explicitly stated)
- The task affects multiple files
- The task affects core logic
- The task is ambiguous
- The task is high-risk

Do NOT activate for:

- Pure explanations
- Documentation-only tasks (unless explicitly requested)
- Tiny mechanical edits explicitly requested

When in doubt, activate.

---

# Phase 1: Research Phase

## Objective

Build deep understanding of the existing system BEFORE proposing changes.

Research depth requirements:

- Develop deep understanding of the relevant system behavior, not just surface structure.
- Understand the intricacies (edge cases, coupling points, implicit assumptions, operational constraints).
- Go through everything related to the requested change before moving to planning.

## Allowed actions

- Read files
- Analyze code
- Trace execution paths
- Identify patterns and conventions

## Forbidden actions

- Writing production code
- Editing production code
- Proposing implementation changes in code form

## Required output

Write:

`<notes_prefix>/research.md`

Default `notes_prefix`:

- `codex-notes/<task-slug>`

Path rule:

- Avoid generic prefixes like `ai/` because they can collide with existing repo conventions.
- Prefer task-scoped directories that include a short task description (example: `codex-notes/local-python-migration/research.md`).
- Use workspace-relative file paths inside `research.md` and `plan.md` by default; avoid machine-specific absolute paths unless explicitly requested.
- If the user specifies a prefix, follow it.

## research.md must include

- Relevant files and modules
- Execution flow and call graph
- Data structures and invariants
- Existing architectural patterns
- Naming conventions
- Error handling patterns
- Typing conventions
- Potential pitfalls
- Constraints
- Unknowns

Focus on understanding current reality, not proposing changes.

## Exit condition for Phase 1

- Pause after writing `research.md` and request explicit user approval to proceed to Phase 2.

---

# Phase 2: Planning Phase

## Objective

Design the implementation fully before writing any code.

## Required output

Write:

`<notes_prefix>/plan.md`

Also write:

`<notes_prefix>/feature_list.json`

## Entry condition for Phase 2

- Allowed only after explicit user approval of `research.md`.

## plan.md must include

### Overview

High-level approach.

### Files to change

Explicit list with paths.

### Detailed implementation steps

Step-by-step changes.

Include pseudocode or example snippets when helpful.

### Alternatives considered

Other possible approaches and why rejected.

### Risks

Possible failure modes.

### Test strategy

How correctness will be verified.

### Assumptions

Explicit assumptions.

### Open questions

Anything requiring clarification.

## feature_list.json must include

- A top-level JSON object.
- A `features` array.
- One object per implementation task.
- Each task object must include:
  - `id`: stable short string identifier.
  - `description`: specific, observable, verifiable task.
  - `validation`: short description of the check that proves the task is done; include a short command line whenever a concrete local check is available.
  - `passes`: boolean showing whether validation passes.

Example:

```json
{
  "features": [
    {
      "id": "add-expiration-validation",
      "description": "Modify src/auth/session.ts to add expiration validation",
      "validation": "npm test -- session; covers expired and unexpired sessions",
      "passes": false
    },
    {
      "id": "enforce-expiration",
      "description": "Update middleware/auth.ts to enforce expiration",
      "validation": "npm test -- middleware; rejects expired sessions",
      "passes": false
    },
    {
      "id": "test-expiration-validation",
      "description": "Add unit tests in tests/session.test.ts",
      "validation": "npm test -- tests/session.test.ts",
      "passes": false
    }
  ]
}
```

---

# Phase 3: Annotation Cycle

## Objective

Allow the user to modify plan.md and provide feedback.

## Agent behavior

When the user indicates plan.md has comments, notes, or edits:

- Read plan.md fully
- Address every note
- Update plan.md accordingly

Do NOT implement.

Repeat this cycle indefinitely until explicit approval.

---

# Phase 4: Feature List Creation

Before implementation begins, `<notes_prefix>/feature_list.json` must exist.

Break implementation into small atomic tasks in the `features` array.

Each task must be:

- Specific
- Observable
- Verifiable
- Paired with a short validation command whenever one exists

---

# Phase 5: Implementation Phase

## Entry condition

Implementation is allowed ONLY if the user explicitly approves the plan.

Valid approval examples:

- "Plan approved"
- "Implement the plan"
- "Go ahead and implement"
- "Execute plan.md"

Without explicit approval, DO NOT implement.

If unsure, ask for confirmation.

---

# Implementation Rules

Follow plan.md exactly.

Do not introduce unrelated changes.

Do not expand scope.

If unexpected issues arise:

STOP.

Explain the issue.

Request clarification.

---

# Implementation Progress Tracking

As tasks are completed:

Update `<notes_prefix>/feature_list.json`.

Set each task's `passes` field to `true` only after its `validation` check passes.
Leave `passes` as `false` while the task is not done, is actively being worked on, or is blocked.

`feature_list.json` is the live progress tracker. `plan.md` remains the approved implementation design.

---

# Code Quality Rules

Follow existing repository conventions.

Match:

- Naming patterns
- Architecture patterns
- Typing patterns
- Error handling patterns
- Formatting

Do NOT introduce:

- Unnecessary abstractions
- Premature optimization
- Unrequested refactors

---

# Safety Guardrails

NEVER:

- Implement before plan approval
- Skip research phase
- Skip planning phase
- Ignore plan.md
- Ignore feature_list.json
- Ignore user annotations
- Expand scope silently

ALWAYS:

- Treat plan.md as source of truth
- Treat feature_list.json as the task progress source of truth
- Prioritize correctness over speed
- Prefer consistency over cleverness

---

# Conflict Resolution

If plan.md conflicts with reality:

STOP.

Explain:

- What conflicts
- Why
- Proposed resolution

Wait for user instruction.

---

# Summary

This workflow ensures:

- Deep understanding before coding
- Explicit planning
- Human review integration
- Controlled implementation
- High reliability outcomes

This skill must be enforced strictly.
