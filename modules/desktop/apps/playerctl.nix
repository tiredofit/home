{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.playerctl;
in
  with lib;
{
  options = {
    host.home.applications.playerctl = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Media Keys tool";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          playerctl
        ];
    };
  };
}
