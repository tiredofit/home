{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.restic;
in
  with lib;
{
  options = {
    host.home.applications.restic = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "System backups";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          restic
        ];
    };
  };
}
