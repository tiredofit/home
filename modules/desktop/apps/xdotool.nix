{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.xdotool;
in
  with lib;
{
  options = {
    host.home.applications.xdotool = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Automation";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          xdotool
        ];
    };
  };
}
