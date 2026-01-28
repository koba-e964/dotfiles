{ config, pkgs, ... }:

{
    home.username = builtins.getEnv "USER";
    home.homeDirectory = builtins.getEnv "HOME";

    home.stateVersion = "24.05";

    programs = {
        tmux = {
            enable = true;
        };
        zsh = import ./zsh;
        git = {
            enable = true;
        };
        gh = {
            enable = true;
        };
    };
    home.packages = with pkgs; [
        codex
        fd
        ripgrep
        stow
        pre-commit
        go
        cargo
        util-linux
    ];
}
