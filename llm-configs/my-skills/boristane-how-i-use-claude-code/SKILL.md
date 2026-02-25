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
4. Todo checklist creation
5. Implementation (only after explicit approval)

The agent must NEVER skip phases or implement early.

The plan document is the source of truth for implementation.

Approval gate between phases:

- Generate `research.md` first, then pause for explicit user approval.
- Do not generate `plan.md` until the user approves `research.md`.
- After generating `plan.md`, pause again and wait for explicit plan approval before implementation.

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

# Phase 4: Todo Checklist Creation

Before implementation begins, plan.md must include a checklist.

Append:

## Implementation Checklist

Break implementation into small atomic tasks.

Each task must be:

- Specific
- Observable
- Verifiable

Example:

- [ ] Modify src/auth/session.ts to add expiration validation
- [ ] Update middleware/auth.ts to enforce expiration
- [ ] Add unit tests in tests/session.test.ts

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

Update plan.md checklist.

Mark completed items:

- [x] Completed task

plan.md becomes the live progress tracker.

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
- Ignore user annotations
- Expand scope silently

ALWAYS:

- Treat plan.md as source of truth
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
