{
    enable = true;
    zsh-abbr = {
        enable = true;
        abbreviations = {
            # convenience
            ez = "exec zsh";
            ro = "chmod a-w";
            ll = "ls -l";
            lla = "ls -al";
            dush = "du -sh *";
            dt = "TZ=Asia/Tokyo date";
            genpass = "</dev/urandom LC_ALL=C tr -dc '[:alnum:]' | fold -w 20 | head -n 1";

            # docker
            d = "docker";

            # git
            g = "git";
            gco = "git commit";
            gnew = "git fetch --prune && git switch --detach origin/main";
            ga = "git add";
            gaa = "git add --all";
            gd = "git diff";
            gl = "git log";
            gush = "git push && git push --tags";
            gushf = "git push --force-with-lease --force-if-includes";
            gull = "git pull";
            gt = "git tag";
            gta = "git tag --annotate --sign";
            gdesc = "git describe --tags";
            gsw = "git switch";
            gst = "git status";
            gbr = "git branch";
            gcsh = "git clone --depth=1";
            # gprev = "git switch --detach HEAD~; %1; git switch main";

            # GitHub
            ghpr = "gh pr create";

            # go

            # rust
            rc = "rustc";

            # nix
            nixapply = ''nix run .#home-manager --extra-experimental-features "nix-command flakes" -- switch --flake .#default --impure --extra-experimental-features "nix-command flakes"'';

            # Python
            py = "python3";
        };
    };

    initContent = ''
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
export PATH="/Users/kobas-mac/Downloads/binaryen-version_120_b/bin:''${PATH}"

# gem
export PATH="/opt/homebrew/lib/ruby/gems/3.4.0/bin:''${PATH}"

# https://qiita.com/nishina555/items/63ebd4a508a09c481150
[[ -d ~/.rbenv  ]] && \
  export PATH=''${HOME}/.rbenv/bin:''${PATH} && \
  eval "$(rbenv init -)"

# bun completions
[ -s "/Users/kobas-mac/.bun/_bun" ] && source "/Users/kobas-mac/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
    '';
}
