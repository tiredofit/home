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
        general = {
        };

        cursor = {
          inactive_timeout = mkDefault 10;
          hide_on_key_press = mkDefault true;
        };

        decoration = {
          blur = {
          };

          shadow = {
          };
        };

        animations = {
          animation = mkDefault [
          ];
          bezier = mkDefault [
          ];
        };
      };
    };
  };
}
