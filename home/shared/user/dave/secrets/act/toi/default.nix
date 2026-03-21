{config, lib, pkgs, specialArgs, ...}:

let
  inherit (specialArgs) username;
  cfg = config.host.home.user.dave.secrets.act.toi;
in
  with lib;
{

  options = {
    host.home.user.dave.secrets.act.toi = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Enable ACT Tokens (TOI)";
      };
    };
  };

  config = mkIf cfg.enable (let
    shellInit = ''
      toiact() {
        if [ -f "$XDG_RUNTIME_DIR/act/toi-act.env" ] ; then
          SECRET_FILE="$XDG_RUNTIME_DIR/act/toi-act.env"
        elif [ -f "$XDG_RUNTIME_DIR/act/toi_act.env" ] ; then
          SECRET_FILE="$XDG_RUNTIME_DIR/act/toi_act.env"
        else
          SECRET_FILE=""
        fi

        if [ -n "$SECRET_FILE" ]; then
          act --secret-file "$SECRET_FILE" "$@"
        else
          act "$@"
        fi
      }
    '';
  in {
    programs = {
      bash = { initExtra = shellInit; };
      zsh = { initContent = shellInit; };
    };

    sops.secrets.toi-act = {
      sopsFile = ../../../../../../toi/user/dave/secrets/act/toi-act.env ;
      path = "%r/act/toi-act.env" ;
      format = "dotenv";
    };
  });
}
