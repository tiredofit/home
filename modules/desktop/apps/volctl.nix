{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.volctl;
in
  with lib;
{
  options = {
    host.home.applications.volctl = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Volume control in system tray";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          volctl
        ];
    };
  };
}
