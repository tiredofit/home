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

    wayland.windowManager.hyprland = {
      settings = {
        windowrule = [
          "float, ^(Zoom Workplace)$"
          "float, ^(zoom)$"
        ];

        windowrulev2 = [
          #"size 360 690,title:^Zoom - Licensed Account$,class:(^Zoom)$"
          #"float,title:^Zoom - Licensed Account$"
          #"noanim,class:(^Zoom)$"
          #"nodim,class:(^Zoom)$"
          #"noblur,class:(^Zoom)$"
          #"float,title:^as_toolbar$,class:(^Zoom)$"
          #"noborder,title:^as_toolbar$,class:(^Zoom)$"
          #"noshadow,title:^as_toolbar$,class:(^Zoom)$"
          #"noblur,title:^as_toolbar$,class:(^Zoom)$"
          #"minsize 1 1, title:^(Zoom Workplace.*)$, class:^(Zoom Workplace)$"
          #"minsize 1 1, title:^(menu window)$, class:^(Zoom Workplace)$"
          #"minsize 1 1, title:^(meeting bottombar popup)$, class:^(Zoom Workplace)$"
          #"minsize 1 1, title:^(Zoom Workplace.*)$, class:^(zoom)$"
          #"minsize 1 1, title:^(menu window)$, class:^(zoom)$"
          #"minsize 1 1, title:^(meeting bottombar popup)$, class:^(zoom)$"
          #"move onscreen cursor, title:^(Zoom Workplace)$, class:^(zoom)$"
          #"move onscreen cursor, title:^(menu window)$, class:^(zoom)$"
          #"move onscreen cursor, title:^(meeting bottombar popup)$, class:^(zoom)$"
          #"move onscreen cursor, title:^(Zoom Workplace)$, class:^(Zoom Workplace)$"
          #"move onscreen cursor, title:^(menu window)$, class:^(Zoom Workplace)$"
          #"move onscreen cursor, title:^(meeting bottombar popup)$, class:^(Zoom Workplace)$"
          #"stayfocused, title:^(menu window)$, class:^(Zoom Workplace)$"
          #"stayfocused, title:^(meeting bottombar popup)$, class:^(Zoom Workplace)$"
          #"stayfocused, title:^(menu window)$, class:^(zoom)$"
          #"stayfocused, title:^(meeting bottombar popup)$, class:^(zoom)$"
        ];
      };
    };

    xdg.mimeApps.defaultApplications = mkIf cfg.defaultApplication.enable (
      lib.genAttrs cfg.defaultApplication.mimeTypes (_: "us.zoom.Zoom.desktop")
    );
  };
}