{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.wev;
in
  with lib;
{
  options = {
    host.home.applications.wev = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Wayland input information";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          wev
        ];
    };
  };
}
