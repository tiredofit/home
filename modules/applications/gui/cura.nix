{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.cura;
in
  with lib;
{
  options = {
    host.home.applications.cura = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "3D Part Slicer";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          cura
        ];
    };
  };
}
