{ config, lib, ... }:
let
  displayServer = config.host.home.feature.gui.displayServer ;
  windowManager = config.host.home.feature.gui.windowManager ;
in
with lib;
{
  config = mkIf (config.host.home.feature.gui.isHyprland) {
    wayland.windowManager.hyprland = {
      settings = {



        ### See more in modules/applications/* and modules/desktop/utils/*
        window_rule = [
          # XDG-Portal-GTK File Picker annoyances
          {
            dim_around = true;
            float = true;
            size = "1290 800";
            match = {
              title = "^Open Files$";
            };
          }

          # Generics
          {
            float = true;
            match = {
              class = "^(xdg-desktop-portal-hyprland)$";
            };
          }
          {
            float = true;
            match = {
              class = "(hyprland-share-picker)";
            };
          }
          {
            float = true;
            match = {
              class = "^()$";
              title = "^(File Operation Progress)$";
            };
          }
          {
            suppress_event = "maximize";
            match = {
              class = ".*";
            };
          }

          # Position
          {
            float = true;
            match = {
              class = "^(Viewnior)$";
            };
          }
          {
            float = true;
            match = {
              class = "^(confirm)$";
            };
          }
          {
            float = true;
            match = {
              class = "^(confirmreset)$";
            };
          }
          {
            float = true;
            match = {
              class = "^(dialog)$";
            };
          }
          {
            float = true;
            size = "800 600";
            match = {
              class = "^(download)$";
            };
          }
          {
            float = true;
            match = {
              class = "^(error)$";
            };
          }
          {
            float = true;
            match = {
              class = "^(file_progress)$";
            };
          }
          {
            float = true;
            match = {
              class = "^(notification)$";
            };
          }
          {
            float = true;
            match = {
              class = "^(org.kde.polkit-kde-authentication-agent-1)$";
            };
          }
          {
            float = true;
            match = {
              class = "^(pavucontrol)$";
            };
          }
          {
            float = true;
            match = {
              title = "^(Confirm to replace files)";
            };
          }
          {
            float = true;
            match = {
              title = "^(DevTools)$";
            };
          }
          {
            float = true;
            match = {
              title = "^(File Operation Progress)";
            };
          }
          {
            float = true;
            match = {
              title = "^(Media viewer)$";
            };
          }
          {
            float = true;
            size = "800 600";
            match = {
              title = "^(Open File)$";
            };
          }
          {
            float = true;
            size = "800 600";
            match = {
              title = "^(Volume Control)$";
            };
          }
          {
            float = true;
            match = {
              title = "^(branchdialog)$";
            };
          }
          {
            size = "800 600";
            match = {
              title = "^(Save File)$";
            };
          }
          {
            float = true;
            size = "800 600";
            match = {
              initial_title = "^(Print)$";
            };
          }
        ];
      };
    };
  };
}
