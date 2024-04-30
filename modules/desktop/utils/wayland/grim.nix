{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.grim;
in
  with lib;
{
  options = {
    host.home.applications.grim = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Wayland screenshot tool";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          grim
        ];
    };
  };
}
