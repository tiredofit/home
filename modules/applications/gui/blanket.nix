{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.blanket;
in
  with lib;
{
  options = {
    host.home.applications.blanket = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Noise generator";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          blanket
        ];
    };

  };
}
