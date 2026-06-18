{ config, inputs, lib, pkgs, ... }:
let
  displayServer = config.host.home.feature.gui.displayServer ;
  windowManager = config.host.home.feature.gui.windowManager ;
in
with lib;
{
  config = mkIf (config.host.home.feature.gui.isHyprland) {
    wayland.windowManager.hyprland = {
      settings = {
        config = {
          animations = {
            enabled = false;
          };
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

            dim_inactive = mkDefault false;
            dim_strength = mkDefault 0.2;
            rounding = mkDefault 5;
            shadow = {
              enabled = mkDefault true;
              range = mkDefault 4;
              render_power = mkDefault 4;
            };
          };
        };

        curve = [
          {
            _args = [
              "myBezier"
              {
                type = "bezier";
                points = [
                  [
                    0.05
                    0.9
                  ]
                  [
                    0.1
                    1.1
                  ]
                ];
              }
            ];
          }
          {
            _args = [
              "overshot"
              {
                type = "bezier";
                points = [
                  [
                    0.05
                    0.9
                  ]
                  [
                    0.1
                    1.1
                  ]
                ];
              }
            ];
          }
        ];
        animation = [
          {
            leaf = "border";
            enabled = true;
            speed = 10;
            bezier = "default";
          }

          {
            leaf = "fade";
            enabled = true;
            speed = 7;
            bezier = "default";
          }

          {
            leaf = "windows";
            enabled = true;
            speed = 5;
            bezier = "myBezier";
          }

          {
            leaf = "windowsMove";
            enabled = true;
            speed = 5;
            bezier = "myBezier";
          }

          {
            leaf = "windowsOut";
            enabled = true;
            speed = 7;
            bezier = "myBezier";
          }

          {
            leaf = "windowsOut";
            enabled = true;
            speed = 7;
            bezier = "default";
            style = "popin 20%";
          }

          {
            leaf = "workspaces";
            enabled = true;
            speed = 10;
            bezier = "overshot";
            style = "slidevert";
          }
        ];
      };
    };
  };
}
