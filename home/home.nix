{ config, pkgs, ... }:

{
    imports = [
        ./ripgrep
    ];

    home.username = builtins.getEnv "USER";
    home.homeDirectory = builtins.getEnv "HOME";

    home.stateVersion = "24.05";
    home.sessionPath = [
        "$HOME/.cargo/bin"
    ];

    programs = {
        zsh = import ./zsh;
        git = import ./git;
        zoxide = {
            enable = true;
        };
    };

    home.packages = with pkgs; [
        fd
        stow
        pre-commit
    ];
}
