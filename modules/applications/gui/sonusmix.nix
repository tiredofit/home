{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.sonusmix;
in
  with lib;
{
  options = {
    host.home.applications.sonusmix = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Graphical Pipewire/Wireplumber Router";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          sonusmix
        ];
    };

    wayland.windowManager.hyprland = mkIf (config.host.home.feature.gui.displayServer == "wayland" && config.host.home.feature.gui.windowManager == "hyprland" && config.host.home.feature.gui.enable) {
      settings = {
        exec-once = [
          "${config.host.home.feature.uwsm.prefix}sonusmix"
        ];
      };
    };
  };
}