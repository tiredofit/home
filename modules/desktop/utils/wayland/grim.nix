{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.grim;
in
  with lib;
{
  options = {
    host.home.applications.grim = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Wayland screenshot tool";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          grim
        ];
    };

    wayland.windowManager.hyprland = mkIf (config.host.home.feature.gui.isHyprland) {
      settings.permission = [{
        binary = "${lib.getExe' pkgs.grim "grim"}";
        type = "screencopy";
        mode = "allow";
      }];
    };
  };
}
