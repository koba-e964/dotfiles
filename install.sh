#!/bin/sh
set -eu

DIR=`realpath $(dirname $0)`

# 必要なツールをインストール
if [ "$(uname)" == "Darwin" ]; then
    # macOS
    if ! command -v brew >/dev/null; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    brew install --quiet \
        git openssl@3 git-lfs yq jq go git-crypt binutils binwalk openssh ghc graphviz llvm python@3 nodebrew sqlite rbenv ruby-build xz
else
    # Linux
    true
fi
if ! command -v rustup >/dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

./git/install.sh

# https://nix.dev/manual/nix/2.33/installation/installing-binary
if ! command -v nix >/dev/null; then
    NIX_VERSION=2.33.0
    curl -L https://releases.nixos.org/nix/nix-${NIX_VERSION}/install | sh
fi

nix profile add nixpkgs#stow --extra-experimental-features nix-command --extra-experimental-features flakes

# シンボリックリンクを作成
stow --target="${HOME}" --verbose zsh vscode
ln -sf ${DIR}/git/.gitconfig ~/.gitconfig

echo "Dotfiles setup complete!"
