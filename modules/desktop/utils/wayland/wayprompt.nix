{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.wayprompt;
in
  with lib;
{
  options = {
    host.home.applications.wayprompt = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Wayland Multi Purpose Prompt tool";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          wayprompt
        ];
    };
  };
}
