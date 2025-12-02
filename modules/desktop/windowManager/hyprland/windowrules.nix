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
          # XDG-Portal-GTK File Picker annoyances
          "dimaround,title:^Open Files$"
          "float,title:^Open Files$"
          "size 1290 800, title:^Open Files$"

          # Generics
          "float,class:^(xdg-desktop-portal-hyprland)$"
          "float,class:^()$,title:^(File Operation Progress)$"
          "suppressevent maximize, class:.*"

          # Position
          "float,class:^(Viewnior)$"
          "float,class:^(confirm)$"
          "float,class:^(confirmreset)$"
          "float,class:^(dialog)$"
          "float,class:^(download)$"
          "float,class:^(error)$"
          "float,class:^(file_progress)$"
          "float,class:^(notification)$"
          "float,class:^(org.kde.polkit-kde-authentication-agent-1)$"
          "float,class:^(pavucontrol)$"
          "float,title:^(Confirm to replace files)"
          "float,title:^(DevTools)$"
          "float,title:^(File Operation Progress)"
          "float,title:^(Media viewer)$"
          "float,title:^(Open File)$"
          "float,title:^(Picture-in-Picture)$"
          "float,title:^(Volume Control)$"
          "float,title:^(branchdialog)$"

          # Size
          "size 800 600,class:^(download)$"
          "size 800 600,title:^(Open File)$"
          "size 800 600,title:^(Save File)$"
          "size 800 600,title:^(Volume Control)$"

          # Test
          "float, initialTitle:^(Print)$"
          "size 800 600,initialTitle:^(Print)$"
        ];
      };
    };
  };
}
