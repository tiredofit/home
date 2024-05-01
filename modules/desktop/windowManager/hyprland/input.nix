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
        input = {
          follow_mouse = 1;
          kb_layout = "us";
          kb_model = "";
          kb_options = "";
          kb_rules = "";
          kb_variant = "";
          numlock_by_default = true;
          repeat_delay = 200;
          repeat_rate = 40;
          sensitivity = 0;
          touchpad = {
            natural_scroll = false;
          };
        };

        gestures = {
          workspace_swipe = false;
        };
      };
    };
  };
}
