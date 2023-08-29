{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.diceware;
in
  with lib;
{
  options = {
    host.home.applications.diceware = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Random word generator";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          diceware
        ];
    };

    programs = {
      bash = {
        initExtra = ''
          ## Password Generation
          pwgen() {
            if [ -n "$1" ] ; then pwords=$1 ; else pwords=4 ; fi
            unset genpassword
            counter=1
            for s_password in $(eval echo "{1..$pwords}") ; do
            case $counter in
                    "2" | "4" | "6" | "8" | "10" | "12" | "14" | "16" )
                            s_password=$(diceware -n 1)
                            s_password=''${s_password^^}
                    ;;
                    "1" | "3" | "5" | "7" | "9" | "11" | "13" | "15" )
                            s_password=$(diceware -n 1 --no-caps)
                            s_password=''${s_password,,}
                    ;;
            esac
            if [ "$counter" -lt $pwords ] ; then
                    s_password="$s_password-"
            fi
            genpassword=$genpassword$s_password
            (( counter+=1 ))
            done
            echo $genpassword
            unset genpassword
          }
        '';
      };
    };
  };
}
