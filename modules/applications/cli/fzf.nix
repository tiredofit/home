{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.fzf;
in
  with lib;
{
  options = {
    host.home.applications.fzf = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Fuzzy Finder";
      };
    };
  };

  config = mkIf cfg.enable (let
    shellFunctions = ''
      _SYS_ALIASES=( sstart sstop sre ustart ustop ure )

      _SYS_CMDS=(
        's start $(sls static,disabled,failed)'
        's stop $(sls running,failed)'
        's restart $(sls)'
        'u start $(uls static,disabled,failed)'
        'u stop $(uls running,failed)'
        'u restart $(uls)'
      )

      _sysexec() {
        for ((j=0; j < ''${#_SYS_ALIASES[@]}; j++)); do
          if [ "$1" = "''${_SYS_ALIASES[$j]}" ]; then
            cmd=$(eval echo "''${_SYS_CMDS[$j]}")
            wide=''${cmd:0:1}
            cmd="$cmd && ''${wide} status \$_ || ''${wide}j -xeu \$_"
            eval $cmd
            [ -n "$BASH_VERSION" ] && history -s "$cmd"
            return
          fi
        done
      }

      for i in "''${_SYS_ALIASES[@]}"; do
        eval "$i() { _sysexec $i; }"
      done

      _sysls() {
        WIDE=$1
        [ -n "$2" ] && STATE="--state=$2"
        cat \
          <(echo 'UNIT/FILE LOAD/STATE ACTIVE/PRESET SUB DESCRIPTION') \
          <(systemctl $WIDE list-units --legend=false $STATE) \
          <(systemctl $WIDE list-unit-files --legend=false $STATE) \
        | sed 's/●/ /' \
        | grep . \
        | column --table --table-columns-limit=5 \
        | fzf --header-lines=1 \
              --accept-nth=1 \
              --no-hscroll \
              --preview="SYSTEMD_COLORS=1 systemctl $WIDE status {1}" \
              --preview-window=down
      }
    '';
  in {
    programs = {
      fzf = {
        enable = true;
        enableBashIntegration = mkDefault true;
        enableZshIntegration = mkDefault true;
        colors = {
          #"bg+" = "#${config.colorScheme.palette.base01}";
          #"fg+" = "#${config.colorScheme.palette.base06}";
          #"hl+" = "#${config.colorScheme.palette.base0D}";
          #bg = "#${config.colorScheme.palette.base00}";
          #fg = "#${config.colorScheme.palette.base04}";
          #header = "#${config.colorScheme.palette.base0D}";
          #hl = "#${config.colorScheme.palette.base0D}";
          #info = "#${config.colorScheme.palette.base0A}";
          #marker = "#${config.colorScheme.palette.base0C}";
          #pointer = "#${config.colorScheme.palette.base0C}";
          #prompt = "#${config.colorScheme.palette.base0A}";
          #spinner = "#${config.colorScheme.palette.base0C}";
        };
        defaultOptions = [
          "--height 40%"
          "--border"
        ];
        fileWidgetOptions = [
          "--preview 'head {}'"
        ];
        historyWidgetOptions = [
          "--sort"
        ];
      };

      bash = mkIf config.host.home.applications.bash.enable {
        initExtra = shellFunctions;
      };

      zsh = mkIf config.host.home.applications.zsh.enable {
        initContent = shellFunctions;
      };
    };
  });
}
