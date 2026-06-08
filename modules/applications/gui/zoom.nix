{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.zoom;
in
  with lib;
{
  options = {
    host.home.applications.zoom = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Video Conferencing";
      };
      defaultApplication = {
        enable = mkOption {
          description = "MIME default application configuration";
          type = with types; bool;
          default = false;
        };
        mimeTypes = mkOption {
          description = "MIME types to be the default application for";
          type = types.listOf types.str;
          default = [
            "x-scheme-handler/zoomtg"
          ];
        };
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          zoom-us
        ];
    };

    wayland.windowManager.hyprland = mkIf (config.host.home.feature.gui.displayServer == "wayland" && builtins.elem "hyprland" config.host.home.feature.gui.windowManager && config.host.home.feature.gui.enable) {
      settings = {
        window_rule = [
          {
            opaque = true;
            float = true;
            match = {
              class = "(Zoom Workplace)";
            };
          }
          {
            stay_focused = true;
            match = {
              class = "(Zoom Workplace)";
              initial_title = "(menu window)";
            };
          }

          # Sharing Toolbar
          {
            float = true;
            border_size = 0;
            no_shadow = true;
            stay_focused = true;
            pin = true;
            match = {
              class = "^(Zoom Workplace)$";
              title = "^(as_toolbar)$";
            };
          }

          # Main Zoom Landing Window
          {
            float = true;
            size = "660 530";
            center = true;
            match = {
              class = "^(Zoom Workplace)$";
              title = "^(Zoom Workplace - Licensed account)$";
            };
          }

          # Zoom Workplace Settings
          {
            float = true;
            match = {
              class = "^(Zoom Workplace)$";
              title = "^(Settings)$";
            };
          }

          # Zoom Workplace Menu Windows
          # Audio Settings, Video Settings, Gallery View etc..
          {
            float = true;
            size = "300 600";
            stay_focused = true;
            center = true;
            match = {
              class = "^(Zoom Workplace)$";
              title = "^(menu window)$";
            };
          }

          # Zoom Meeting Info Window
          # Zoom Workplace Top Bar Popups
          {
            float = true;
            border_size = 0;
            no_shadow = true;
            center = true;
            stay_focused = true;
            size = "485 442";
            match = {
              class = "^(Zoom Workplace)$";
              title = "^(meeting topbar popup)$";
            };
          }

          # Zoom Workplace Bottom Bar Popups
          # Zoom Reactions
          {
            float = true;
            border_size = 0;
            no_shadow = true;
            center = true;
            stay_focused = true;
            size = "285 90";
            match = {
              class = "^(Zoom Workplace)$";
              title = "^(meeting bottombar popup)$";
            };
          }
          # Captions Window, Breakout Room Creation, etc
          {
            float = true;
            border_size = 0;
            no_shadow = true;
            center = true;
            match = {
              class = "^(Zoom Workplace)$";
              title = "^(zoom)$";
            };
          }
          # Participants Window (Detached)
          {
            float = true;
            size = "490 550";
            center = true;
            match = {
              class = "^(Zoom Workplace)$";
              title = "^(Participants)(.*)$";
            };
          }
          # Chat Window (Detached)
          {
            float = true;
            size = "490 550";
            center = true;
            match = {
              class = "^(Zoom Workplace)$";
              title = "^(Meeting chat)$";
            };
          }
        ];
      };
    };

    xdg.mimeApps.defaultApplications = mkIf cfg.defaultApplication.enable (
      lib.genAttrs cfg.defaultApplication.mimeTypes (_: "us.zoom.Zoom.desktop")
    );
  };
}
