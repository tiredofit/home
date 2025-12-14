{ config, lib, ... }:
let
  displayServer = config.host.home.feature.gui.displayServer ;
  windowManager = config.host.home.feature.gui.windowManager ;
in
with lib;
{
  config = mkIf (config.host.home.feature.gui.enable && displayServer == "wayland" && windowManager == "hyprland") {
    wayland.windowManager.hyprland = {
      settings = {
        ## See more in modules/applications/* and modules/desktop/utils/*
        workspace = [
          "1, persistent:true, name:BROWSER,  defaultName:BROWSER, default:true"
          "2, persistent:true, name:TERMINAL, defaultName:TERMINAL"
          "3, persistent:true, name:SYSTEMS,  defaultName:SYSTEMS"
          "4, persistent:true, name:VM1,      defaultName:VM1"
          "5, persistent:true, name:VM2,      defaultName:VM2"
        ];
        windowrule = [
          "workspace 1, class:(firefox)"
          "workspace 2, class:(kitty)"
          "workspace 3, class:(.virt-manager-wrapped)"
          "workspace 4, title:(^enigma_nixos.*)"
          "workspace 5, title:(^onyx_opnsense.*)"
        ];
      };
    };
  };
}

