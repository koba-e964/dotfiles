#!/bin/sh
set -eu

# https://qiita.com/mikan3rd/items/d41a8ca26523f950ea9d
mkdir -p ~/.zsh

curl -sS -o ~/.zsh/git-prompt.sh https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh
curl -sS -o ~/.zsh/git-completion.bash https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
curl -sS -o ~/.zsh/_git https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.zsh
