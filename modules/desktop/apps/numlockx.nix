{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.numlockx;
in
  with lib;
{
  options = {
    host.home.applications.numlockx = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Enable Number lock when X starts";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          numlockx
        ];
    };
  };
}
