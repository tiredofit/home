{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.wlogout;
in
  with lib;
{
  options = {
    host.home.applications.wlogout = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Wayland Logout Menu";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          wlogout
        ];
    };

    wayland.windowManager.hyprland = mkIf (config.host.home.feature.gui.displayServer == "wayland" && config.host.home.feature.gui.windowManager == "hyprland" && config.host.home.feature.gui.enable) {
      settings = {
        bind = [
          "SUPER_SHIFT, E, exec, pkill wlogout || wlogout"
        ];
      };
    };
  };
}
