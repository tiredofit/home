{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.hyprsunset;
in
  with lib;
{
  options = {
    host.home.applications.hyprsunset = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Application to enable a blue-light filter on Hyprland";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          unstable.hyprsunset
        ];
    };
  };
}
