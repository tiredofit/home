{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.nemo;
in
  with lib;
{
  options = {
    host.home.applications.nemo = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Graphical File Manager";
      };
      defaultApplication = {
        enable = mkOption {
          description = "MIME default application configuration";
          type = with types; bool;
          default = true;
        };
        mimeTypes = mkOption {
          description = "MIME types to be the default application for";
          type = types.listOf types.str;
          default = [
            "inode/directory"
          ];
        };
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          cinnamon.nemo-with-extensions
          ffmpegthumbnailer
        ];
    };

    xdg.mimeApps.defaultApplications = mkIf cfg.defaultApplication.enable (
      lib.genAttrs cfg.defaultApplication.mimeTypes (_: "nemo.desktop")
    );
  };
}