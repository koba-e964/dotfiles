if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

  autoload -Uz compinit
  compinit
fi

# https://qiita.com/mikan3rd/items/d41a8ca26523f950ea9d

# git-promptの読み込み
source ~/.zsh/git-prompt.sh

# git-completionの読み込み
fpath=(~/.zsh $fpath)
zstyle ':completion:*:*:git:*' script ~/.zsh/git-completion.bash
autoload -Uz compinit && compinit

# プロンプトのオプション表示設定
GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
GIT_PS1_SHOWSTASHSTATE=true
GIT_PS1_SHOWUPSTREAM=auto

# プロンプトの表示設定(好きなようにカスタマイズ可)
setopt PROMPT_SUBST ; PS1='%F{green}%n@%m%f: %F{cyan}%~%f %F{red}$(__git_ps1 "(%s)")%f
\$ '

export GPG_TTY=$(tty)
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
export PATH="/opt/homebrew/opt/openssl@3/bin:$PATH"

# Go configuration
export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOBIN
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"

# dotnet
export PATH=$PATH:/usr/local/share/dotnet

# nodebrew
export PATH=$HOME/.nodebrew/current/bin:$PATH

# pyvenv
source $HOME/local_python/bin/activate
export PATH="/opt/homebrew/opt/postgresql@16/bin:$PATH"

# binaryen
export PATH="/Users/kobas-mac/Downloads/binaryen-version_120_b/bin:${PATH}"

# cargo
. "$HOME/.cargo/env"
