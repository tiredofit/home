{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.libreoffice;
in
  with lib;
{
  options = {
    host.home.applications.libreoffice = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Word processor, Spreadsheet, Presentations";
      };
      package = mkOption {
        default =
          if pkgs ? libreoffice-stable
          then pkgs.libreoffice
          else pkgs.libreoffice-fresh;
        type = with types; package;
        description = "LibreOffice package to install.";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = [
        cfg.package
      ];
    };
  };
}
