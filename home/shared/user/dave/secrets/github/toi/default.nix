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

  config = mkIf cfg.enable (let
    shellInit = ''
      toigh() {
        if [ -f "$XDG_RUNTIME_DIR/secrets/gh-token/toi-gh_token.env" ] ; then
          . "$XDG_RUNTIME_DIR/secrets/gh-token/toi-gh_token.env"
        elif [ -f "$XDG_RUNTIME_DIR/secrets/gh_token/toi-gh_token.env" ] ; then
          . "$XDG_RUNTIME_DIR/secrets/gh_token/toi-gh_token.env"
        fi
        gh "$@"
      }
    '';
  in {
    programs = {
      bash = { initExtra = shellInit; };
      zsh = { initContent = shellInit; };
    };

    nix.extraOptions = ''
      !include ${config.sops.secrets.toi-github.path}
    '';

    sops.secrets.toi-github = {
      sopsFile = ../../../../../../toi/user/dave/secrets/github/toi-github.env ;
      format = "dotenv";
      path = "%r/github/toi-github.env" ;
    };
  });


}
