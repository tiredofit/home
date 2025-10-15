{ config, lib, pkgs, ... }:

let
  cfg = config.host.home.applications.bash;
  shellAliases = {
    ".." = "cd ..";
    "..." = "cd ...";
    fuck = "sudo $(history -p !!)"; # run last command as root
    home = "cd ~";
    mkdir = "mkdir -p";
    s = "sudo systemctl";
    scdisable = "sudo systemctl disable $@";
    scenable = "sudo systemctl  disable $@";
    scstart = "sudo systemctl start $@";
    scstop = "sudo systemctl stop $@";
    sj = "sudo journalctl";
    u = "systemctl --user";
    uj = "journalctl --user";
    uscdisable = "systemctl --user disable $@";
    uscenable = "systemctl --user disable $@";
    uscstart = "systemctl --user start $@";
    uscstop = "systemctl --user stop $@";
  };
in
  with lib;
{
  options = {
    host.home.applications.bash = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Shell";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      activation = {
        config-bash_history = ''
          if [ ! -d $HOME/.local/state/bash ]; then
              echo "** Creating Local Bash History directory"
              mkdir -p $HOME/.local/state/bash
              touch $HOME/.local/state/bash/history
              chown -R $USER $HOME/.local/state/bash
          fi
        '';
      };
      packages = with pkgs; [
        bashInteractive
      ];
    };

    programs = {
      bash = {
        enable = true;
        enableCompletion = mkDefault true;
        enableVteIntegration = mkDefault true;
        bashrcExtra = ''
          # History
          export HISTFILE=$HOME/.local/state/bash/history
          shopt -s histappend
          shopt -s cmdhist
          PROMPT_COMMAND="''${PROMPT_COMMAND:+$PROMPT_COMMAND$"\n"}history -a; history -c; history -r"
          HISTTIMEFORMAT="%Y%m%d.%H%M%S%z "
          HISTFILESIZE=2000000
          HISTSIZE=3000
          export HISTIGNORE="ls:ll:ls -alh:pwd:clear:history:ps"
          HISTCONTROL=ignoreboth
        '';

        initExtra = ''
          if [ -d "/home/$USER/.config" ]; then alias src="cd $HOME/.config" ; fi
          if [ -d "/home/$USER/src" ]; then alias src="cd $HOME/src" ; fi
          if [ -d "/home/$USER/src/gh" ]; then alias srcgh="cd $HOME/src/gh" ; fi
          if [ -d "/home/$USER/src/sd" ]; then alias srcsd="cd $HOME/src/sd" ; fi

          if [ -f "/home/$USER/src/scripts/changelog/changelogger.sh" ] ; then
            alias changelog="/home/$USER/src/scripts/changelog/changelogger.sh"
          fi

          if [ -d "/var/local/data" ] ; then
            alias vld='cd /var/local/data'
          fi

          if [ -d "/var/local/db" ] ; then
            alias vldb='cd /var/local/db'
          fi

          if [ -d "/var/local/data/_system" ] ; then
              alias vlds='cd /var/local/data/_system'
          fi

          if command -v "nmcli" &>/dev/null; then
              alias wifi_scan="nmcli device wifi rescan && nmcli device wifi list"  # rescan for network
          fi

          if command -v "curl" &>/dev/null; then
            alias derp="curl https://cht.sh/$1"                       # short and sweet command lookup
            alias weather="curl -sSL https://wttr.in?F"               # Terminal Weather
          fi

          if command -v "grep" &>/dev/null; then
            alias grep="grep --color=auto"                            # Colorize grep
          fi

          if command -v "netstat" &>/dev/null; then
            alias ports="netstat -tulanp"                             # Show Open Ports
          fi

          if command -v "tree" &>/dev/null; then
            alias tree="tree -Cs"
          fi

          if command -v "rsync" &>/dev/null; then
            alias rsync="rsync -aXxtv"                                # Better copying with Rsync
          fi

          if [ -d "$HOME/.bashrc.d" ] ; then
            for script in $HOME/.bashrc.d/* ; do
              source $script
            done
          fi

          if command -v "rg" &>/dev/null && command -v "fzf" &>/dev/null && command -v "bat" &>/dev/null; then
            function frg {
              result=$(rg --ignore-case --color=always --line-number --no-heading "$@" |
                fzf --ansi \
                    --color 'hl:-1:underline,hl+:-1:underline:reverse' \
                    --delimiter ':' \
                    --preview "bat --color=always {1} --theme='Solarized (light)' --highlight-line {2}" \
                    --preview-window 'up,60%,border-bottom,+{2}+3/3,~3')
              file="''${result%%:*}"
              linenumber=$(echo "''${result}" | cut -d: -f2)
              if [ ! -z "$file" ]; then
                $EDITOR +"''${linenumber}" "$file"
              fi
            }
          fi

          if command -v "rg" &>/dev/null; then
              sir() {
                  if [ -z $1 ] || [ -z $2 ] ; then echo "Search inside Replace: sir <find_string_named> <sring_replaced>" ; return 1 ; fi
                  for file in $(rg -l $1) ; do
                    sed -i "s|$1|$2|g" "$file"
                  done
              }
          fi

          if command -v "fzf" &>/dev/null; then
            _sysls() {
              # $1: --system or --user
              # $2: states, see also "systemctl list-units --state=help"
              WIDE=$1
              [ -n $2 ] && STATE="--state=$2"
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

            # Aliases for unit selector.
            alias sls='_sysls --system'
            alias uls='_sysls --user'
            alias sjf='sj --unit $(uls) --all --follow'
            alias ujf='uj --unit $(uls) --all --follow'

            _SYS_ALIASES=(
              sstart sstop sre
              ustart ustop ure
            )

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
                  if [ "$1" == "''${_SYS_ALIASES[$j]}" ]; then
                    cmd=$(eval echo "''${_SYS_CMDS[$j]}") # expand service name
                    wide=''${cmd:0:1}
                    cmd="$cmd && ''${wide} status \$_ || ''${wide}j -xeu \$_"
                    eval $cmd

                    # Push to history.
                    [ -n "$BASH_VERSION" ] && history -s $cmd
                    #[ -n "$ZSH_VERSION" ] && print -s $cmd
                    return
                  fi
               done
            }

           for i in ''${_SYS_ALIASES[@]}; do
             source /dev/stdin <<EOF
           $i() {
             _sysexec $i
           }
EOF
           done

          fi

          if [ -d "$XDG_RUNTIME_DIR/secrets/bashrc.d" ] ; then
            for script in $XDG_RUNTIME_DIR/secrets/bashrc.d/* ; do
              source $script
            done
          fi

          far() {
            if [ -z $1 ] || [ -z $2 ] ; then echo "Rename files: far <find_file_named> <file_renamed>" ; return 1 ; fi
            for file in $(find -name "$1") ; do
                mv "$file" $(dirname "$file")/$2
            done
          }

          man() {
            LESS_TERMCAP_md=$'\e[01;31m' \
            LESS_TERMCAP_me=$'\e[0m' \
            LESS_TERMCAP_se=$'\e[0m' \
            LESS_TERMCAP_so=$'\e[01;44;33m' \
            LESS_TERMCAP_ue=$'\e[0m' \
            LESS_TERMCAP_us=$'\e[01;32m' \
            command man "$@"
          }

          system_update() {
              update_system() {
                  if command -v "nixos-rebuild" &>/dev/null; then
                    original_dir=$(pwd)
                    echo "*** $(date +"%Y-%m-%d %H:%M:%S") - UPDATING SYSTEM"
                    nixos_tmp=$(mktemp -d)
                    ${pkgs.git}/bin/git clone --depth 1 https://github.com/tiredofit/nixos-config "$nixos_tmp" > /dev/null 2>&1
                    cd $nixos_tmp
                    nixos-rebuild switch --sudo --flake $nixos_tmp#$HOSTNAME
                    cd $original_dir
                    rm -rf $nixos_tmp
                    if [ "$SSH_CONNECTION" = "" ]; then
                      ${pkgs.libnotify}/bin/notify-send "*** $(date +"%Y-%m-%d %H:%M:%S") - SYSTEM UPGRADE COMPLETE"
                    fi
                  fi
              }

              update_home() {
                if command -v "home-manager" &>/dev/null; then
                  original_dir=$(pwd)
                  echo "*** $(date +"%Y-%m-%d %H:%M:%S") - UPDATING HOME"
                  nixhome_tmp=$(mktemp -d)
                  ${pkgs.git}/bin/git clone https://github.com/tiredofit/home "$nixhome_tmp" > /dev/null 2>&1
                  cd $nixhome_tmp
                  home-manager switch --flake $nixhome_tmp#$HOSTNAME.$USER -b backup.$(date +%Y%m%d%H%M%S)
                  cd $original_dir
                  rm -rf $nixhome_tmp
                  echo "*** $(date +"%Y-%m-%d %H:%M:%S") - HOME UPGRADE COMPLETE"
                  if [ "$SSH_CONNECTION" = "" ]; then
                    ${pkgs.libnotify}/bin/notify-send "*** $(date +"%Y-%m-%d %H:%M:%S") - HOME UPGRADE COMPLETE"
                  fi
                fi
              }

              case $1 in
                home )
                  update_home
                ;;
                system )
                  update_system
                ;;
                all )
                  update_system
                  update_home
                ;;
                * )
                  update_system
                  update_home
                ;;
              esac
          }

          resetcow() {
            process_path() {
              local path="$1"
              if [ -f "$path" ]; then
                local perms owner group
                perms=$(stat -c %a "$path")
                owner=$(stat -c %u "$path")
                group=$(stat -c %g "$path")
                touch "$path.nocow"
                chattr +c "$path.nocow"
                dd if="$path" of="$path.nocow" bs=1M 2&>/dev/null
                rm "$path"
                mv "$path.nocow" "$path"
                chmod "$perms" "$path"
                chown "$owner:$group" "$path"
                echo "Removed Copy on Write for file '$path'"
              elif [ -d "$path" ]; then
                local perms owner group
                perms=$(stat -c %a "$path")
                owner=$(stat -c %u "$path")
                group=$(stat -c %g "$path")
                mv "$path" "$path.nocowdir"
                mkdir -p "$path"
                chattr +C "$path"
                cp -aR "$path.nocowdir/"* "$path"
                cp -aR "$path.nocowdir/."* "$path" 2>/dev/null
                rm -rf "$path.nocowdir"
                chmod "$perms" "$path"
                chown "$owner:$group" "$path"
                echo "Removed Copy on Write for directory '$path'"
              else
                echo "Can't detect if '$path' is file or directory, skipping"
              fi
            }

            local target_name="$1"
            local search_dir="$2"

            if [ -z "$target_name" ]; then
              echo "Usage: resetcow <file_or_dir_name> [search_directory]"
              return 1
            fi

            if [ -z "$search_dir" ]; then
              process_path "$target_name"
            else
              find "$search_dir" -name "$target_name" | while read -r path; do
                process_path "$path"
              done
            fi
          }

          days_from_epoch() {
            ## days_from_epoch YYYYMDD
            local input_date="$1"
            if [[ "$input_date" =~ ^[0-9]{8}$ ]]; then
              input_date="''${input_date:0:4}-''${input_date:4:2}-''${input_date:6:2}"
            fi
            echo $(( $(date -d "$input_date" +%s) / 86400 ))
          }

          timestamp() {
            case "''${1,,}" in
              date )
                ## timestamp filename YYYYMMDD
                local f="$2"
                local d="$3"
                touch -t "$(date -d "$d" +%Y%m%d)$(date -r "$f" +%H%M.%S)" "$f"
              ;;
            esac
          }
        '';

        inherit shellAliases;

        ###
        sessionVariables = {
          XDG_DATA_HOME = "$HOME/.local/share";
          XDG_CONFIG_HOME = "$HOME/.config";
          XDG_STATE_HOME = "$HOME/.local/state";
          XDG_CACHE_HOME = "$HOME/.cache";
        };

        shellOptions = [
          "autocd" # auto jump to directory (eg typing /etc)
          #"cmdhist"                               # history - attempt to save multiple line command in same entry
          #"histappend"                            # history - append (rather than overwrite)
        ];

        #profileExtra = builtins.readFile ~/.bash_profile;
        #initExtra = builtins.readFile ~/.bashrc;
      };
    };
  };
}
