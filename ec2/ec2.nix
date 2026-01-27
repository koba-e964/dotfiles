{ config, pkgs, ... }:

{
    home.packages = with pkgs; [
        codex
        fd
        git
        ripgrep
        stow
        termux
        pre-commit
    ];
}
