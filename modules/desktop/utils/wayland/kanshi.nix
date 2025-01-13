{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.kanshi;
in
  with lib;
{
  options = {
    host.home.applications.kanshi = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = " Dynamic display configuration";
      };
    };
  };

  config = mkIf cfg.enable {
    services.kanshi = {
      enable = true;
    };

    wayland.windowManager.hyprland = mkIf (config.host.home.feature.gui.displayServer == "wayland" && config.host.home.feature.gui.windowManager == "hyprland" && config.host.home.feature.gui.enable) {
      settings = {
        exec = [
          "systemctl --user restart kanshi.service"
        ];
        #exec-once = [
        #  "systemctl --user start kanshi.service"
        #];
        exec-once = [
          "kanshi"
        ];
      };
    };
  };
}
