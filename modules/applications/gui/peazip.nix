{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.peazip;
in
  with lib;
{
  options = {
    host.home.applications.peazip = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "File Archiver";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          peazip
        ];
    };
  };
}
