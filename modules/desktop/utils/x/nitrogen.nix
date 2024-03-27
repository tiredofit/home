{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.nitrogen;
in
  with lib;
{
  options = {
    host.home.applications.nitrogen = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "X Wallpaper Manager";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          nitrogen
        ];
    };

  };
}
