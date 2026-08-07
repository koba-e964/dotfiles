#!/usr/bin/env python3
"""Block Codex mutations in marked canonical source checkouts.
Repository worktree enforcement is opt-in. When a repository root contains
`.always-create-worktree`, mutating tools are denied in canonical srcview
checkouts unless the cwd is already inside a sibling worktrees checkout.
Repositories without the marker are not forced through this hook.
"""

from __future__ import annotations

import json
import os
import re
import shlex
import subprocess
import sys
from pathlib import Path
from typing import Any


SRCVIEW = Path("/Users/kobas-mac/srcview")
WORKTREE_MARKER = ".always-create-worktree"

READ_ONLY_COMMANDS = {
    "cat",
    "date",
    "find",
    "git",
    "ls",
    "nl",
    "npm",
    "pwd",
    "rg",
    "sed",
    "wc",
}

READ_ONLY_GIT_SUBCOMMANDS = {
    "branch",
    "diff",
    "log",
    "ls-files",
    "rev-parse",
    "show",
    "status",
    "worktree",
}

READ_ONLY_NPM_SUBCOMMANDS = {
    "audit",
    "ls",
    "outdated",
    "pkg",
    "view",
}

WORKTREE_SETUP_PATTERNS = (
    re.compile(r"^git\s+fetch\b"),
    re.compile(r"^git\s+worktree\s+(add|list|prune)\b"),
    re.compile(r"^mkdir\s+-p\s+\.\./[^;&|]*-worktrees\b"),
)


def deny(reason: str) -> None:
    print(
        json.dumps(
            {
                "hookSpecificOutput": {
                    "hookEventName": "PreToolUse",
                    "permissionDecision": "deny",
                    "permissionDecisionReason": reason,
                }
            }
        )
    )


def in_canonical_srcview_checkout(cwd: Path) -> bool:
    try:
        resolved = cwd.resolve()
    except OSError:
        resolved = cwd
    if not str(resolved).startswith(str(SRCVIEW) + os.sep):
        return False
    if "-worktrees" in resolved.parts:
        return False
    try:
        result = subprocess.run(
            ["git", "rev-parse", "--show-toplevel"],
            cwd=resolved,
            stdout=subprocess.PIPE,
            stderr=subprocess.DEVNULL,
            text=True,
            check=True,
        )
    except (OSError, subprocess.CalledProcessError):
        return False
    repo_root = Path(result.stdout.strip()).resolve()
    return (repo_root / WORKTREE_MARKER).exists()


def shell_words(command: str) -> list[str]:
    try:
        return shlex.split(command)
    except ValueError:
        return []


def is_read_only_shell_command(command: str) -> bool:
    stripped = command.strip()
    if not stripped:
        return True
    if any(pattern.search(stripped) for pattern in WORKTREE_SETUP_PATTERNS):
        return True
    if re.search(r"[;&|<>`$]", stripped):
        return False
    words = shell_words(stripped)
    if not words:
        return False
    command_name = Path(words[0]).name
    if command_name not in READ_ONLY_COMMANDS:
        return False
    if command_name == "git":
        return len(words) >= 2 and words[1] in READ_ONLY_GIT_SUBCOMMANDS
    if command_name == "npm":
        return len(words) >= 2 and words[1] in READ_ONLY_NPM_SUBCOMMANDS
    return True



def command_from_tool_input(payload: dict[str, Any]) -> str:
    tool_input = payload.get("tool_input")
    if isinstance(tool_input, dict):
        command = tool_input.get("command") or tool_input.get("cmd")
        if isinstance(command, str):
            return command
    return ""


def main() -> int:
    try:
        payload = json.load(sys.stdin)
    except json.JSONDecodeError:
        return 0

    cwd = Path(str(payload.get("cwd") or os.getcwd()))
    tool_name = str(payload.get("tool_name") or "")
    if not in_canonical_srcview_checkout(cwd):
        return 0

    if tool_name == "apply_patch":
        deny(
            "Blocked apply_patch in a canonical srcview checkout. Create a "
            "dedicated ../<repo>-worktrees/<branch> worktree first and run the "
            "edit there."
        )
        return 0

    if tool_name == "Bash":
        command = command_from_tool_input(payload)
        if is_read_only_shell_command(command):
            return 0
        deny(
            "Blocked a potentially mutating shell command in a canonical "
            "srcview checkout. Create/use a dedicated ../<repo>-worktrees/"
            "<branch> worktree before repository mutations."
        )
        return 0

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
