{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.pinta;
in
  with lib;
{
  options = {
    host.home.applications.pinta = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Image manipulation";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          pinta
        ];
    };
  };
}
