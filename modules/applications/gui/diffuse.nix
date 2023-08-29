{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.diffuse;
in
  with lib;
{
  options = {
    host.home.applications.diffuse = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Graphical diff analyzer";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          diffuse
        ];
    };
  };
}
