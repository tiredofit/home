{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.devenv;
in
  with lib;
{
  options = {
    host.home.applications.devenv = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Development environments made easier";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          devenv
        ];
    };
  };
}
