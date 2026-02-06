#!/usr/bin/env bash
set -euo pipefail

base=${1:-"$HOME/.codex/config.base.toml"}
trust=${2:-"$HOME/.codex/config.trust.toml"}
out=${3:-"$HOME/.codex/config.toml"}

if [[ ! -f "$base" ]]; then
  echo "missing base: $base" >&2
  exit 1
fi
if [[ ! -f "$trust" ]]; then
  echo "missing trust: $trust" >&2
  exit 1
fi

cat "$base" "$trust" > "$out"
