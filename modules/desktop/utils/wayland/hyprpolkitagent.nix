{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.hyprpolkitagent;
in
  with lib;
{
  options = {
    host.home.applications.hyprpolkitagent = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Polkit authentication agent written in QT/QML";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          hyprpolkitagent
        ];
    };

    wayland.windowManager.hyprland = mkIf (config.host.home.feature.gui.displayServer == "wayland" && config.host.home.feature.gui.windowManager == "hyprland" && config.host.home.feature.gui.enable) {
      settings = {
        exec-once = [
          "systemctl --user start hyprpolkitagent"
        ];
      };
    };
  };
}
