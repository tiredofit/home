{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.xev;
in
  with lib;
{
  options = {
    host.home.applications.xev = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "X input information";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          xorg.xev
        ];
    };
  };
}
