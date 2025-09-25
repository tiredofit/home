{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.lnav;
in
  with lib;
{
  options = {
    host.home.applications.lnav = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Log Navigator";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          lnav
        ];
    };
  };
}
