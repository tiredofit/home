{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.swayosd;
in
  with lib;
{
  options = {
    host.home.applications.swayosd = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Sway On Screen Display";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          swayosd
        ];
    };
  };
}
