{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.ferdium;
in
  with lib;
{
  options = {
    host.home.applications.ferdium = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Multi Messaging tool";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          ferdium
        ];
    };
  };
}
