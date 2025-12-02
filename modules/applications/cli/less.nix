{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.less;
in
  with lib;
{
  #imports = lib.optionals (lib.versionOlder lib.version "25.11pre") [
  #  (lib.mkAliasOptionModule ["programs" "less" "config"] ["programs" "less" "keys"])
  #];

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
        config = ''
          s back-line
          t forw-line
        '';
      };
      bash = {
        initExtra = ''
          alias more=less
        '';
        sessionVariables = {
          LESSHISTFILE = "$XDG_CACHE_HOME/less/history";
        };
        shellAliases = {
          "more" = "less"; # pager
        };
      };
    };
  };
}
