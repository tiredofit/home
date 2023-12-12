{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.ark;
in
  with lib;
{
  options = {
    host.home.applications.ark = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "KDE Archiver";
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
            "application/bzip2"
            "application/gzip"
            "application/vnd.android.package-archive"
            "application/vnd.debian.binary-package"
            "application/vnd.ms-cab-compressed"
            "application/x-7z-compressed"
            "application/x-7z-compressed-tar"
            "application/x-ace"
            "application/x-alz"
            "application/x-ar"
            "application/x-archive"
            "application/x-arj"
            "application/x-brotli"
            "application/x-bzip"
            "application/x-bzip-brotli-tar"
            "application/x-bzip-compressed-tar"
            "application/x-bzip1"
            "application/x-bzip1-compressed-tar"
            "application/x-cabinet"
            "application/x-cd-image"
            "application/x-chrome-extension"
            "application/x-compress"
            "application/x-compressed-tar"
            "application/x-cpio"
            "application/x-deb"
            "application/x-ear"
            "application/x-gtar"
            "application/x-gzip"
            "application/x-java-archive"
            "application/x-lha"
            "application/x-lhz"
            "application/x-lrzip"
            "application/x-lrzip-compressed-tar"
            "application/x-lz4"
            "application/x-lz4-compressed-tar"
            "application/x-lzip"
            "application/x-lzip-compressed-tar"
            "application/x-lzma"
            "application/x-lzma-compressed-tar"
            "application/x-lzop"
            "application/x-ms-dos-executable"
            "application/x-ms-wim"
            "application/x-rar"
            "application/x-rar-compressed"
            "application/x-rpm"
            "application/x-rzip"
            "application/x-rzip-compressed-tar"
            "application/x-source-rpm"
            "application/x-stuffit"
            "application/x-tar"
            "application/x-tarz"
            "application/x-tzo"
            "application/x-war"
            "application/x-xar"
            "application/x-xz"
            "application/x-xz-compressed-tar"
            "application/x-zip"
            "application/x-zip-compressed"
            "application/x-zoo"
            "application/x-zstd-compressed-tar"
            "application/zip"
            "application/zstd"
          ];
        };
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          ark
        ];
    };

    xdg.mimeApps.defaultApplications = mkIf cfg.defaultApplication.enable (
      lib.genAttrs cfg.defaultApplication.mimeTypes (_: "org.kde.ark.desktop")
    );
  };
}
