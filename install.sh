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
        git openssl@3 git-lfs yq jq go git-crypt binutils binwalk openssh ghc graphviz llvm python@3 nodebrew sqlite rbenv ruby-build xz \
        uv ruby gnupg
else
    # Linux
    true
fi
if ! command -v rustup >/dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

if [ "$(uname)" == "Darwin" ]; then
    ./install-local-python.sh
fi

./git/install.sh

# https://nix.dev/manual/nix/2.33/installation/installing-binary
if ! command -v nix >/dev/null; then
    NIX_VERSION=2.33.0
    curl -L https://releases.nixos.org/nix/nix-${NIX_VERSION}/install | sh
    source /etc/zshrc
fi

nix run .#home-manager --extra-experimental-features "nix-command flakes" -- switch --flake .#default --impure --extra-experimental-features "nix-command flakes"

# シンボリックリンクを作成
stow --target="${HOME}" --verbose vscode cargo nix skills
ln -sf ${DIR}/git/.gitconfig ~/.gitconfig

# VSCode extensions
# https://note.com/teitei_tk/n/n7204cb8d97c5
if command -v code >/dev/null; then
    for line in $(cat ./vscode-scripts/extensions);
    do
        code --install-extension $line
    done
    code --list-extensions >vscode-scripts/extensions
fi

if podman machine list --format json | jq --exit-status 'length == 0'; then
    podman machine init
    podman machine start
fi

echo "Dotfiles setup complete!"
