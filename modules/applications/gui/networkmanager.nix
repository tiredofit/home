{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.networkmanager;
in
  with lib;
{
  options = {
    host.home.applications.networkmanager = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Network Manager GUI";
      };
      systemtray.enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Enable starting applet in system tray";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          networkmanagerapplet
        ];
    };

    wayland.windowManager.hyprland = mkIf ((cfg.systemtray.enable) && (config.host.home.feature.gui.displayServer == "wayland" && config.host.home.feature.gui.windowManager == "hyprland" && config.host.home.feature.gui.enable)) {
      settings = {
        exec-once = [
          "${config.host.home.feature.uwsm.prefix}nm-applet"
        ];
      };
    };
  };
}
