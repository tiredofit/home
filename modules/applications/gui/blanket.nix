{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.blanket;
in
  with lib;
{
  options = {
    host.home.applications.blanket = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Noise generator";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          blanket
        ];
    };

    wayland.windowManager.hyprland = mkIf (config.host.home.feature.gui.displayServer == "wayland" && config.host.home.feature.gui.windowManager == "hyprland" && config.host.home.feature.gui.enable) {
      settings = {
        windowrule = [
          "float on, size 920 684, match:title ^(Blanket)$"
        ];
      };
    };
  };
}
