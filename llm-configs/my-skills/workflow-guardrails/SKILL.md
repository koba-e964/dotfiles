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

### Process-oriented PR checklists

- When turning a roadmap or PR list into a checklist, divide each PR into process phases by default: implementation, functional test, and self review.
- Treat "functional test" as human-facing functionality testing: manually run the feature through realistic commands or workflows, inspect what happens, and confirm the behavior makes sense from a user's perspective.
- Do not list purely automated checks such as formatters, unit tests, linters, or CI commands as functional tests; put those under implementation validation or self review instead.
- Keep the phase checklist shallow unless the user requests more depth; prefer one checklist level for PRs and one nested level for the process phases.
- Add missing process tasks from the roadmap, such as branch/worktree setup, PR-specific plan artifacts, validation commands, benchmark comparisons, dependency approval, size reporting, and single-change self review.

### Rebase only when explicitly told

- Never rebase on your own.
- Rebase only if the user says "rebase" (or clearly instructs to rebase) in the current request.
- If a task suggests rebasing (e.g., "update branch", "sync with main"), ask whether to rebase or merge.
- If asked to cherry-pick, do not rebase unless explicitly instructed.

### Tagged commits are immutable

- Never amend, rebase, squash, reset away, or otherwise rewrite a commit that is already pointed to by any tag, or any ancestor of a tagged commit.
- Treat all commits reachable from any tag as immutable because rewriting an ancestor changes the tagged commit's hash.
- Before amending or rewriting commits, check whether the target commits are tagged or reachable from any tag.
- Do not move, delete, or recreate existing tags unless the user explicitly asks to modify tags after the risk is stated.

### Always refresh origin refs

- Before using or referring to any `origin/*` reference, run `git fetch --prune`.

### Worktree locations

- For any user-requested repository task that may create files, run measurements with outputs, or edit notes, create or use a dedicated worktree before creating task artifacts or code changes unless the user explicitly says to work in the current checkout.
- For any task that may involve creating a PR, the plan must identify the branch and the intended worktree in human-meaningful terms before implementation starts, but avoid machine-specific worktree paths in plans unless the user explicitly asks for them. Do not implement PR-bound changes in the main checkout while treating worktree creation as a later cleanup step.
- If work accidentally starts in the wrong checkout, stop, create the proper worktree, move only the task artifacts there, and clean up artifacts created by the agent in the wrong checkout.
- For a repository named `XXX`, create worktrees under `../XXX-worktrees/WORKTREE-NAME/`.
- Do not create sibling worktrees directly beside the main checkout unless the user explicitly requests a different location.
- When creating PRs, use a dedicated worktree at that path for the PR branch, commit, push, and PR creation. Do not prepare PR branches directly in the main checkout unless the user explicitly says to.

### Branch from origin/HEAD for issue work

- When the user asks to fix or resolve a GitHub issue, create a new branch before making any file edits.
- The new branch must start from `origin/HEAD` (after fetch/prune), not from the current local branch.
- Use the `codex/` prefix for the branch name and keep the branch scoped to that single issue.

### Capture learnings in skills

- When a new reusable rule or lesson is learned, add it to the appropriate skill immediately.
- If the user objects to the working method, treat it as a global workflow rule by default and update the appropriate skill in the same turn.
- Only treat such feedback as task-local when the user explicitly scopes it (e.g., "for this task", "in this task only").
- Prefer updating a skill over a repository `AGENTS.md` file when the lesson should apply across repositories.
- Automatically run local validation tools after skill updates when available.
- Automatically run subagent validation after skill updates when subagent tooling is available and the validation can be done safely without modifying live production systems, requiring additional approvals, or creating excessive delay. If subagent validation cannot be run safely, say why in the final response.

### Consolidation threshold

- When deciding whether to unify similar configurations/modules, estimate shared content first.
- If commonality is 90% or higher, consolidate into a shared definition.
- If commonality is below 90%, keep separate definitions and avoid forced consolidation.

### Prefer explicit CLI options

- Prioritize portability first: use options that work reliably across commonly encountered tool versions and POSIX-conformant environments.
- When portability is not at risk and both are equivalent, prefer explicit long-form options over shorthand aliases.
- Example: prefer `--requirement` instead of `-r` only when the target tool/version supports it consistently.

