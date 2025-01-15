{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.wl-gammarelay-rs;
in
  with lib;
{
  options = {
    host.home.applications.wl-gammarelay-rs = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Wayland Monitor Gamma Adjustment";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          wl-gammarelay-rs
        ];
    };

    wayland.windowManager.hyprland = mkIf (config.host.home.feature.gui.displayServer == "wayland" && config.host.home.feature.gui.windowManager == "hyprland" && config.host.home.feature.gui.enable) {
      settings = {
        exec-once = [
          "${config.host.home.feature.uwsm.prefix}wl-gammarelay-rs ; sleep 1; ${config.host.home.feature.uwsm.prefix}busctl --user set-property rs.wl-gammarelay / rs.wl.gammarelay Temperature q 3000"
        ];
      };
    };
  };
}
