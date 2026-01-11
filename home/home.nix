{ config, pkgs, ... }:

{
    home.username = builtins.getEnv "USER";
    home.homeDirectory = builtins.getEnv "HOME";

    home.stateVersion = "24.05";

    programs = {
        zsh = import ./zsh;
        git = import ./git;
    };

    home.packages = with pkgs; [
        ripgrep
        fd
        stow
    ];
}
