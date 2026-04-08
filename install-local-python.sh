#!/bin/sh
set -eu

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
VENV_DIR="${HOME}/local_python"
REQUIRED_PYTHON="${REQUIRED_PYTHON:-$(cat "${SCRIPT_DIR}/.python-version")}"
PYTHON_BIN="${PYTHON_BIN:-python${REQUIRED_PYTHON}}"

if ! command -v "${PYTHON_BIN}" >/dev/null 2>&1; then
    echo "required interpreter not found: ${PYTHON_BIN}" >&2
    echo "install Python ${REQUIRED_PYTHON} or set PYTHON_BIN to a compatible interpreter" >&2
    exit 1
fi

if ! command -v uv >/dev/null 2>&1; then
    echo "uv not found in PATH" >&2
    echo "install uv before running ${0##*/}" >&2
    exit 1
fi

TARGET_PYTHON_VERSION=$("${PYTHON_BIN}" -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')
if [ "${TARGET_PYTHON_VERSION}" != "${REQUIRED_PYTHON}" ]; then
    echo "python version mismatch: expected ${REQUIRED_PYTHON}, got ${TARGET_PYTHON_VERSION}" >&2
    exit 1
fi

if [ -x "${VENV_DIR}/bin/python" ]; then
    VENV_PYTHON_VERSION=$("${VENV_DIR}/bin/python" -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')
    if [ "${VENV_PYTHON_VERSION}" != "${TARGET_PYTHON_VERSION}" ]; then
        echo "recreating ${VENV_DIR}: Python ${VENV_PYTHON_VERSION} -> ${TARGET_PYTHON_VERSION}" >&2
        rm -rf "${VENV_DIR}"
    fi
fi

if [ ! -x "${VENV_DIR}/bin/python" ]; then
    uv venv --python "${PYTHON_BIN}" "${VENV_DIR}"
fi

VIRTUAL_ENV="${VENV_DIR}" uv sync \
    --active \
    --project "${SCRIPT_DIR}" \
    --locked \
    --only-group local \
    --no-default-groups \
    --no-dev \
    --no-install-project
