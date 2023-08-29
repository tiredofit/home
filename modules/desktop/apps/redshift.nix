{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.redshift;
in
  with lib;
{
  options = {
    host.home.applications.redshift = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Monitor Gamma control";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          redshift
        ];
    };
  };
}
