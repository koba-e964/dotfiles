---
name: daily-ops-spec-driven
description: Drive recurring non-coding work with a semi-automated brief/plan/todo/knowledge workflow, emphasizing human approval gates and reusable operational knowledge.
---

# Daily Ops Spec Driven

## Overview

Use this skill when the user wants to speed up recurring operational tasks (expense claims, monthly reporting, inbox triage, document prep) with AI support while keeping human review in control.

The goal is not full automation. The goal is high-leverage semi-automation with clear inputs, clear outputs, and repeatable documentation.

## Trigger cues

- "定常業務を半自動化したい"
- "毎月同じ作業を早くしたい"
- "この手順をテンプレート化したい"
- "AIに任せる範囲と人間確認の境界を決めたい"

## Core workflow

Follow these steps in order.

1. Use user-authored `brief.md` as the source of truth
- Read background, goals, constraints, and approval points from `brief.md`
- If details are missing, ask concise follow-up questions instead of creating `brief.md`

2. Define contract in `plan.md`
- Required inputs and validation rules
- Output format and acceptance criteria
- Edge cases and exception handling
- Privacy and masking rules

3. Execute with checkpointed tasks in `todo.md`
- Break work into small observable tasks
- Mark each item done only after verification
- Keep one owner per task when collaborating

4. Record reusable knowledge in `knowledge.md`
- Pitfalls and resolutions
- Business-specific interpretation rules
- Re-run procedure for next cycle

## File location rules

- Keep `brief.md`, `plan.md`, and `knowledge.md` under the task `docs/` directory.
- Keep `todo.md` under a date directory (`YYYYMMDD/`) for each execution.
- Example:
  - `work/<task>/docs/brief.md`
  - `work/<task>/docs/plan.md`
  - `work/<task>/docs/knowledge.md`
  - `work/<task>/YYYYMMDD/todo.md`

## Output rules

- Prefer copy-paste ready deliverables (report text, application text, response draft).
- Always include traceable evidence links or source references for computed values.
- Separate generated output from assumptions and unresolved questions.

## Human-in-the-loop guardrails

- Do not assume full autonomy; always preserve final human approval.
- Confirm sensitive-data handling before processing personal or internal data.
- If a requirement is ambiguous, list assumptions explicitly before execution.
- Prioritize automating the heaviest repeated steps first.

## Practical completion checklist

Do not create `brief.md` unless the user explicitly asks. Treat it as user-owned by default.

- `brief.md` contains context and approval points.
- `plan.md` defines input/output contract and edge cases.
- `todo.md` reflects execution status.
- `knowledge.md` captures reusable lessons.
- Final deliverable is ready for human review and submission.
