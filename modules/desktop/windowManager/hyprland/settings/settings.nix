{ config, inputs, lib, pkgs, ... }:
let
  displayServer = config.host.home.feature.gui.displayServer ;
  windowManager = config.host.home.feature.gui.windowManager ;
in
with lib;
{
  config = mkIf (config.host.home.feature.gui.enable && displayServer == "wayland" && builtins.elem "hyprland" windowManager) {
    wayland.windowManager.hyprland = {
      configType = "lua";
      settings = {
        config = {
          ecosystem = {
            no_update_news = mkDefault true;
            no_donation_nag = mkDefault true;
            enforce_permissions = mkDefault true;
          };
          misc = {
            animate_manual_resizes = mkDefault false;
            animate_mouse_windowdragging = mkDefault false;
            disable_hyprland_logo = mkDefault true;
            disable_splash_rendering = mkDefault true;
            force_default_wallpaper = mkDefault 0;
            on_focus_under_fullscreen = mkDefault 2; # behind, 1 - takes over, 2 - unfullscreen/unmaxize
            middle_click_paste = mkDefault true;
          };
        };
      };
    };
  };
}
