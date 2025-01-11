#!/bin/sh
set -eu

# VSCode has to be installed already.

# https://github.com/mrsekut/dotfiles/blob/master/vscode/settings/index.sh
CURRENT=$(cd $(dirname $0) && pwd)
VSCODE_SETTING_DIR=~/Library/Application\ Support/Code/User
BACKUP_FILE="$CURRENT/backup_settings.json"
COMMAND_NAME="vscode/install.sh"

if [ ! -d "${VSCODE_SETTING_DIR}" ]; then
  echo "${COMMAND_NAME}: VSCode setting directory not found"
  exit 0
fi

backup() {
  if [ -f "${VSCODE_SETTING_DIR}/settings.json" ]; then
    cp "${VSCODE_SETTING_DIR}/settings.json" "${BACKUP_FILE}"
    echo "${COMMAND_NAME}: Backup created"
  fi
}

create_symlink() {
  rm -f "${VSCODE_SETTING_DIR}/settings.json"
  ln -s "${CURRENT}/settings.json" "${VSCODE_SETTING_DIR}/settings.json"
  echo "${COMMAND_NAME}: Symlink created"
}

backup && create_symlink
