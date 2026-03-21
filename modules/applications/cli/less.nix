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

  config = mkIf cfg.enable (let
    aliases = {
      more = "less";
    };

    sessionVars = {
      LESSHISTFILE = "$XDG_CACHE_HOME/less/history";
    };
  in {
    home = {
      packages = with pkgs;
        [
          less
        ];
    };

    programs = {
      less = {
        enable = true;
        config = ''
          s back-line
          t forw-line
        '';
      };

      bash = {
        sessionVariables = sessionVars;
        shellAliases = aliases;
      };

      zsh = {
        sessionVariables = sessionVars;
        shellAliases = aliases;
      };
    };
  });
}
