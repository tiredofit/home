{ config, inputs, lib, pkgs, ... }:
let
  displayServer = config.host.home.feature.gui.displayServer ;
  windowManager = config.host.home.feature.gui.windowManager ;
in
with lib;
{
  config = mkIf (config.host.home.feature.gui.enable && displayServer == "wayland" && builtins.elem "hyprland" windowManager) {
    wayland.windowManager.hyprland = {
      settings = {
        on._args = ["hyprland.start" (lib.generators.mkLuaInline "function() hl.exec_cmd('${config.host.home.feature.uwsm.prefix}virt-manager') hl.exec_cmd('${config.host.home.feature.uwsm.prefix}ghosttyu') hl.exec_cmd('${config.host.home.feature.uwsm.prefix}firefox') end")];
      };
    };
  };
}
