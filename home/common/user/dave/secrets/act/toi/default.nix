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

  config = mkIf cfg.enable {
    programs = {
      bash.initExtra = ''
        if [ -f "$XDG_RUNTIME_DIR"/secrets/act/toi-act.env ] ; then
            alias toiact="act --secret-file '$XDG_RUNTIME_DIR/secrets/toi-act.env'"
        fi
        '';
    };

    sops.secrets.toi-act = {
      sopsFile = ../../../../../../toi/user/dave/secrets/act/toi-act.env ;
      path = "%r/act/toi-act.env" ;
      format = "dotenv";
    };
  };
}
