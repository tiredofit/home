{
  description = "TOI Home Manager configuration";

  nixConfig = {
    experimental-features = [
      "flakes"
      "nix-command"
    ];
    extra-substituters = [
      "https://hyprland.cachix.org"
      "https://nix-community.cachix.org"
      "https://nix-gaming.cachix.org"
      "https://nixpkgs-wayland.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
    ];
  };

  inputs = {
    #nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    comma.url = "github:nix-community/comma";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      #url = "github:nix-community/home-manager/release-24.05";
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    #hyprland = {
    ##url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    #  type = "git";
    #  submodules = true;
    #  url = "https://github.com/hyprwm/Hyprland";
    #  ref = "refs/tags/v0.43.0";
    #  inputs.aquamarine.follows = "aquamarine";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};
#
    #aquamarine = {
    #  type = "git";
    #  url = "https://github.com/hyprwm/aquamarine";
    #  ref = "refs/tags/v0.4.0";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};

    #hyprland-contrib = {
    #  url = "github:hyprwm/contrib";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};
    #hyprland-plugins = {
    #  url = "github:hyprwm/hyprland-plugins";
    #  inputs.hyprland.follows = "hyprland";
    #};
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-colors = {
      url = "github:misterio77/nix-colors";
    };
    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
    };
    nixpkgs-wayland = {
      url = "github:nix-community/nixpkgs-wayland";
      inputs.nixpkgs.follows = "nixpkgs";
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
          #inputs.nixpkgs-wayland.overlay
          inputs.nur.overlay
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
        "x86_64-darwin"
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
              displays = 3;
              display_center = "DP-2";
              display_left = "DP-3";
              display_right = "HDMI-A-1";
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
