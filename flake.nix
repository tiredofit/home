{
  description = "TOI Home Manager configuration";

   nixConfig = {
     experimental-features = [ "nix-command" "flakes" ];
     extra-trusted-public-keys = [
       "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
       "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
       "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
     ];
   };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    comma.url = "github:nix-community/comma";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland/v0.28.0";
    hyprwm-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-flake = {
      url = github:gvolpe/neovim-flake;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-colors.url = "github:misterio77/nix-colors";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
    nur.url = "github:nix-community/NUR";
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, home-manager, ... }@inputs:
    let
      inherit (self) outputs;
      pkgsForSystem = system: import nixpkgs {
        overlays = [
          inputs.comma.overlays.default
          inputs.nur.overlay
          inputs.nix-vscode-extensions.overlays.default
          inputs.nixpkgs-wayland.overlay
        ];
        inherit system;
      };

      HomeConfiguration = args: home-manager.lib.homeManagerConfiguration (rec {
        modules = [
          (import ./home)
        ];
        extraSpecialArgs = { };
        pkgs = pkgsForSystem (args.system or "x86_64-linux");
      } // { inherit (args) extraSpecialArgs; });
    in
      flake-utils.lib.eachSystem [ "x86_64-linux" "aarch64-linux" ] (system: rec {
        legacyPackages = pkgsForSystem system;
      }) //
      {
        homeConfigurations = {
          beef = HomeConfiguration {
            extraSpecialArgs = {
              org = "toi";
              role = "workstation";
              hostname = "beef";
              displays = 3;
              networkInterface = "wlp10s0";
              windowmanager = "x-i3";
              inherit inputs outputs;
            };
          };

          butcher = HomeConfiguration {
            extraSpecialArgs = {
              displays = 1;
              networkInterface = "enp6s18";
              inherit inputs outputs;
            };
          };

          selecta = HomeConfiguration {
            extraSpecialArgs = {
              displays = 1;
              networkInterface = "wlo1";
              windowmanager = "x-cinnamon";
              inherit inputs outputs;
            };
          };

          soy = HomeConfiguration {
            extraSpecialArgs = {
              displays = 1;
              networkInterface = "wlo1";
              windowmanager = "x-cinnamon";
              inherit inputs outputs;
            };
          };
      };

      inherit home-manager;
      inherit (home-manager) packages;
    };
}
