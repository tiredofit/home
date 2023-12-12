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
      defaultApplication = {
        enable = mkOption {
          description = "MIME default application configuration";
          type = with types; bool;
          default = false;
        };
        mimeTypes = mkOption {
          description = "MIME types to be the default application for";
          type = types.listOf types.str;
          default = [

          ];
        };
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

    xdg.mimeApps.defaultApplications = mkIf cfg.defaultApplication.enable (
      lib.genAttrs cfg.defaultApplication.mimeTypes (_: "calibre-gui.desktop")
    );
  };
}
