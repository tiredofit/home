{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.xev;
in
  with lib;
{
  options = {
    host.home.applications.xev = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "X input information";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          xorg.xev
        ];
    };

    programs = {
      bash = {
        initExtra = ''
          keypress() {
            xev | awk -F'[ )]+' '/^KeyPress/ { a[NR+2] } NR in a { printf "%-3s %s\n", $5, $8 }'
          }
        '';
      };
    };
  };
}
