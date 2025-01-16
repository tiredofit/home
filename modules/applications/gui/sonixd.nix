{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.sonixd;
in
  with lib;
{
  options = {
    host.home.applications.sonixd = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Full-featured Subsonic/Jellyfin compatible desktop music player";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          sonixd
        ];
    };
  };
}
