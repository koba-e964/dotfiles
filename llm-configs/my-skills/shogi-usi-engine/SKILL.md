---
name: shogi-usi-engine
description: Run and control a local USI shogi engine over standard input/output. Use when launching YaneuraOu or another USI engine, sending usi/isready/position/go commands, collecting bestmove/info/checkmate output, or diagnosing USI protocol interactions. Do not hard-code machine-specific engine paths in this skill.
---

# Shogi USI Engine

## Overview

Use this skill when a task needs to run a local shogi engine through the USI protocol.

Do not write a user's engine executable path into this skill. Get the engine path from the user, a local project instruction file, an environment variable, or the current task context.

Most engines should be run with the working directory set to the directory that contains the engine executable. This is important because engines often expect evaluation files, books, or config files relative to their own directory. Use that default unless the user gives a different working directory.

## Quick Run

Use the bundled helper when a position is already available as SFEN:

```sh
uv run --project /Users/kobas-mac/srcview/dotfiles/llm-configs/my-skills/shogi-usi-engine python /Users/kobas-mac/srcview/dotfiles/llm-configs/my-skills/shogi-usi-engine/scripts/usi_analyze.py --engine /path/to/engine --sfen '<sfen>' --go 'go byoyomi 1000'
```

To compare candidate moves, use MultiPV:

```sh
uv run --project /Users/kobas-mac/srcview/dotfiles/llm-configs/my-skills/shogi-usi-engine python /Users/kobas-mac/srcview/dotfiles/llm-configs/my-skills/shogi-usi-engine/scripts/usi_analyze.py --engine /path/to/engine --sfen '<sfen>' --multipv 5 --go 'go byoyomi 1000'
```

To analyze a position after playing moves from the SFEN position, append USI moves:

```sh
uv run --project /Users/kobas-mac/srcview/dotfiles/llm-configs/my-skills/shogi-usi-engine python /Users/kobas-mac/srcview/dotfiles/llm-configs/my-skills/shogi-usi-engine/scripts/usi_analyze.py --engine /path/to/engine --sfen '<sfen>' --moves 6h7g G*4f --go 'go byoyomi 1000'
```

The helper:

- Starts the engine with `cwd` set to `dirname(--engine)` by default.
- Sends `usi` and waits for `usiok`.
- Sends optional `setoption` lines.
- Sends `isready` and waits for `readyok`.
- Sends `usinewgame`, `position sfen ... [moves ...]`, and the requested `go ...`.
- Collects `info` lines until `bestmove`, or `checkmate` for `go mate`.
- Sends `quit` before exiting.

## Comparing Candidate Moves

When the user needs to understand why the best move is best, run MultiPV rather than only a single PV:

```sh
--multipv 5 --go 'go byoyomi 1000'
```

Record the latest stable `info ... multipv N score ... pv ...` lines. Present at least:

- Rank (`multipv`).
- First move.
- Score (`score cp` or `score mate`).
- Main PV.

Use this especially when several moves appear to do the same thing. For example, if several moves recapture the same piece, MultiPV may show that only one recapture keeps the position good.

Scores are from the side to move at the analyzed position. A large gap between the best move and alternatives is often more important for explanation than the exact centipawn number.

## Advancing The Position

Often the human reason for a move becomes clear only after several forced or natural replies. Use `--moves` to analyze positions reached after a candidate line:

```sh
--sfen '<root-sfen>' --moves <move1> <move2> <move3>
```

This sends:

```text
position sfen <root-sfen> moves <move1> <move2> <move3>
```

Use this when checking for clear downstream indicators:

- Material gain or loss after a forcing sequence.
- Mate or no-mate after checks.
- Whether a recapture is possible.
- Whether the king escapes or remains in a forced line.
- Whether a candidate move fails to a tactical reply.

For mate checks at an advanced position, combine `--moves` with `--go 'go mate <milliseconds>'` and inspect `checkmate ...`, `checkmate nomate`, or `checkmate timeout`.

## When To Read The Reference

Read `references/usi-protocol.md` when:

- Writing or debugging custom USI command sequences.
- Interpreting `info`, `score`, `multipv`, `bestmove`, or `checkmate`.
- Using `go infinite`, `go ponder`, `go mate`, or option negotiation.

For routine analysis, the quick run workflow is usually enough.

## Practical Analysis Workflow

1. Obtain SFEN from the position source.
2. Confirm the engine path from user/local context without saving it into this skill.
3. Run the engine from its own directory.
4. Prefer bounded searches for automation, such as `go byoyomi 1000`, `go btime 0 wtime 0 byoyomi 3000`, or engine-supported depth limits.
5. Use `--multipv` when comparing plausible candidate moves.
6. Use `--moves` to inspect important positions inside a PV or refutation.
7. Capture the final `bestmove` and the strongest recent `info ... pv ...` lines.
8. Pass the result to `shogi-position-analysis` for human-readable explanation.

## Notes

- USI communication is line-oriented text over standard input/output.
- Send complete lines ending in newline.
- Always wait for `usiok` after `usi` and `readyok` after `isready`.
- For `go infinite`, send `stop` before expecting `bestmove`.
- For mate solving, send `go mate <milliseconds>` or `go mate infinite` and expect `checkmate ...`.
- Some engines print non-USI startup text. Ignore it until protocol tokens appear, but keep logs for diagnosis.
