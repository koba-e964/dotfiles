---
name: heuristic-contest
description: Build and maintain local evaluation harnesses for AtCoder Heuristic Contest and similar heuristic contest repositories. Use when creating multi-case runners, scorer binaries, baseline-vs-candidate comparison scripts, score summaries, or when working under AHC generative-AI rules that require reporting execution results before making further solution changes.
---

# Heuristic Contest

## Overview

Use this skill for local contest tooling around heuristic solvers, especially AHC repositories with official `tools` crates and visualizer/scorer code.

## Safety Rules

- Respect repository-specific AHC generative-AI rules first.
- If a solution program is executed, report the results and stop before improving the solution based on those results unless the user gives a new explicit instruction.
- Separate harness/tooling edits from solver heuristic edits.
- Prefer Rust for contest tooling unless the repository clearly uses another language.

## Multi-Case Scorer

When the official tools crate exposes scoring helpers, add a dedicated binary rather than duplicating visualizer logic.

Typical path:

```text
tools/src/bin/multi_cases.rs
```

Preferred structure:

- Import `tools::*`.
- Reuse `parse_input`, `parse_output`, and `compute_score`.
- Read zero-padded case files such as `0000.txt`.
- Print CSV per-case rows plus summary rows.
- Write one generation's CSV to `results/NN.csv`; use a separate compare command for old/new analysis.
- Include `total`, `average`, and population `stddev` summary rows.

Scorer CLI shape:

```sh
tools/target/release/multi_cases tools/in tools/out/multi_cases 0 29
```

CSV columns:

```text
case,score,ops,status
```

Save generation CSVs outside `tools/`:

```sh
tools/target/release/multi_cases tools/in "$OUT_DIR" 0 29 > "results/${GEN}.csv"
```

## Compare Command

Add a separate comparison binary for saved CSV files:

```text
tools/src/bin/compare.rs
```

CLI shape:

```sh
tools/target/release/compare results/002.csv results/003.csv
```

Compare saved per-case rows by case id and print a human-readable paired summary. Include:

- old/new total and total delta
- average delta
- standard deviation of per-case deltas
- standard error of per-case deltas
- t value
- win/loss/same counts
- total operation counts and operation delta
- largest gains and losses by case

Do not require old/new output directories for comparison once `results/NN.csv` files exist.

## Batch Runner

For a 30-case local runner, add a small POSIX shell script at the repository root, usually `run_30.sh`.

Script behavior:

- Compile the solver once.
- Build the scorer binary only if `tools/target/release/multi_cases` is missing or non-executable.
- Execute the scorer binary directly; avoid `cargo run --release` in repeated local testing because its startup overhead is avoidable.
- Run cases `0000` through `0029`.
- Write temporary outputs outside the repository, such as under `${TMPDIR:-/tmp}`.
- Save the generation CSV to `results/NN.csv`.

Canonical shape:

```sh
#!/bin/sh
set -eu

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <generation-number>" >&2
    exit 1
fi

GEN="$1"
OUT_DIR="${TMPDIR:-/tmp}/ahc-run-${GEN}"
RESULT_CSV="results/${GEN}.csv"

rustc --cfg local a.rs -O
if [ ! -x tools/target/release/multi_cases ] || [ ! -x tools/target/release/compare ]; then
    (cd tools && cargo build --release --bin multi_cases --bin compare)
fi
mkdir -p "$OUT_DIR"
mkdir -p results

i=0
while [ "$i" -le 29 ]; do
    case_id=$(printf "%04d" "$i")
    ./a <"tools/in/${case_id}.txt" >"${OUT_DIR}/${case_id}.txt"
    i=$((i + 1))
done

tools/target/release/multi_cases tools/in "$OUT_DIR" 0 29 >"$RESULT_CSV"
cat "$RESULT_CSV"
```

Usage:

```sh
./run_30.sh 003
tools/target/release/compare results/002.csv results/003.csv
```

## Compare Wrapper

Add a root-level `compare.sh` wrapper so saved generations are easy to compare.

Required behavior:

- `./compare.sh 002 003` compares `results/002.csv` against `results/003.csv`.
- `./compare.sh 003` compares the previous generation, preserving the same zero-padding width: `results/002.csv` against `results/003.csv`.
- Validate that generation arguments are numeric.
- Check both CSV files exist before invoking the Rust binary.
- Build `tools/target/release/compare` only when the executable is missing.

Canonical shape:

```sh
#!/bin/sh
set -eu

usage() {
    echo "Usage: $0 <new-generation>" >&2
    echo "       $0 <old-generation> <new-generation>" >&2
    exit 1
}

is_digits() {
    case "$1" in
        '' | *[!0-9]*) return 1 ;;
        *) return 0 ;;
    esac
}

if [ "$#" -eq 1 ]; then
    NEW="$1"
    is_digits "$NEW" || usage
    WIDTH=${#NEW}
    OLD=$(awk -v n="$NEW" -v w="$WIDTH" 'BEGIN { if (n + 0 <= 0) exit 1; printf "%0*d", w, n - 1 }') || exit 1
elif [ "$#" -eq 2 ]; then
    OLD="$1"
    NEW="$2"
    is_digits "$OLD" || usage
    is_digits "$NEW" || usage
else
    usage
fi

OLD_CSV="results/${OLD}.csv"
NEW_CSV="results/${NEW}.csv"

[ -f "$OLD_CSV" ] || { echo "missing old CSV: $OLD_CSV" >&2; exit 1; }
[ -f "$NEW_CSV" ] || { echo "missing new CSV: $NEW_CSV" >&2; exit 1; }

if [ ! -x tools/target/release/compare ]; then
    (cd tools && cargo build --release --bin compare)
fi

tools/target/release/compare "$OLD_CSV" "$NEW_CSV"
```

## Validation

For harness-only changes:

- Run `rustfmt` on Rust scorer files.
- Run `cargo build --release --bin multi_cases --bin compare` inside `tools`.
- Run `sh -n run_30.sh`.
- Run `sh -n compare.sh` when adding the compare wrapper.
- Do not run the solver unless the user requested execution; if you do run it, stop after reporting results under AHC rules.

## Git Notes

Always commit harness changes under `tools/`, including scorer binaries such as `tools/src/bin/multi_cases.rs` and `tools/src/bin/compare.rs`.

If `tools/` is ignored, force-add the intended scorer source explicitly:

```sh
git add -f tools/src/bin/multi_cases.rs
```
