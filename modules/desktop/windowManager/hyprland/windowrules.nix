{ config, lib, ... }:
let
  displayServer = config.host.home.feature.gui.displayServer ;
  windowManager = config.host.home.feature.gui.windowManager ;
in
with lib;
{
  config = mkIf (config.host.home.feature.gui.enable && displayServer == "wayland" && windowManager == "hyprland") {
    wayland.windowManager.hyprland = {
      settings = {
        ## See more in modules/applications/* and modules/desktop/utils/*
        windowrulev2 = [
          # IDLE inhibit while watching videos
          #"idleinhibit focus, class:^(mpv|.+exe)$"
          #"idleinhibit focus, class:^(firefox)$, title:^(.*YouTube.*)$"
          #"idleinhibit fullscreen, class:^(firefox)$"

          # XDG-Portal-GTK File Picker annoyances
          "dimaround,title:^Open Files$"
          "float,title:^Open Files$"
          "size 1290 800, title:^Open Files$"

          # ZoomPWA
          "workspace 3,class:(^FFPWA-01HTZ7G5XDG9A8VH9ZNCBBS9RT$)"
          "size 1200 1155,class:(^FFPWA-01HTZ7G5XDG9A8VH9ZNCBBS9RT$)"
          "float,title:^My Meeting$"
          "float,class:(^FFPWA-01HTZ7G5XDG9A8VH9ZNCBBS9RT$)"
        ];
      };
    };
  };
}
