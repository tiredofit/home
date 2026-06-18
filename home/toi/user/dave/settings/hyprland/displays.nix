{ config, inputs, lib, pkgs, ... }:
let
  displayServer = config.host.home.feature.gui.displayServer ;
  windowManager = config.host.home.feature.gui.windowManager ;
in
with lib;
{
  config = mkIf (config.host.home.feature.gui.isHyprland) {
    wayland.windowManager.hyprland = {
      extraConfig = ''
        require("display")
      '';
    };
  };
}
