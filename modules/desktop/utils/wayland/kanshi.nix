{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.kanshi;
in
  with lib;
{
  options = {
    host.home.applications.kanshi = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = " Dynamic display configuration";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          kanshi
        ];
    };
  };
}
