{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.msteams;
in
  with lib;
{
  options = {
    host.home.applications.msteams = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "IM/Video Conferencing";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          teams
        ];
    };

    wayland.windowManager.hyprland = {
      settings = {
        windowrulev2 = [

        ];
      };
    };
  };
}