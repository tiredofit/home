{config, lib, pkgs, specialArgs, ...}:

let
  inherit (specialArgs) username;
  cfg = config.host.home.user.dave.secrets.github.toi;
in
  with lib;
{

  options = {
    host.home.user.dave.secrets.github.toi = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Enable Github Token (TOI)";
      };
    };
  };

  config = mkIf cfg.enable {
    programs = {
      bash.initExtra = ''
        if [ -f "$XDG_RUNTIME_DIR/secrets/gh_token/toi-gh_token.env" ] ; then
          alias toigh="$(cat $XDG_RUNTIME_DIR/secrets/gh-token/toi-gh_token.env) gh"
        fi
      '';
    };

    sops.secrets.toi-github = {
      sopsFile = ../../../../../../toi/user/dave/secrets/github/toi-github.env ;
      format = "dotenv";
      path = "%r/github/toi-github.env" ;
    };
  };
}
