#!/bin/sh
set -eu

DIR=`realpath $(dirname $0)`

# 必要なツールをインストール
if [ "$(uname)" == "Darwin" ]; then
    # macOS
    if ! command -v brew >/dev/null; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    brew install git openssl@3 git-lfs yq jq go git-crypt binutils binwalk openssh ghc python@3 nodebrew sqlite rbenv ruby-build
else
    # Linux
    true
fi
if ! command -v rustup; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

./vscode/install.sh
./git/install.sh

# シンボリックリンクを作成
ln -sf ${DIR}/zsh/.zshrc ~/.zshrc
ln -sf ${DIR}/git/.gitconfig ~/.gitconfig

echo "Dotfiles setup complete!"
