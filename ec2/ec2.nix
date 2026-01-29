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
            settings = {
                init = {
                    defaultBranch = "main";
                };
                user = {
                    name = "koba-e964";
                    email = "3303362+koba-e964@users.noreply.github.com";
                };
                push = { autoSetupRemote = true; };
            };
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
