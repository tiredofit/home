{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.blueman;
in
  with lib;
{
  options = {
    host.home.applications.blueman = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Graphical Bluetooth Manager";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          blueman
        ];
    };

    wayland.windowManager.hyprland = mkIf ((config.host.home.feature.gui.displayServer == "wayland" && config.host.home.feature.gui.windowManager == "hyprland" && config.host.home.feature.gui.enable)) {
      settings = {
        windowrule = [
          "float, class:^(blueman-manager)$"
        ];
      };
    };
  };
}
