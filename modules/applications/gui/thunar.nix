{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.thunar;
in
  with lib;
{
  options = {
    host.home.applications.thunar = {
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
          ffmpegthumbnailer
          libgsf                          # odf files
          xfce.thunar                     # xfce4's file manager
          xfce.thunar-archive-plugin
          xfce.thunar-media-tags-plugin
          xfce.thunar-volman
          xfce.tumbler
          xfce.xfconf
        ];
    };

    xdg.mimeApps.defaultApplications = mkIf cfg.defaultApplication.enable (
      lib.genAttrs cfg.defaultApplication.mimeTypes (_: "thunar.desktop")
    );
  };
}