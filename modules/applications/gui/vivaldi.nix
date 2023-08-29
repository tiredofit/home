{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.vivaldi;
in
  with lib;
{
  options = {
    host.home.applications.vivaldi = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Web browser and mail client";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          vivaldi
        ];
    };
  };
}
