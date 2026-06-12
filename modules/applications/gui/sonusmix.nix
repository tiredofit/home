{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.sonusmix;
in
  with lib;
{
  options = {
    host.home.applications.sonusmix = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Graphical Pipewire/Wireplumber Router";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          sonusmix
        ];
    };

    wayland.windowManager.hyprland = mkIf (config.host.home.feature.gui.displayServer == "wayland" && builtins.elem "hyprland" config.host.home.feature.gui.windowManager && config.host.home.feature.gui.enable) {
      settings = {
        on = [{ _args = ["hyprland.start" (lib.generators.mkLuaInline "function() hl.exec_cmd('${config.host.home.feature.uwsm.prefix}sonusmix') end")]; }];
      };
    };
  };
}