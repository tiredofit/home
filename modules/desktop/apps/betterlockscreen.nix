{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.betterlockscreen;
in
  with lib;
{
  options = {
    host.home.applications.betterlockscreen = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "X Lock Screen";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          betterlockscreen
        ];
    };
  };
}
