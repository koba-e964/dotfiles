---
name: github-actions
description: Enforce GitHub Actions security rules across any repo: actions/* can be trusted by tag, all other actions must be pinned to exact commit hashes with an inline version comment (e.g., # vX.Y.Z). Use for any workflow edits or reviews.
---

# GitHub Actions Security Rules

## Overview

Apply the user's GitHub Actions trust policy on every workflow change or review.

## Trust policy

- **Allowed by tag**: `actions/*`
- **All other actions**: must be pinned to an exact commit hash and include an inline version comment (e.g., `# v31.9.0`).

## Workflow checks

- If a non-`actions/*` step uses a version tag (e.g., `@v1`), replace it with the exact commit hash and add the version comment.
- Do not introduce new actions that are not pinned unless they are under `actions/*`.
- If the user supplies a version, look up the exact commit hash for that tag before updating the workflow.
