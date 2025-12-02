{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.smartgit;
in
  with lib;
{
  options = {
    host.home.applications.smartgit = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Git repository manager";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          smartgit
        ];
    };
  };
}
