{
  description = "niri debug flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    niri.url = "github:sodiboo/niri-flake";
  };

  outputs = { self, nixpkgs, niri, ... }:
    let
      pkgs = import nixpkgs { inherit (nixpkgs) system; } // {
        system = "x86_64-linux";
      };
      module = niri.homeModules.niri;
    in {
      test = module {
        inherit pkgs;
        lib = pkgs.lib;
        config = { programs.niri = { enable = true; }; };
        # provide upstream helpers expected by the module
        inputs = niri;
        kdl = niri.lib.kdl;
        binds = niri.binds;
        settings = niri.settings;
        docs = niri.docs;
      };
    };
}
