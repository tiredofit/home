{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.nwg-displays;
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
    home = {
      packages = with pkgs;
        [
          nwg-displays
        ];
    };
  };
}
