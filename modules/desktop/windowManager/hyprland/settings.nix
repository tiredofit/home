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
        misc = {
          animate_manual_resizes = mkDefault false;
          animate_mouse_windowdragging = mkDefault false;
          disable_hyprland_logo = mkDefault true;
          disable_splash_rendering = mkDefault true;
          force_default_wallpaper = mkDefault "-3";
          on_focus_under_fullscreen = mkDefault 2; # behind, 1 - takes over, 2 - unfullscreen/unmaxize
          middle_click_paste = mkDefault true;
        };
      };
    };
  };
}
