{
  description = "TOI Home Manager configuration";

  nixConfig = {
    experimental-features = [
      "flakes"
      "nix-command"
    ];
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://niri.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
    ];
  };

  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    comma.url = "github:nix-community/comma";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager-stable = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    home-manager-unstable = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
    };
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    android-sdk = {
      url = "github:tadfisher/android-nixpkgs/stable";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    danksearch = {
      url = "github:AvengeMedia/danksearch";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    dms = {
      url = "github:AvengeMedia/DankMaterialShell";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    dms-plugin-registry = {
      url = "github:AvengeMedia/dms-plugin-registry";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    vscode-server.url = "github:nix-community/nixos-vscode-server";
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-stable, nixpkgs-unstable, flake-utils, home-manager-stable, home-manager-unstable, ... }@inputs:
    let
      identity = import ./lib/identity.nix;
      inherit (identity) displayName gn;

      pkgsForSystem = system: nixpkgsSource:
        let
          localOverlays = import ./overlays { inherit inputs; };
        in import nixpkgsSource {
          overlays = (
            [
              inputs.comma.overlays.default
              inputs.nur.overlays.default
              inputs.android-sdk.overlays.default
              inputs.niri.overlays.niri
            ] ++ builtins.attrValues localOverlays
          );
          inherit system;
        };

      HomeConfiguration = args:
        let
          nixpkgsInput = args.nixpkgs or nixpkgs-stable;
          hmInput = if nixpkgsInput == nixpkgs-unstable then home-manager-unstable else home-manager-stable;
        in
          hmInput.lib.homeManagerConfiguration {
            modules = [
              inputs.stylix.homeModules.default
              (import ./home)
              (import ./modules)
            ];
            extraSpecialArgs = { inherit (args) nixpkgs; } // args.extraSpecialArgs;
            pkgs = pkgsForSystem (args.system or "x86_64-linux") nixpkgsInput;
          };

    in flake-utils.lib.eachSystem [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ] (system: {
      legacyPackages = pkgsForSystem system nixpkgs;
    }) // {
        overlays = import ./overlays {inherit inputs;};
        homeConfigurations = {
          "${gn}@atlas" = HomeConfiguration {
            system = "aarch64-linux";
            extraSpecialArgs = {
              org = "toi";
              role = "server";
              displayName = displayName;
              hostname = "atlas" ;
              username = gn;
              networkInterface = "enp6s18";
              inherit inputs;
            };
            nixpkgs = nixpkgs-unstable;
          };

          "${gn}@enigma" = HomeConfiguration {
            extraSpecialArgs = {
              org = "toi";
              role = "server";
              displayName = displayName;
              hostname = "enigma";
              username = gn;
              networkInterface = "enp6s18";
              inherit inputs;
            };
            nixpkgs = nixpkgs-unstable;
          };

          "${gn}@entropy" = HomeConfiguration {
            extraSpecialArgs = {
              org = "toi";
              role = "server";
              displayName = displayName;
              hostname = "entropy" ;
              username = gn;
              networkInterface = "enp8s0f0np0";
              inherit inputs;
            };
            nixpkgs = nixpkgs-unstable;
          };

          "${gn}@nakulaptop" = HomeConfiguration {
            extraSpecialArgs = {
              org = "toi";
              role = "workstation";
              displayName = displayName;
              hostname = "nakulaptop";
              username = gn;
              displays = 2;
              display_center = "HDMI-A-0";
              display_right = "eDP";
              networkInterface = "wlo1";
              inherit inputs;
            };
            nixpkgs = nixpkgs-stable;
          };
          "ireen@nakulaptop" = HomeConfiguration {
            extraSpecialArgs = {
              org = "toi";
              role = "workstation";
              displayName = displayName;
              hostname = "nakulaptop";
              username = "ireen";
              displays = 1;
              display_center = "eDP";
              display_right = "HDMI-A-0";
              networkInterface = "wlo1";
              inherit inputs;
            };
            nixpkgs = nixpkgs-stable;
          };

          "${gn}@nomad" = HomeConfiguration {
            extraSpecialArgs = {
              org = "toi";
              role = "workstation";
              displayName =  displayName;
              hostname = "nomad";
              username = gn;
              networkInterface = "wlp2s0";
              inherit inputs;
            };
            nixpkgs = nixpkgs-unstable;
          };
          "tttttt@nucleus" = HomeConfiguration {
            extraSpecialArgs = {
              org = "toi";
              role = "server";
              displayName = displayName;
              hostname = "nucleus";
              username = "tttttt";
              networkInterface = "null";
              inherit inputs;
            };
            nixpkgs = nixpkgs-unstable;
          };
      };
      inherit home-manager-stable home-manager-unstable;
      inherit (home-manager-stable) packages;
    };
}
