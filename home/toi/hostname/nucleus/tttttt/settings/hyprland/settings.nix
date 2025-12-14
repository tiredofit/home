{ config, inputs, lib, pkgs, ... }:
let
  displayServer = config.host.home.feature.gui.displayServer ;
  windowManager = config.host.home.feature.gui.windowManager ;
in
with lib;
{
  config = mkIf (config.host.home.feature.gui.enable && displayServer == "wayland" && windowManager == "hyprland") {
    wayland.windowManager.hyprland = {
      settings = {
        exec-once = [
          "${config.host.home.feature.uwsm.prefix}virt-manager"
          "${config.host.home.feature.uwsm.prefix}kitty"
          "${config.host.home.feature.uwsm.prefix}firefox"
        ];
      };
    };
  };
}
