{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.mate-calc;
in
  with lib;
{
  options = {
    host.home.applications.mate-calc = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "MATE Calculator";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          mate.mate-calc
        ];
    };
  };
}
