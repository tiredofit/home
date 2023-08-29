{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.gnome-system-monitor;
in
  with lib;
{
  options = {
    host.home.applications.gnome-system-monitor = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Gnome System Monitor";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          gnome.gnome-system-monitor
        ];
    };
  };
}
