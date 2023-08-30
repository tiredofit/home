{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.picom;
in
  with lib;
{
  options = {
    host.home.applications.picom = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Compositor and effects";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          picom
        ];
    };

    services = {
      picom = {
        enable = false;
        settings = {
          shadow = true;
          no-dnd-shadow = true;
          no-dock-shadow = true;
          shadow-radius = 7;
          shadow-offset-x = -7;
          shadow-offset-y = -7;
          shadow-opacity = 0.7;
          shadow-red = 0.0;
          shadow-green = 0.0;
          shadow-blue = 0.0;
          shadow-exclude = [
            "name = 'Notification'"
            "class_g = 'Conky'"
            "class_g ?= 'Notify-osd'"
            "class_g = 'Cairo-clock'"
          ];
          shadow-ignore-shaped = false;
          xinerama-shadow-crop = false;
          opacity = 0.8;
          inactive-opacity = 0.8;
          active-opacity = 1.0;
          frame-opacity = 0.7;
          inactive-opacity-override = false;
          alpha-step = 0.06;
          inactive-dim = 0.0;
          blur-kern = "3x3box";
          blur-background-exclude = [
            "window_type = 'dock'"
            "window_type = 'desktop'"
          ];
          fading = true;
          fade-in-step = 0.03;
          fade-out-step = 0.03;
          fade-exclude = [ ];

          mark-wmwin-focused = true;
          mark-ovredir-focused = true;
          detect-rounded-corners = true;
          detect-client-opacity = true;
          backend = "glx";
          vsync = false;
          dbe = false;
          paint-on-overlay = true;
          focus-exclude = [
            "class_g = 'Cairo-clock'"
          ];
          detect-transient = true;
          detect-client-leader = true;
          invert-color-include = [ ];
          glx-copy-from-front = false;
          use-damage = false;
          wintypes = {
            tooltip = {
              tooltip = {
                fade=true;
                shadow=true;
                opacity=0.95;
                focus=true;
                full-shadow=false;
              };
              popup_menu = {
                opacity=1.0;
              };
              dropdown_menu = {
                opacity=1.0;
              };
              utility = {
                shadow=false;
                opacity=1.0;
              };
            };
          };
          class_g = "zoom";
        };
      };
    };
  };
}
