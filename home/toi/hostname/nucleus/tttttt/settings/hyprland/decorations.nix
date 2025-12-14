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
          #col.active_border = "rgba(33ccffee) rgba(00ff99ee) 45deg";
          #col.inactive_border = "rgba(595959aa)";
          allow_tearing = mkDefault true;
          border_size = mkDefault 2;
          gaps_in = mkDefault 2;
          gaps_out = mkDefault 5;
          #layout = mkDefault "master";
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
          inherit_fullscreen = mkDefault true;
          mfact = mkDefault 0.55;
          new_on_top = mkDefault true;
          new_status = mkDefault "master";
          orientation = mkDefault "center";
          smart_resizing = mkDefault true;
        };

        animations = {
          enabled = false;
        };

        decoration = {
          blur = {
            enabled = false;
          };

          shadow = {
            enabled = false;
          };
        };

      };
    };
  };
}
