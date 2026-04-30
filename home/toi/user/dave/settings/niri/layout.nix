{ config, lib, pkgs, ... }:
let
  displayServer = config.host.home.feature.gui.displayServer ;
  windowManager = config.host.home.feature.gui.windowManager ;
in
with lib;
{
  config = mkIf (config.host.home.feature.gui.enable && displayServer == "wayland" && builtins.elem "niri" windowManager) {
    programs.niri = {
      settings = {
        layout = {
          gaps = mkDefault 16;
          center-focused-column = mkDefault "never";
          preset-column-widths = [
            { proportion = 1.0 / 3.0; }
            { proportion = 0.5; }
            { proportion = 2.0 / 3.0; }
          ];
          default-column-width = { proportion = 0.5; };
          focus-ring = {
            enable = mkDefault true;
            width = mkDefault 4;
            active = { color = "#7fc8ff"; };
            inactive = { color = "#505050"; };
          };
          border = {
            enable = mkDefault false;
            width = mkDefault 4;
            active = { color = "#ffc87f"; };
            inactive = { color = "#505050"; };
            urgent = { color = "#9b0000"; };
          };
          shadow = {
            enable =  mkDefault false;
            softness = mkDefault 30;
            spread = mkDefault 5;
            offset = { x = 0; y = 5; };
            color = mkDefault "#0007";
          };
        };
      };
    };
  };
}
