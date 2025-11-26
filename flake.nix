{
  description = "TOI Home Manager configuration";

  nixConfig = {
    experimental-features = [
      "flakes"
      "nix-command"
    ];
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    comma.url = "github:nix-community/comma";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager-stable = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    home-manager-unstable = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nix-colors = {
      url = "github:misterio77/nix-colors";
    };
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
    };
    nur = {
      url = "github:nix-community/NUR";
    };
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vscode-server.url = "github:nix-community/nixos-vscode-server";
  };

  outputs = { self, nixpkgs, nixpkgs-stable, nixpkgs-unstable, flake-utils, home-manager-stable, home-manager-unstable, ... }@inputs:
    let
      inherit (self) outputs;
      displayName = "Dave Conroy";
      gn = "dave";
      gnsn = "daveconroy";
      handle = "tiredofit";
      sn = "conroy";

      pkgsForSystem = system: nixpkgsSource: import nixpkgsSource {
        overlays = [
          inputs.comma.overlays.default
          inputs.nur.overlays.default
          outputs.overlays.additions
          outputs.overlays.modifications
          outputs.overlays.stable-packages
          outputs.overlays.unstable-packages
        ];
        inherit system;
      };

      HomeConfiguration = args:
        let
          nixpkgsInput = args.nixpkgs or nixpkgs-stable;
          hmInput = if nixpkgsInput == nixpkgs-unstable then home-manager-unstable else home-manager-stable;
        in
          hmInput.lib.homeManagerConfiguration {
            modules = [
              (import ./home)
              (import ./modules)
            ];
            extraSpecialArgs = {
              inherit (args) nixpkgs;
            } // args.extraSpecialArgs;
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
          "atlas.${gn}" = HomeConfiguration {
            system = "aarch64-linux";
            extraSpecialArgs = {
              org = "toi";
              role = "server";
              displayName = displayName;
              hostname = "atlas" ;
              username = gn;
              networkInterface = "enp6s18";
              inherit inputs outputs;
            };
            nixpkgs = nixpkgs-stable;
          };

          "enigma.${gn}" = HomeConfiguration {
            extraSpecialArgs = {
              org = "toi";
              role = "server";
              displayName = displayName;
              hostname = "enigma";
              username = gn;
              networkInterface = "enp6s18";
              inherit inputs outputs;
            };
            nixpkgs = nixpkgs-stable;
          };

          "entropy.${gn}" = HomeConfiguration {
            extraSpecialArgs = {
              org = "toi";
              role = "server";
              displayName = displayName;
              hostname = "entropy" ;
              username = gn;
              networkInterface = "enp8s0f0np0";
              inherit inputs outputs;
            };
            nixpkgs = nixpkgs-stable;
          };

          "mirage.${gn}" = HomeConfiguration {
            system = "aarch64-linux";
            extraSpecialArgs = {
              org = "toi";
              role = "server";
              displayName = displayName;
              hostname = "mirage";
              username = gn;
              networkInterface = "end0";
              inherit inputs outputs;
            };
            nixpkgs = nixpkgs-stable;
          };

          "nakulaptop" = {
            "${gn}" = HomeConfiguration {
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
                inherit inputs outputs;
              };
              nixpkgs = nixpkgs-stable;
            };
            "ireen" = HomeConfiguration {
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
                inherit inputs outputs;
              };
              nixpkgs = nixpkgs-stable;
            };
          };

          "nomad.${gn}" = HomeConfiguration {
            extraSpecialArgs = {
              org = "toi";
              role = "workstation";
              displayName =  displayName;
              hostname = "nomad";
              username = gn;
              networkInterface = "wlp2s0";
              inherit inputs outputs;
            };
            nixpkgs = nixpkgs-stable;
          };

          "nucleus.${gn}" = HomeConfiguration {
            extraSpecialArgs = {
              org = "toi";
              role = "server";
              displayName = displayName;
              hostname = "nucleus";
              username = gn;
              networkInterface = "null";
              inherit inputs outputs;
            };
            nixpkgs = nixpkgs-stable;
          };
          "seed.${gn}" = HomeConfiguration {
            extraSpecialArgs = {
              org = "toi";
              role = "server";
              displayName = displayName;
              hostname = "seed" ;
              username = gn;
              networkInterface = "enp1s0f0";
              inherit inputs outputs;
            };
            nixpkgs = nixpkgs-stable;
          };
      ##

          "sd.${gnsn}" = HomeConfiguration {
            extraSpecialArgs = {
              org = "sd";
              role = "server";
              displayName = displayName;
              hostname = "server";
              username = gnsn;
              inherit inputs outputs;
            };
          };

          ###
      };

      inherit home-manager-stable home-manager-unstable;
      inherit (home-manager-stable) packages;
    };
}
