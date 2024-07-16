{ config, inputs, lib, pkgs, specialArgs, ... }:
let
  inherit (specialArgs) display_center;
  cfg = config.host.home.applications.hyprlock;
in
  with lib;
{
  options = {
    host.home.applications.hyprlock = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Hyprland Lock screen";
      };
    };
  };

  config = mkIf cfg.enable {
    programs = {
      hyprlock = {
        enable = true;
        package = pkgs.hyprlock;
        settings = {
          "$entry_background_color" = "rgba(43434341)";
          "$entry_border_color" = "rgba(21212125)";
          "$entry_color" = "rgba(C6C6C6FF)";
          "$font_family" = "Noto Sans NF";
          "$font_family_clock" = "Noto Sans NF";
          "$font_symbols" = "Noto Sans NF";
          "$text_color" = "rgba(E2E2E2FF)";

          background = [
            {
              blur_passes = 4;
              blur_size = 5;
              color = "rgba(25, 20, 20, 1.0)";
              path = "screenshot";
            }
          ];

          input-field = [
            {
              monitor = "${display_center}";
              size = "350, 50";
              outline_thickness = 4;
              dots_size = 0.1;
              dots_spacing = 0.5;
              outer_color = "$entry_border_color";
              inner_color = "$entry_background_color";
              font_color = "$entry_color";
              fade_on_empty = true;
              position = "0, 20";
              halign = "center";
              valign = "center";
            }
          ];

          label = [
            { # Clock
              monitor = "${display_center}";
              text = "cmd[update:1000] date +'%Y-%m-%d %H:%M:%S'";
              shadow_passes = 1;
              shadow_boost = 0.5;
              color = "$text_color";
              font_size = 20;
              font_family = "$font_family_clock";
              position = "30, 10";
              halign = "left";
              valign = "bottom";
            }

            { # "Locked" text
              monitor = "";
              text = " Locked";
              shadow_passes = 1;
              shadow_boost = 0.5;
              color = "$text_color";
              font_size = 16;
              font_family = "$font_family";
              position = "80, 55";
              halign = "left";
              valign = "bottom";
            }
          ];
        };
      };
    };

    wayland.windowManager.hyprland = mkIf (config.host.home.feature.gui.displayServer == "wayland" && config.host.home.feature.gui.windowManager == "hyprland" && config.host.home.feature.gui.enable) {
      settings = {
        bind = [
          "SUPER_SHIFT, X, exec, hyprlock"
        ];
      };
    };
  };
}
