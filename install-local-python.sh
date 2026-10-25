#!/bin/sh
set -eu

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
PROJECT_DIR="${SCRIPT_DIR}/python/local"

if ! command -v uv >/dev/null 2>&1; then
    echo "uv not found in PATH" >&2
    echo "install uv before running ${0##*/}" >&2
    exit 1
fi

# Select the personal environment explicitly, regardless of the active venv.
UV_PROJECT_ENVIRONMENT="${HOME}/local_python" uv sync \
    --project "${PROJECT_DIR}" \
    --locked \
    --no-dev \
    --no-install-project
