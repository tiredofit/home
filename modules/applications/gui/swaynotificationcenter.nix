{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.sway-notification-center;
in
  with lib;
{
  options = {
    host.home.applications.sway-notification-center = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Notification Center for Wayland";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          swaynotificationcenter
        ];
    };
  };
}
