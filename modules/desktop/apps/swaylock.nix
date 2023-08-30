{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.swaylock;
in
  with lib;
{
  options = {
    host.home.applications.swaylock = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Sway Lock screen";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          swaylock-effects
        ];
    };
  };
}
