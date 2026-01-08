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

./git/install.sh

# https://nix.dev/manual/nix/2.33/installation/installing-binary
if ! command -v nix >/dev/null; then
    NIX_VERSION=2.33.0
    curl -L https://releases.nixos.org/nix/nix-${NIX_VERSION}/install | sh
fi

# https://nix-community.github.io/home-manager/index.xhtml#sec-install-standalone
nix-channel --add https://github.com/nix-community/home-manager/archive/release-25.11.tar.gz home-manager
# Pinning nixpkgs too
# https://chatgpt.com/share/695f3f60-46f8-8010-a3e9-1e0393a7e259
nix-channel --add https://nixos.org/channels/nixpkgs-25.11-darwin nixpkgs
nix-channel --update
nix-shell '<home-manager>' -A install --extra-experimental-features 'nix-command flakes'

nix profile --extra-experimental-features "nix-command flakes" add nixpkgs#stow

# シンボリックリンクを作成
stow --target="${HOME}" --verbose zsh vscode cargo nix
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

echo "Dotfiles setup complete!"
