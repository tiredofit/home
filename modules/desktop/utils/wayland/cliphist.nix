{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.cliphist;
in
  with lib;
{
  options = {
    host.home.applications.cliphist = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Wayland clipboard history";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          cliphist
        ];
    };

    wayland.windowManager.hyprland = mkIf (config.host.home.feature.gui.displayServer == "wayland" && config.host.home.feature.gui.windowManager == "hyprland" && config.host.home.feature.gui.enable) {
      settings = {
        exec-once = [
          "${config.host.home.feature.uwsm.prefix}wl-paste --type text --watch cliphist store"  # Stores only text data
          "${config.host.home.feature.uwsm.prefix}wl-paste --type image --watch cliphist store" # Stores only image data
        ];
      };
    };
  };
}
