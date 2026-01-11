{
    description = "dotfiles (home-manager, macOS)";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = { self, nixpkgs, home-manager, ... }:
    let
        system = "aarch64-darwin";
        pkgs = import nixpkgs {
            inherit system;
            config.allowUnfreePredicate = pkg:
                builtins.elem (nixpkgs.lib.getName pkg) [
                    "zsh-abbr"
                ];
        };
    in
    {
        packages.${system}.home-manager = home-manager.packages.${system}.home-manager;

        apps.${system}.home-manager = {
            type = "app";
            program = "${self.packages.${system}.home-manager}/bin/home-manager";
        };

        homeConfigurations.default =
            home-manager.lib.homeManagerConfiguration {
                inherit pkgs;
                modules = [ ./home/home.nix ];
            };
    };
}