### Dependency version hygiene

- Prefer warning-free dependency version requirements.
- Use the latest compatible dependency versions by default. If a dependency is intentionally not latest, add a concise comment or note justifying the older version.
- Prefer minimal dependency feature sets to reduce transitive dependencies.
- When adding dependencies, do not accept default features blindly; set `default-features = false` and explicitly enable only the needed features unless the crate has no defaults or the defaults are intentionally required.
- Before choosing libraries, packages, frameworks, crates, system tools, services, or other third-party dependencies for essential project parts, present the recommendation and get user approval. Treat areas such as encryption, randomness, UI, compression, persistence, networking, authentication, and other core behavior as essential across all languages and ecosystems.

### Code comment language

- Write newly added code comments in English by default, even in files that already contain comments in another language. Preserve existing comments unless editing them is necessary.

### Path hygiene for outputs

- When an unrelated concern has already been resolved in the current base, treat it as current state in plans and summaries; avoid provenance commentary unless it affects the task.

- In repo notes, plans, summaries, and proposed commit content, prefer workspace-relative paths over machine-specific absolute paths.
- Remove local prefixes like `/Users/<name>/...` unless absolute paths are explicitly requested for tooling or reproducibility.

### Voice-typed input handling

- Assume minor typos may come from voice input and prioritize intended meaning over literal spelling.
- Do not block progress on typo cleanup unless meaning is ambiguous or technically unsafe.

### Interruption handling

- If the user interrupts with a question or side note related to the current task or discussion, answer it and then resume the most recently requested unfinished task that was in progress before the interruption, unless the user explicitly cancels or redirects away from it.
- Do not treat a brief side topic as cancellation unless the user explicitly cancels or redirects the task.

### Show diffs after edits

- When running in Codex App and making file changes, include a concise diff in the response by default.
- If no files changed, explicitly state that no diff exists.

### Clarify copy-derived implementations

- When the user asks to create a separate implementation file, do not assume they want a copy-derived variant of an existing implementation.
- Before copying an existing solution as the base for a new solver or experimental file, explicitly ask whether copy-derived work is acceptable, unless the user has already requested copying, porting, or incremental derivation.

### Benchmark execution

- Benchmark workflows and benchmark measurement commands should use release-mode builds by default unless the user explicitly asks to measure debug builds.

### Release binary size reporting

- When changes could affect compiled binary size, especially dependency or CLI/parser changes, build the release binary and report the before/after byte sizes and delta. If the user provides a prior baseline size, use that baseline explicitly. Do not comma-separate byte counts; write plain digits.

### Run validators after edits

- After file changes are complete, run every validator in `.codex/agents/` and `~/.codex/agents/` whose documentation explicitly says it applies to the changed files or task domain.
- Evaluate validators against the current patch, not the whole repository, and run all that apply.
- Run validators after the planned edits are complete, since validator agents can be expensive.
- If an applicable validator cannot be run because the required agent or tool is unavailable, or because the validator cannot run successfully in this environment, continue without it and note that limitation in the final response.
- Treat validator findings as recommendations to consider. Apply them only when they are compatible with user instructions and repository constraints.
- If you make additional edits based on validator suggestions, rerun every applicable validator against the current diff for those edits before responding.
- For a single user request, count every validator invocation, including failed attempts and reruns after follow-up edits; stop after five invocations total. If unresolved findings remain after five validator invocations, report them instead of running more validators.

### Remove PR notes before merge

- Keep PR-specific `codex-notes` available in the PR while review is active.
- Right before the user merges a PR, remove that PR's `codex-notes` artifacts so they do not land in `origin/HEAD`.
- This cleanup must be a separate final commit on the PR branch. Do not amend note deletion into the feature/fix commit.
- Only delete notes that belong to the PR being merged; leave unrelated note directories untouched.

## Usage notes

- If a PR already exists but includes multiple changes, offer to split it by creating a new branch and cherry-picking the intended commit(s).
- If the user asks for a PR and the branch contains extra commits, propose creating a clean branch from `origin/main` (or the correct base) and cherry-picking the single change.
