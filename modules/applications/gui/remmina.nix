{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.remmina;
in
  with lib;
{
  options = {
    host.home.applications.remmina = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Remote Desktop viewer";
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
            "application/x-remmina"
            "x-scheme-handler/rdp"
            "x-scheme-handler/remmina"
            "x-scheme-handler/spice"
            "x-scheme-handler/vnc"
          ];
        };
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          remmina
        ];
    };

    xdg.mimeApps.defaultApplications = mkIf cfg.defaultApplication.enable (
      lib.genAttrs cfg.defaultApplication.mimeTypes (_: "org.remmina.Remmina.desktop")
    );
  };
}
