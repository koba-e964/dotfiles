{ config, pkgs, ... }:

{
    home.username = builtins.getEnv "USER";
    home.homeDirectory = builtins.getEnv "HOME";

    home.stateVersion = "24.05";

    programs = {
        tmux = {
            enable = true;
        };
    };
    home.packages = with pkgs; [
        codex
        fd
        git
        ripgrep
        stow
        pre-commit
    ];
}
