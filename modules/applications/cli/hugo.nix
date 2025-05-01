{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.hugo;
in
  with lib;
{
  options = {
    host.home.applications.hugo = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Static site generator";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          hugo
        ];
    };
  };
}
