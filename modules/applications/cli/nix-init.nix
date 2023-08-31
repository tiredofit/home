{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.nix-init;
in
  with lib;
{
  options = {
    host.home.applications.nix-init = {
      enable = mkOption {
        default = true;
        type = with types; bool;
        description = "Quickly bootstrap a nix package definition from URLs";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
        packages = with pkgs;
          [
            nix-init
          ];
    };
  };
}
