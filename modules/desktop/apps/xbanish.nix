{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.xbanish;
in
  with lib;
{
  options = {
    host.home.applications.xbanish = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Hide mouse cursor when typing";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          xbanish
        ];
    };
  };
}
