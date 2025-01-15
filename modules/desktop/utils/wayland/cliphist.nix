{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.cliphist;
in
  with lib;
{
  options = {
    host.home.applications.cliphist = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Wayland clipboard history";
      };
      service.enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Auto start on user session start";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          cliphist
        ];
    };

    services = {
      cliphist = {
        enable = cfg.service.enable;
      };
    };
  };
}
