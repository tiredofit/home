{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.shikane;
in
  with lib;
{
  options = {
    host.home.applications.shikane = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = " Dynamic display configuration";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          shikane
        ];
    };

    wayland.windowManager.hyprland = mkIf (config.host.home.feature.gui.displayServer == "wayland" && config.host.home.feature.gui.windowManager == "hyprland" && config.host.home.feature.gui.enable) {
      settings = {
        exec = [
          "systemctl --user restart shikane.service"
        ];
        #exec-once = [
        #  "systemctl --user start shikane.service"
        #];
        exec-once = [
          "shikane"
        ];
      };
    };
  };
}
