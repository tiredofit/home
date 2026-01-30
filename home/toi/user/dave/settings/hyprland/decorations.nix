{ config, inputs, lib, pkgs, ... }:
let
  displayServer = config.host.home.feature.gui.displayServer ;
  windowManager = config.host.home.feature.gui.windowManager ;
in
with lib;
{
  config = mkIf (config.host.home.feature.gui.enable && displayServer == "wayland" && windowManager == "hyprland") {
    wayland.windowManager.hyprland = {
      settings = {
        general = {
          allow_tearing = mkDefault true;
          border_size = mkDefault 2;
          gaps_in = mkDefault 2;
          gaps_out = mkDefault 5;
          layout = mkDefault "master";
          resize_corner = mkDefault 2;
          resize_on_border = mkDefault true;
        };

        cursor = {
          inactive_timeout = mkDefault 10;
          hide_on_key_press = mkDefault true;
        };

        master = {
          allow_small_split = mkDefault true;
          drop_at_cursor = mkDefault true;
          mfact = mkDefault 0.55;
          new_on_top = mkDefault true;
          new_status = mkDefault "master";
          orientation = mkDefault "center";
          smart_resizing = mkDefault true;
        };

        decoration = {
          blur = {
            enabled = mkDefault true;
            brightness = mkDefault 1;
            contrast = mkDefault 1.0;
            ignore_opacity = mkDefault true;
            new_optimizations = mkDefault true;
            passes = mkDefault 3;
            popups = mkDefault true;
            size = mkDefault 4;
            vibrancy = mkDefault 0.50;
            vibrancy_darkness = mkDefault 0.50;
            xray = mkDefault false;
          };

          #col.shadow = "rgba(1a1a1aee)";
          dim_inactive = mkDefault false;
          dim_strength = mkDefault 0.2;
          rounding = mkDefault 5;

          shadow = {
            enabled = mkDefault true;
            range = mkDefault 4;
            render_power = mkDefault 4;
          };
        };

        animations = {
          enabled = mkDefault true;
          animation = mkDefault [
            "border, 1, 10, default"
            "fade, 1, 7, default"
            "windows, 1, 5, myBezier"
            "windowsMove, 1, 5, myBezier"
            "windowsOut, 1, 7, myBezier"
            "windowsOut, 1, 7, default, popin 20%"
            "workspaces, 1, 10, overshot , slidevert"
          ];
          bezier = mkDefault [
            "myBezier, 0.05, 0.9, 0.1, 1.1"
            "overshot, 0.05, 0.9, 0.1, 1.1"
          ];
        };
      };
    };
  };
}
