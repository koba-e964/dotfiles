{ config, pkgs, ... }:

{
    home.username = builtins.getEnv "USER";
    home.homeDirectory = builtins.getEnv "HOME";

    home.stateVersion = "24.05";
    home.sessionPath = [
        "$HOME/.cargo/bin"
    ];

    programs = {
        zsh = import ./zsh;
        git = import ./git;
        ripgrep = {
            enable = true;
            arguments = [
                "--hidden"
                "--glob=!.git/**"
                "--glob=!.env/**"
            ];
        };
    };

    home.sessionVariables.RIPGREP_CONFIG_PATH =
        "${config.xdg.configHome}/ripgrep/ripgreprc";

    home.packages = with pkgs; [
        fd
        stow
    ];
}
