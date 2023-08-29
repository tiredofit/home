{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.less;
in
  with lib;
{
  options = {
    host.home.applications.less = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Pager";
      };
    };
  };

  config = mkIf cfg.enable {
    programs = {
      less = {
         enable = true;
         keys = ''
           s back-line
           t forw-line
         '';
       };
      bash = {
        sessionVariables = {
          LESSHISTFILE="$XDG_CACHE_HOME/less/history";
        };
        shellAliases = {
          "more" = "less"; # pager
        };
      };
    };
  };
}
