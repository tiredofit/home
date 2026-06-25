{ config, lib, ... }:
let
  displayServer = config.host.home.feature.gui.displayServer ;
  windowManager = config.host.home.feature.gui.windowManager ;
in
with lib;
{
  config = mkIf (config.host.home.feature.gui.enable && displayServer == "wayland" && builtins.elem "niri" windowManager) {
    programs.niri = {
      settings = {
        input = {
          keyboard = {
            numlock = mkDefault true;
          };
          focus-follows-mouse = { 
            max-scroll-amount= "0%"; 
          };
          touchpad = {
            tap = mkDefault true;
            natural-scroll = mkDefault false;
          };
        };
      };
    };
  };
}
