{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.wget;
in
  with lib;
{
  options = {
    host.home.applications.wget = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Remote file downloader";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
        packages = with pkgs;
          [
            wget
          ];
    };
    programs = {
      bash = {
        initExtra = ''
          alias wget="wget --hsts-file=$XDG_DATA_HOME/wget-hsts"
        '';
      };
    };
  };
}
