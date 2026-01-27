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
        mkPkgs = system: import nixpkgs {
            inherit system;
            config.allowUnfreePredicate = pkg:
                builtins.elem (nixpkgs.lib.getName pkg) [
                    "zsh-abbr"
                ];
        };
        darwinSystem = "aarch64-darwin";
        ec2System = "x86_64-linux";
        pkgsDarwin = mkPkgs darwinSystem;
        pkgsEc2 = mkPkgs ec2System;
    in
    {
        packages.${darwinSystem}.home-manager =
            home-manager.packages.${darwinSystem}.home-manager;
        packages.${ec2System}.home-manager =
            home-manager.packages.${ec2System}.home-manager;

        apps.${darwinSystem}.home-manager = {
            type = "app";
            program = "${self.packages.${darwinSystem}.home-manager}/bin/home-manager";
        };
        apps.${ec2System}.home-manager = {
            type = "app";
            program = "${self.packages.${ec2System}.home-manager}/bin/home-manager";
        };

        homeConfigurations.default =
            home-manager.lib.homeManagerConfiguration {
                pkgs = pkgsDarwin;
                modules = [ ./home/home.nix ];
            };

        homeConfigurations.ec2 =
            home-manager.lib.homeManagerConfiguration {
                pkgs = pkgsEc2;
                modules = [ ./ec2/ec2.nix ];
            };
    };
}
