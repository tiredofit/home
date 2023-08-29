{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.nextcloud-client;
in
  with lib;
{
  options = {
    host.home.applications.nextcloud-client = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "File synchronization";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          nextcloud-client
        ];
    };
  };
}
