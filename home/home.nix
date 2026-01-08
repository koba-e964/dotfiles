{ config, pkgs, ... }:

{
  home.username = builtins.getEnv "USER";
  home.homeDirectory = builtins.getEnv "HOME";

  home.stateVersion = "24.05";

  # programs.zsh.enable = true;
  # programs.git.enable = true;

  home.packages = with pkgs; [
    ripgrep
    fd
  ];
}
