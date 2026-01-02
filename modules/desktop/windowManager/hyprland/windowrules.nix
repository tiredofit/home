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
          "dim_around on, float on, size 1290 800, match:title ^Open Files$"

          # Generics
          "float on, match:class ^(xdg-desktop-portal-hyprland)$"
          "float on, match:class (hyprland-share-picker)"
          "float on, match:class ^()$, match:title ^(File Operation Progress)$"
          "suppress_event maximize, match:class .*"

          # Position
          "float on, match:class ^(Viewnior)$"
          "float on, match:class ^(confirm)$"
          "float on, match:class ^(confirmreset)$"
          "float on, match:class ^(dialog)$"
          "float on, size 800 600, match:class ^(download)$"
          "float on, match:class ^(error)$"
          "float on, match:class ^(file_progress)$"
          "float on, match:class ^(notification)$"
          "float on, match:class ^(org.kde.polkit-kde-authentication-agent-1)$"
          "float on, match:class ^(pavucontrol)$"
          "float on, match:title ^(Confirm to replace files)"
          "float on, match:title ^(DevTools)$"
          "float on, match:title ^(File Operation Progress)"
          "float on, match:title ^(Media viewer)$"
          "float on, size 800 600, match:title ^(Open File)$"
          "float on, size 800 600, match:title ^(Volume Control)$"
          "float on, match:title ^(branchdialog)$"
          "size 800 600, match:title ^(Save File)$"
          "float on, size 800 600, match:initial_title ^(Print)$"
        ];
      };
    };
  };
}
