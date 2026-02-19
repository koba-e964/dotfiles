---
name: pre-commit-install
description: Always install pre-commit hooks after cloning any repo that contains a .pre-commit-config.yaml file. Use when cloning repos or setting up a new local checkout.
---

# Pre-Commit Install

## Rule

After `git clone`, if the repo has `.pre-commit-config.yaml`, immediately run:

```sh
pre-commit install
```

## Notes

- Run this once per new clone.
- If pre-commit isn't installed, ask to install it first.
