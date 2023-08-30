{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.xidlehook;
in
  with lib;
{
  options = {
    host.home.applications.xidlehook = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Perform actions when system is idle";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          xidlehook
        ];
    };
  };
}
