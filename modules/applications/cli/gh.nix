{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.github-client;
in
  with lib;
{
  options = {
    host.home.applications.github-client = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Github Client";
      };
    };
  };

  config = mkIf cfg.enable {
    programs = {
      gh = {
        enable = true;
        extensions = [
          pkgs.gh-eco
        ];
        settings = {
          prompt = "enabled";

          aliases = {
            co = "pr checkout";
            pv = "pr view";
          };
        };
      };

      bash.initExtra = ''
        if [ -f "$XDG_RUNTIME_DIR/secrets/gh_token" ] ; then
          export GITHUB_TOKEN=$(cat $XDG_RUNTIME_DIR/secrets/gh_token)
        fi
      '';
    };

    sops.secrets.gh_token = {
      sopsFile = ../../../home/common/secrets/gh.yaml ;
      path = "%r/gh-token" ;
    };
  };
}
