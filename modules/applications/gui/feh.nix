{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.feh;
in
  with lib;
{
  options = {
    host.home.applications.feh = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "X Image Viewer (great as a wallpaper manager)";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          feh
        ];
    };

  };
}
