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
    #nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    comma.url = "github:nix-community/comma";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
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

  outputs = { self, nixpkgs, nixpkgs-unstable, flake-utils, home-manager, ... }@inputs:
    let
      inherit (self) outputs;
      gn = "dave";
      gnsn = "daveconroy";
      handle = "tiredofit";

      pkgsForSystem = system: import nixpkgs {
        overlays = [
          inputs.comma.overlays.default
          inputs.nix-vscode-extensions.overlays.default
          inputs.nur.overlays.default
          outputs.overlays.additions
          outputs.overlays.modifications
          outputs.overlays.unstable-packages
        ];
        inherit system;
      };

      HomeConfiguration = args: home-manager.lib.homeManagerConfiguration (rec {
        modules = [
          (import ./home)
          (import ./modules)
        ];
        extraSpecialArgs = {

        };
        pkgs = pkgsForSystem (args.system or "x86_64-linux");

      } // { inherit (args) extraSpecialArgs; });
    in
      flake-utils.lib.eachSystem [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ]
        (
          system: rec {
          legacyPackages = pkgsForSystem system;
          }
        ) //
      {
        overlays = import ./overlays {inherit inputs;};
        homeConfigurations = {
          "beef.${gn}" = HomeConfiguration {
            extraSpecialArgs = {
              org = "toi";
              role = "workstation";
              hostname = "beef";
              username = gn;
              networkInterface = "wlp10s0";
              inherit inputs outputs;
            };
          };

          "butcher.${gn}" = HomeConfiguration {
            extraSpecialArgs = {
              org = "toi";
              role = "server";
              hostname = "butcher";
              username = gn;
              networkInterface = "enp6s18";
              inherit inputs outputs;
            };
          };

          "cog.${gn}" = HomeConfiguration {
            extraSpecialArgs = {
              org = "toi";
              role = "server";
              hostname = "cog" ;
              username = gn;
              networkInterface = "br0";
              inherit inputs outputs;
            };
          };

          "nakulaptop" = {
            "${gn}" = HomeConfiguration {
              extraSpecialArgs = {
                org = "toi";
                role = "workstation";
                hostname = "nakulaptop";
                username = gn;
                displays = 2;
                display_center = "HDMI-A-0";
                display_right = "eDP";
                networkInterface = "wlo1";
                inherit inputs outputs;
              };
            };
            "ireen" = HomeConfiguration {
              extraSpecialArgs = {
                org = "toi";
                role = "workstation";
                hostname = "nakulaptop";
                username = "ireen";
                displays = 1;
                display_center = "eDP";
                display_right = "HDMI-A-0";
                networkInterface = "wlo1";
                inherit inputs outputs;
              };
            };
          };

          "nomad.${gn}" = HomeConfiguration {
            extraSpecialArgs = {
              org = "toi";
              role = "workstation";
              hostname = "nomad";
              username = gn;
              networkInterface = "wlp2s0";
              inherit inputs outputs;
            };
          };

          "seed.${gn}" = HomeConfiguration {
            extraSpecialArgs = {
              org = "toi";
              role = "server";
              hostname = "seed" ;
              username = gn;
              networkInterface = "enp1s0f0";
              inherit inputs outputs;
            };
          };

          "tentacle.${gn}" = HomeConfiguration {
            system = "aarch64-linux";
            extraSpecialArgs = {
              org = "toi";
              role = "server";
              hostname = "tentacle" ;
              username = gn;
              networkInterface = "enp6s18";
              inherit inputs outputs;
            };
          };

          "expedition.${gn}" = HomeConfiguration {
            extraSpecialArgs = {
              org = "toi";
              role = "server";
              hostname = "expedition" ;
              username = gn;
              networkInterface = "br0";
              inherit inputs outputs;
            };
          };

      ##
          "bell.${gnsn}" = HomeConfiguration {
            extraSpecialArgs = {
              org = "sd";
              role = "server";
              hostname = "bell";
              username = gnsn;
              inherit inputs outputs;
            };
          };

          "edge.${gnsn}" = HomeConfiguration {
            extraSpecialArgs = {
              org = "sd";
              role = "server";
              hostname = "edge";
              username = gnsn;
              inherit inputs outputs;
            };
          };

          "einstein.${gnsn}" = HomeConfiguration {
            system = "aarch64-linux";
            extraSpecialArgs = {
              org = "sd";
              role = "server";
              hostname = "einstein";
              username = gnsn;
              inherit inputs outputs;
            };
          };

          "sd20.${gnsn}" = HomeConfiguration {
            extraSpecialArgs = {
              org = "sd";
              role = "server";
              hostname = "sd20";
              username = gnsn;
              inherit inputs outputs;
            };
          };

          "sd91.${gnsn}" = HomeConfiguration {
            extraSpecialArgs = {
              org = "sd";
              role = "server";
              hostname = "sd91";
              username = gnsn;
              inherit inputs outputs;
            };
          };

          "sd102.${gnsn}" = HomeConfiguration {
            extraSpecialArgs = {
              org = "sd";
              role = "server";
              hostname = "sd102";
              username = gnsn;
              inherit inputs outputs;
            };
          };

          "sd111.${gnsn}" = HomeConfiguration {
            extraSpecialArgs = {
              org = "sd";
              role = "server";
              hostname = "sd111";
              username = gnsn;
              inherit inputs outputs;
            };
          };

          "tesla.${gnsn}" = HomeConfiguration {
            extraSpecialArgs = {
              org = "sd";
              role = "server";
              hostname = "tesla";
              username = gnsn;
              inherit inputs outputs;
            };
          };

          ###

          "lambda-quad.${handle}" = HomeConfiguration {
            extraSpecialArgs = {
              org = "sr";
              role = "server";
              hostname = "lamda-quad";
              username = handle;
              inherit inputs outputs;
            };
          };
      };

      inherit home-manager;
      inherit (home-manager) packages;
    };
}
