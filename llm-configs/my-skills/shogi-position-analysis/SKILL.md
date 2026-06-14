---
name: shogi-position-analysis
description: Analyze shogi positions with a shogi engine and turn engine output into concise human-readable Markdown notes. Use when converting KIF/SFEN positions, running USI engine analysis, interpreting principal variations, or writing explanation notes for a shogi tactic or next-move problem.
---

# Shogi Position Analysis

## Overview

Use this skill when a user wants a shogi position analyzed and summarized for humans.

The core workflow is:

1. Obtain the position in an engine-readable form, usually SFEN.
2. Run a shogi engine with user-provided or locally documented settings.
3. Interpret the engine output and write a concise explanation.

If conversion or engine commands are not known, ask the user for the missing command or example. Once learned, reuse the exact method and document any reusable detail in the appropriate local instruction file.

## KIF Position Diagram To SFEN

For KIF files that contain a displayed position diagram, use the bundled converter:

```sh
uv run --project /Users/kobas-mac/srcview/dotfiles/llm-configs/my-skills/shogi-position-analysis python /Users/kobas-mac/srcview/dotfiles/llm-configs/my-skills/shogi-position-analysis/scripts/kif_position_to_sfen.py /path/to/position.kifu
```

To write a file:

```sh
uv run --project /Users/kobas-mac/srcview/dotfiles/llm-configs/my-skills/shogi-position-analysis python /Users/kobas-mac/srcview/dotfiles/llm-configs/my-skills/shogi-position-analysis/scripts/kif_position_to_sfen.py /path/to/position.kifu --output /path/to/position.sfen
```

The converter reads:

- The 9 KIF diagram rows between `|...|`.
- `先手の持駒：...` and `後手の持駒：...`.
- `先手番` or `後手番`.
- Optional `手数＝N`, emitted as SFEN move number `N + 1`; otherwise move number `1`.

It supports normal pieces, promoted pieces, black/white ownership via `v`, Japanese hand counts such as `歩二`, and SFEN hand order.

The SFEN notation rules are based on the reference article: https://touch-sp.hatenablog.com/entry/2021/06/26/231318

## Position Preparation

- Prefer structured conversion tools over hand-converting KIF by sight.
- Preserve side to move, pieces in hand, promotions, and move number.
- Before trusting analysis, confirm the engine position matches the source position.
- If the input is a diagram or KIF position without moves, convert only the displayed position.

## Engine Analysis

For USI engines, use the `shogi-usi-engine` skill to launch the engine, send `position`/`go`, and collect `info`/`bestmove` output.

Use the engine settings requested by the user. If the user does not specify settings, choose a conservative short analysis first, then deepen only when the first result is ambiguous.

Capture:

- Best move.
- Evaluation or mate score.
- Principal variation.
- Alternative candidate moves when available.
- Whether the result is stable across deeper search, if multiple depths were run.

When comparing plausible alternatives, ask for MultiPV output via `shogi-usi-engine` and summarize the candidate move, score, and PV for each line. This is necessary when the explanation depends on why one natural move is better than another.

When the important explanation is not visible at the root, advance the position with USI `moves` and re-analyze the resulting position. Look for clearer downstream indicators such as material gain, forced recapture, mate, no-mate, or a king escape. Use this to turn "engine says so" into a concrete reason.

For tactical positions, inspect opponent replies. A single PV is often not enough; ask the engine or user-provided tool for likely defenses when the human explanation needs branches.

## Human Explanation

Write the Markdown note for a next-move problem in this style:

```md
▲XXが正解。

- △YYには▲ZZからよい。
- △AAなら▲BBで先手が優勢。
- ▲CCは△DDで失敗する。
```

Guidelines:

- Put the conclusion first.
- Prefer concrete move sequences over generic phrases like "good for sente".
- Explain why the move works: mate, forced material gain, unavoidable threat, king safety, or defense.
- When the engine line is long, summarize the tactical point and include only the critical continuation.
- Do not overstate uncertain analysis. Use `TODO` for unresolved replies or lines that still need checking.
- Keep notation consistent with the source notes, usually Japanese shogi notation such as `▲57桂`.

## Validation

Before finalizing a note:

- Check that the stated best move matches the engine's best move.
- Check that each branch starts from a legal opponent reply to the recommended move.
- Verify any claim of mate, forced win, or failed candidate line with engine output or direct calculation.
- Mention if no engine verification was possible.
