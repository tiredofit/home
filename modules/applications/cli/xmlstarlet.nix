{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.xmlstarlet;
in
  with lib;
{
  options = {
    host.home.applications.xmlstarlet = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "XML Parser";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          xmlstarlet
        ];
    };
  };
}
