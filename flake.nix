{
  description = "TOI Home Manager configuration";

  nixConfig = {
    experimental-features = [ "nix-command" "flakes" ];
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://nix-gaming.cachix.org"
      "https://hyprland.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
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
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-flake = {
      url = github:gvolpe/neovim-flake;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-colors.url = "github:misterio77/nix-colors";
    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    nixpkgs-wayland = {
      url = "github:nix-community/nixpkgs-wayland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
          (import ./modules)
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
          "beef.dave" = HomeConfiguration {
            extraSpecialArgs = {
              org = "toi";
              role = "workstation";
              hostname = "beef";
              username = "dave";
              displays = 3;
              display_center = "DisplayPort-1";
              display_left = "DisplayPort-2";
              display_right = "HDMI-A-0";
              networkInterface = "wlp10s0";
              inherit inputs outputs;
            };
          };

          "butcher.dave" = HomeConfiguration {
            extraSpecialArgs = {
              org = "toi";
              role = "server";
              hostname = "butcher";
              username = "dave";

              networkInterface = "enp6s18";
              inherit inputs outputs;
            };
          };

          "nakulaptop.dave" = HomeConfiguration {
            extraSpecialArgs = {
              org = "toi";
              role = "workstation";
              hostname = "nakulaptop";
              username = "dave";

              networkInterface = "wlo1";
              inherit inputs outputs;
            };
          };

          "nakulaptop.ireen" = HomeConfiguration {
            extraSpecialArgs = {
              org = "toi";
              role = "workstation";
              hostname = "nakulaptop";
              username = "ireen";
              displays = 1;
              display_center = "eDP";
              networkInterface = "wlo1";
              inherit inputs outputs;
            };
          };

          "selecta.dave" = HomeConfiguration {
            extraSpecialArgs = {
              org = "toi";
              role = "workstation";
              hostname = "selecta";
              username = "dave";
              displays = 1;
              display_center = "HDMI-1";
              networkInterface = "wlo1";
              inherit inputs outputs;
            };
          };

          "selecta.media" = HomeConfiguration {
            extraSpecialArgs = {
              org = "toi";
              role = "workstation";
              hostname = "selecta";
              username = "media";
              displays = 1;
              display_center = "HDMI-1";
              networkInterface = "wlo1";
              inherit inputs outputs;
            };
          };

          "soy.dave" = HomeConfiguration {
            extraSpecialArgs = {
              org = "toi";
              role = "workstation";
              hostname = "soy";
              username = "dave";
              displays = 1;
              networkInterface = "wlo1";
              inherit inputs outputs;
            };
          };

      ##
          "sd111.dave" = HomeConfiguration {
            extraSpecialArgs = {
              org = "sd";
              role = "server";
              inherit inputs outputs;
            };
          };

          "tesla.dave" = HomeConfiguration {
            extraSpecialArgs = {
              org = "sd";
              role = "server";
              inherit inputs outputs;
            };
          };
      };


      inherit home-manager;
      inherit (home-manager) packages;
    };
}
