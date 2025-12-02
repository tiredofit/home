{ config, inputs, lib, pkgs, ... }:
let
  cfg = config.host.home.applications.hyprlock;
## PERSONALIZE
 script_displayhelper_hyprlock = pkgs.writeShellScriptBin "displayhelper_hyprlock" ''
    _get_display_name() {
        ${pkgs.wlr-randr}/bin/wlr-randr --json | ${pkgs.jq}/bin/jq -r --arg desc "$(echo "''${1}" | sed "s|^d/||g")" '.[] | select(.description | test("^(d/)?\($desc)")) | .name'
    }

    if [ -z "''${1}" ]; then exit 1; fi

    case "''${1}" in
        * )
            display_name=$(_get_display_name "''${1}")
            echo "# Automatically Generated" > ''${HOME}/.config/hypr/hyprlock_monitor.conf
            echo "monitor=''${display_name}" >> ''${HOME}/.config/hypr/hyprlock_monitor.conf
            echo "" >> ''${HOME}/.config/hypr/hyprlock_monitor.conf
        ;;
    esac
  '';
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
    home = {
      packages = with pkgs;
        [
          script_displayhelper_hyprlock
        ];
    };

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
              source = "~/.config/hypr/hyprlock_monitor.conf";
            }
          ];

          label = [
            { # Clock
              monitor = "";
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
          "SUPER_SHIFT, X, exec, ${config.host.home.feature.uwsm.prefix}hyprlock"
        ];
      };
    };
  };
}
