{ config, ... }:

{
    programs.ripgrep = {
        enable = true;
        arguments = [
            "--hidden"
            "--glob=!.git/**"
        ];
    };

    home.sessionVariables.RIPGREP_CONFIG_PATH =
        "${config.xdg.configHome}/ripgrep/ripgreprc";
}
