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
          follow_mouse = mkDefault 1; # 0=disabled 1=autofocus 2=sloppy 3=seperated
          kb_layout = mkDefault "us";
          kb_model = mkDefault "";
          kb_options = mkDefault "";
          kb_rules = mkDefault "";
          kb_variant = mkDefault "";
          mouse_refocus= mkDefault false;
          numlock_by_default = mkDefault true;
          repeat_delay = mkDefault 200;
          repeat_rate = mkDefault 40;
          sensitivity = mkDefault 0;
          touchpad = {
            natural_scroll = mkDefault false;
            disable_while_typing = mkDefault true;
          };
        };
      };
    };
  };
}
