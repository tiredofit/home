{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.hyprdim;
in
  with lib;
{
  options = {
    host.home.applications.hyprdim = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "hyprdim is a daemon that automatically dims windows in Hyprland when switching between them";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          hyprdim
        ];
    };

  };
}
