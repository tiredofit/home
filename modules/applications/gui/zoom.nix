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
          "opaque,  class:(Zoom Workplace)"
          "float,   class:(Zoom Workplace)"

          "stayfocused,class:(Zoom Workplace),initialTitle:(menu window)"
          # Zoom Workplace Screen Sharing

          # Sharing Toolbar
          "unset,class:^(Zoom Workplace)$,title:^(as_toolbar)$"
          "float,class:^(Zoom Workplace)$,title:^(as_toolbar)$"
          "noborder,class:^(Zoom Workplace)$,title:^(as_toolbar)$"
          "noshadow,class:^(Zoom Workplace)$,title:^(as_toolbar)$"
          #"move 930 85,class:^(Zoom Workplace)$,title:^(as_toolbar)$"
          "stayfocused,class:^(Zoom Workplace)$,title:^(as_toolbar)$"
          "pin,class:^(Zoom Workplace)$,title:^(as_toolbar)$"
          # Zoom Workplace Screen Sharing
          # Green Border Selection
          #"float,title:^(cpt_frame_xcb_window)$"
          #"noborder,title:^(cpt_frame_xcb_window)$"

          # Zoom Workplace
          # Main Zoom Landing Window
          "float,class:^(Zoom Workplace)$,title:^(Zoom Workplace - Licensed account)$"
          "size 660 530,class:^(Zoom Workplace)$,title:^(Zoom Workplace - Licensed account)$"
          "center,class:^(Zoom Workplace)$,title:^(Zoom Workplace - Licensed account)$"

          # Zoom Workplace Settings
          "float,class:^(Zoom Workplace)$,title:^(Settings)$"

          # Zoom Workplace Menu Windows
          # Audio Settings, Video Settings, Gallery View etc..
          "float,class:^(Zoom Workplace)$,title:^(menu window)$"
          "size 300 600,class:^(Zoom Workplace)$,title:^(menu window)$"
          "stayfocused,class:^(Zoom Workplace)$,title:^(menu window)$"
          "center,class:^(Zoom Workplace)$,title:^(menu window)$"

          # Zoom Workplace Top Bar Popups
          # Zoom Meeting Info Window
          "float,class:^(Zoom Workplace)$,title:^(meeting topbar popup)$"
          "noborder,class:^(Zoom Workplace)$,title:^(meeting topbar popup)$"
          "noshadow,class:^(Zoom Workplace)$,title:^(meeting topbar popup)$"
          "center,class:^(Zoom Workplace)$,title:^(meeting topbar popup)$"
          "stayfocused,class:^(Zoom Workplace)$,title:^(meeting topbar popup)$"
          "size 485 442,class:^(Zoom Workplace)$,title:^(meeting topbar popup)$"

          # Zoom Workplace Bottom Bar Popups
          # Zoom Reactions
          "float,class:^(Zoom Workplace)$,title:^(meeting bottombar popup)$"
          "noborder,class:^(Zoom Workplace)$,title:^(meeting bottombar popup)$"
          "noshadow,class:^(Zoom Workplace)$,title:^(meeting bottombar popup)$"
          "center,class:^(Zoom Workplace)$,title:^(meeting bottombar popup)$"
          "stayfocused,class:^(Zoom Workplace)$,title:^(meeting bottombar popup)$"
          "size 285 90,class:^(Zoom Workplace)$,title:^(meeting bottombar popup)$"

          # Zoom Workplace Misc
          # Captions Window, Breakout Room Creation, etc
          "float,class:^(Zoom Workplace)$,title:^(zoom)$"
          "noborder,class:^(Zoom Workplace)$,title:^(zoom)$"
          "noshadow,class:^(Zoom Workplace)$,title:^(zoom)$"
          "center,class:^(Zoom Workplace)$,title:^(zoom)$"

          # Zoom Workplace
          # Participants Window (Detached)
          "float,class:^(Zoom Workplace)$,title:^(Participants)(.*)$"
          "size 490 550,class:^(Zoom Workplace)$,title:^(Participants)(.*)$"
          "center,class:^(Zoom Workplace)$,title:^(Participants)(.*)$"

          # Zoom Workplace
          # Chat Window (Detached)
          "float,class:^(Zoom Workplace)$,title:^(Meeting chat)$"
          "size 490 550,class:^(Zoom Workplace)$,title:^(Meeting chat)$"
          "center,class:^(Zoom Workplace)$,title:^(Meeting chat)$"
        ];
      };
    };

    xdg.mimeApps.defaultApplications = mkIf cfg.defaultApplication.enable (
      lib.genAttrs cfg.defaultApplication.mimeTypes (_: "us.zoom.Zoom.desktop")
    );
  };
}
