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
        source = [
          "../../src/home/dotfiles/hypr/hyprland.conf"
        ];
        misc = {
          animate_manual_resizes = false;
          animate_mouse_windowdragging = false;
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
          force_default_wallpaper = -3;
          new_window_takes_over_fullscreen = 2; # 0 - behind, 1 - takes over, 2 - unfullscreen/unmaxize
          middle_click_paste = true;
        };
      };
    };
  };
}
