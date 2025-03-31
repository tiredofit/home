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
        windowrule = [
          # IDLE inhibit while watching videos
          #"idleinhibit focus, class:^(mpv|.+exe)$"
          #"idleinhibit focus, class:^(firefox)$, title:^(.*YouTube.*)$"
          #"idleinhibit fullscreen, class:^(firefox)$"

          # XDG-Portal-GTK File Picker annoyances
          "dimaround,title:^Open Files$"
          "float,title:^Open Files$"
          "size 1290 800, title:^Open Files$"

          # ZoomPWA
          "workspace 3,initialClass:(^chrome-fdbibeljcgcjkpedilpdafnjdmbjjjep-zoom$)"
          "size 1200 1155,initialClass:(^chrome-fdbibeljcgcjkpedilpdafnjdmbjjjep-zoom$)"
          "float,title:^My Meeting$"
          "float,initialClass:(^chrome-fdbibeljcgcjkpedilpdafnjdmbjjjep-zoom$)"
        ];
      };
    };
  };
}
