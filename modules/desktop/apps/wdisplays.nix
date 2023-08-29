{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.wdisplays;
in
  with lib;
{
  options = {
    host.home.applications.wdisplays = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Screen layout manager";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          wdisplays
        ];
    };
  };
}
