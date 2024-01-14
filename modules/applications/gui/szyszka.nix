{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.szyszka;
in
  with lib;
{
  options = {
    host.home.applications.szyszka = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "File Renamer";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          szyszka
        ];
    };
  };
}
