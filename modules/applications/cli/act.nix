{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.act;
in
  with lib;
{
  options = {
    host.home.applications.act = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Github Actions runner";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          act
        ];
    };
    programs = {
      bash.initExtra = ''
        if [ -f "$XDG_RUNTIME_DIR"/secrets/act ] ; then
            alias act="act --secret-file '$XDG_RUNTIME_DIR/secrets/act'"
        fi
        '';
    };

    sops.secrets = {
      "act" = {
         sopsFile = ../../../home/common/secrets/act.env;
         format = "dotenv";
       };
    };
  };
}
