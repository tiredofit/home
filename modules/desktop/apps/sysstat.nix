{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.sysstat;
in
  with lib;
{
  options = {
    host.home.applications.sysstat = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "System information";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          sysstat
        ];
    };
  };
}
