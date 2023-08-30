{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.xbindkeys;
in
  with lib;
{
  options = {
    host.home.applications.xbindkeys = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Bind keys to functions";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          xbindkeys
        ];
    };
  };
}
