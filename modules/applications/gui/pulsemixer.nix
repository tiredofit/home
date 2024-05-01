{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.pulsemixer;
in
  with lib;
{
  options = {
    host.home.applications.pulsemixer = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Graphical Sound Control";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          pulsemixer
          pavucontrol
        ];
    };

    wayland.windowManager.hyprland = mkIf (config.host.home.feature.gui.displayServer == "wayland" && config.host.home.feature.gui.windowManager == "hyprland" && config.host.home.feature.gui.enable) {
      settings = {
        windowrulev2 = [
          "float,title: ^(pavucontrol)$"
        ];
      };
    };
  };
}