{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.calibre;
in
  with lib;
{
  options = {
    host.home.applications.calibre = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "E-Book Manager";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          calibre
        ];
    };
  };
}
