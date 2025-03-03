{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.steam-run;
in
  with lib;
{
  options = {
    host.home.applications.steam-run = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Wrapper to allow FHS executibles";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          steam-run
        ];
    };
  };
}
