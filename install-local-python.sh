#!/bin/sh
set -eu

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
VENV_DIR="${HOME}/local_python"
REQ_FILE="${SCRIPT_DIR}/python/requirements-local_python.txt"
REQUIRED_PYTHON="${REQUIRED_PYTHON:-$(cat "${SCRIPT_DIR}/.python-version")}"
PYTHON_BIN="${PYTHON_BIN:-python${REQUIRED_PYTHON}}"

if [ ! -f "${REQ_FILE}" ]; then
    echo "requirements file not found: ${REQ_FILE}" >&2
    exit 1
fi

if ! command -v "${PYTHON_BIN}" >/dev/null 2>&1; then
    echo "required interpreter not found: ${PYTHON_BIN}" >&2
    echo "install Python ${REQUIRED_PYTHON} or set PYTHON_BIN to a compatible interpreter" >&2
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
    "${PYTHON_BIN}" -m venv "${VENV_DIR}"
fi

"${VENV_DIR}/bin/python" -m ensurepip --upgrade
"${VENV_DIR}/bin/python" -m pip install --upgrade "pip==26.0.1"
"${VENV_DIR}/bin/python" -m pip install --require-hashes --requirement "${REQ_FILE}"
