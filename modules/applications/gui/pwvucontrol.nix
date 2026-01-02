{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.pwvucontrol;
in
  with lib;
{
  options = {
    host.home.applications.pwvucontrol = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Pipewire Graphical Sound Control";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          pwvucontrol
        ];
    };

    wayland.windowManager.hyprland = mkIf (config.host.home.feature.gui.displayServer == "wayland" && config.host.home.feature.gui.windowManager == "hyprland" && config.host.home.feature.gui.enable) {
      settings = {
        windowrule = [
          "float on, match:title ^(pwvucontrol)$"
        ];
      };
    };
  };
}