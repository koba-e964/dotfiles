{ config, ... }:

{
    programs.ripgrep = {
        enable = true;
        arguments = [
            "--hidden"
            "--glob=!.git/**"
            "--glob=!.env/**"
        ];
    };

    home.sessionVariables.RIPGREP_CONFIG_PATH =
        "${config.xdg.configHome}/ripgrep/ripgreprc";
}
