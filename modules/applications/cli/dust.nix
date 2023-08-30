{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.dust;
in
  with lib;
{
  options = {
    host.home.applications.dust = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "'du' command line replacement";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          du-dust
        ];
    };
    programs = {
      bash = {
        shellAliases = {
          du = "dust" ;    # disk usage alternative
        };
      };
    };
  };
}
