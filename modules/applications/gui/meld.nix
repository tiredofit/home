{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.meld;
in
  with lib;
{
  options = {
    host.home.applications.meld = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Graphical diff analyzer";
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
          meld
        ];
    };

    xdg.mimeApps.defaultApplications = mkIf cfg.defaultApplication.enable (
      lib.genAttrs cfg.defaultApplication.mimeTypes (_: "io.github.mightycreak.meld.desktop")
    );
  };
}
