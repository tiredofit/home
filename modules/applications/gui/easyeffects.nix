{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.easyeffects;
in
  with lib;
{
  options = {
    host.home.applications.easyeffects = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Pipewire Sound processing";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          easyeffects
        ];
    };
  };
}