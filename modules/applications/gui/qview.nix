{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.qview;
  mimeTypes = [
    "image/bmp"
    "image/gif"
    "image/jpeg"
    "image/jpg"
    "image/pjpeg"
    "image/png"
    "image/svg+xml"
    "image/svg+xml-compressed"
    "image/tiff"
    "image/vnd"
    "image/x-icns"
    "image/webp"
    "image/x-bmp"
    "image/x-gray"
    "image/x-icb"
    "image/x-ico"
    "image/x-pcx"
    "image/x-png"
    "image/x-portable-anymap"
    "image/x-portable-bitmap"
    "image/x-portable-graymap"
    "image/x-portable-pixmap"
    "image/x-xbitmap"
    "image/x-xpixmap"
  ];
in
  with lib;
{
  options = {
    host.home.applications.qview = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "QT Image Viewer";
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
          default = mimeTypes;
        };
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          qview
        ];
    };

    xdg = {
      desktopEntries = {
        qview = {
          name = "Qview";
          genericName = "QT Image Viewer";
          categories = [
            "Application"
            "Graphics"
          ];
          exec = "qview %U";
          terminal = false;
          mimeType = mimeTypes;
        };
      };

      mimeApps.defaultApplications = mkIf cfg.defaultApplication.enable (
        lib.genAttrs cfg.defaultApplication.mimeTypes (_: "qview.desktop")
      );
    };
  };
}
