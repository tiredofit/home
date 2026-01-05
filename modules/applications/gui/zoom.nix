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

    wayland.windowManager.hyprland = mkIf (config.host.home.feature.gui.displayServer == "wayland" && config.host.home.feature.gui.windowManager == "hyprland" && config.host.home.feature.gui.enable) {
      settings = {
        windowrule = [
          "opaque on, float on, match:class (Zoom Workplace)"
          "stay_focused on, match:class (Zoom Workplace), match:initial_title (menu window)"

          # Sharing Toolbar
          "float on, border_size 0, no_shadow on, stay_focused on, pin on, match:class ^(Zoom Workplace)$, match:title ^(as_toolbar)$"

          # Main Zoom Landing Window
          "float on, size 660 530, center on, match:class ^(Zoom Workplace)$, match:title ^(Zoom Workplace - Licensed account)$"

          # Zoom Workplace Settings
          "float on, match:class ^(Zoom Workplace)$, match:title ^(Settings)$"

          # Zoom Workplace Menu Windows
          # Audio Settings, Video Settings, Gallery View etc..
          "float on, size 300 600, stay_focused on, center on, match:class ^(Zoom Workplace)$, match:title ^(menu window)$"

          # Zoom Meeting Info Window
          # Zoom Workplace Top Bar Popups
          "float on, border_size 0, no_shadow on, center on, stay_focused on, size 485 442, match:class ^(Zoom Workplace)$, match:title ^(meeting topbar popup)$"

          # Zoom Workplace Bottom Bar Popups
          # Zoom Reactions
          "float on, border_size 0, no_shadow on, center on, stay_focused on, size 285 90, match:class ^(Zoom Workplace)$, match:title ^(meeting bottombar popup)$"
          # Captions Window, Breakout Room Creation, etc
          "float on, border_size 0, no_shadow on, center on, match:class ^(Zoom Workplace)$, match:title ^(zoom)$"
          # Participants Window (Detached)
          "float on, size 490 550, center on, match:class ^(Zoom Workplace)$, match:title ^(Participants)(.*)$"
          # Chat Window (Detached)
          "float on, size 490 550, center on, match:class ^(Zoom Workplace)$, match:title ^(Meeting chat)$"
        ];
      };
    };

    xdg.mimeApps.defaultApplications = mkIf cfg.defaultApplication.enable (
      lib.genAttrs cfg.defaultApplication.mimeTypes (_: "us.zoom.Zoom.desktop")
    );
  };
}
