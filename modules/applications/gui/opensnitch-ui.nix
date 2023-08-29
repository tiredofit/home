{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.opensnitch-ui;
in
  with lib;
{
  options = {
    host.home.applications.opensnitch-ui = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Application Firewall";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          opensnitch-ui
        ];
    };
  };
}
