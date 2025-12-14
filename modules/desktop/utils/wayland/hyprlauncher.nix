{ config, inputs, lib, pkgs, ... }:
let
  cfg = config.host.home.applications.hyprlauncher;
in
  with lib;
{
  options = {
    host.home.applications.hyprlauncher = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "HyprLauncher";
      };
    };
  };

  config = mkIf cfg.enable {
    services = {
      hyprlauncher = {
        enable = true;
        package = pkgs.hyprlauncher;

        settings = {
        };
      };
    };

    wayland.windowManager.hyprland = mkIf (config.host.home.feature.gui.displayServer == "wayland" && config.host.home.feature.gui.windowManager == "hyprland" && config.host.home.feature.gui.enable) {
      settings = {
        bind = [
          "SUPER, T, exec, ${config.host.home.feature.uwsm.prefix}hyprlauncher"
        ];
      };
    };
  };
}
