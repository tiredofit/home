{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.swayidle;
in
  with lib;
{
  options = {
    host.home.applications.swayidle = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Sway Idle Monitor";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          swayidle
        ];
    };
  };
}
