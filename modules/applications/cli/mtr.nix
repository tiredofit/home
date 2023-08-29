{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.mtr;
in
  with lib;
{
  options = {
    host.home.applications.mtr = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Trace packets across hops";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          mtr
        ];
    };
  };
}
