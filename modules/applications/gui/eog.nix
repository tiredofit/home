{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.eog;
in
  with lib;
{
  options = {
    host.home.applications.eog = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Gnome Image viewer";
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
            "image/bmp";
            "image/gif";
            "image/jpeg";
            "image/jpg";
            "image/pjpeg";
            "image/png";
            "image/tiff";
            "image/x-bmp";
            "image/x-gray";
            "image/x-icb";
            "image/x-ico";
            "image/x-png";
            "image/x-portable-anymap";
            "image/x-portable-bitmap";
            "image/x-portable-graymap";
            "image/x-portable-pixmap";
            "image/x-xbitmap";
            "image/x-xpixmap";
            "image/x-pcx";
            "image/svg+xml";
            "image/svg+xml-compressed";
            "image/vnd.wap.wbmp;image/x-icns";
          ];
        };
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          gnome.eog
        ];
    };

    xdg.mimeApps.defaultApplications = mkIf cfg.defaultApplication.enable (
      lib.genAttrs cfg.defaultApplication.mimeTypes (_: "org.gnome.eog.desktop")
    );
  };
}
