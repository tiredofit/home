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
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          libreoffice-fresh
        ];
    };
  };
}
