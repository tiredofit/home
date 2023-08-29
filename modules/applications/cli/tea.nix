{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.tea;
in
  with lib;
{
  options = {
    host.home.applications.tea = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Gitea Client";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
        packages = with pkgs;
          [
            tea
          ];
    };
  };
}
