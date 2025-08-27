
{ config, lib, pkgs, ... }:

let
  cfg = config.host.home.applications.nwg-displays;
  ## NOTE: workaround for nwg-displays pytest issues
  nwgDisplaysOverlay = self: super: {
    python313Packages = super.python313Packages // {
      i3ipc = super.python313Packages.i3ipc.overrideAttrs (old: {
        doCheck = false;
        checkPhase = ''
          echo "Skipping pytest in Nix build"
        '';
        installCheckPhase = ''
          echo "Skipping install checks in Nix build"
        '';
      });
    };
  };
in
  with lib;
{
  options = {
    host.home.applications.nwg-displays = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Graphical Screen layout manager";
      };
    };
  };

  config = mkIf cfg.enable {
    ##
    nixpkgs.overlays = [ nwgDisplaysOverlay ];
    ##
    home = {
      packages = with pkgs;
        [
          nwg-displays
        ];
    };
  };
}
