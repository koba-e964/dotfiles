#!/bin/sh
set -eu

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
VENV_DIR="${HOME}/local_python"
REQ_FILE="${SCRIPT_DIR}/python/requirements-local_python.txt"

if [ ! -f "${REQ_FILE}" ]; then
    echo "requirements file not found: ${REQ_FILE}" >&2
    exit 1
fi

if [ ! -x "${VENV_DIR}/bin/python" ]; then
    python3 -m venv "${VENV_DIR}"
fi

"${VENV_DIR}/bin/python" -m pip install --upgrade "pip==26.0.1"
"${VENV_DIR}/bin/python" -m pip install --require-hashes -r "${REQ_FILE}"
