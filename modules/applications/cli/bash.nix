{ config, lib, pkgs, ... }:

let
  cfg = config.host.home.applications.bash;
  shellAliases = {
    ".." = "cd ..";
    "..." = "cd ...";
    dotfiles = "cd ~/.config/home-manager/dotfiles";
    fuck = "sudo $(history -p !!)"; # run last command as root
    home = "cd ~";
    mkdir = "mkdir -p"; # no error, create parents
    scstart = "systemctl start $@"; # systemd service start
    scstop = "systemctl stop $@"; # systemd service stop
    scenable = "systemctl disable $@"; # systemd service enable
    scdisable = "systemctl disable $@"; # systemd service disable
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
        enableCompletion = true; # enable word completion by <tab>
        enableVteIntegration = true; # track working directory
        bashrcExtra = ''
          ## History - Needs to be at the top in the event that running a shell command rewriter such as Liquidprompt
          export HISTFILE=$HOME/.local/state/bash/history
          ## Configure bash to append (rather than overwrite history)
          shopt -s histappend

          # Attempt to save all lines of a multiple-line command in the same entry
          shopt -s cmdhist

          ## After each command, append to the history file and reread it
          PROMPT_COMMAND="''${PROMPT_COMMAND:+$PROMPT_COMMAND$"\n"}history -a; history -c; history -r"

          ## Print the timestamp of each command
          HISTTIMEFORMAT="%Y%m%d.%H%M%S%z "

          ## Set History File Size
          HISTFILESIZE=2000000

          ## Set History Size in memory
          HISTSIZE=3000

          ## Don't save ls,ps, history commands
          export HISTIGNORE="ls:ll:ls -alh:pwd:clear:history:ps"

          ## Do not store a duplicate of the last entered command and any commands prefixed with a space
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

          # Quickly run a pkg run nixpkgs - Add a second argument to it otherwise it will simply run the command - Can also use ',' which is a nix-community project.
          pkgrun () {
              if [ -n $1 ] ; then
                 local pkg
                 pkg=$1
                 if [ "$2" != "" ] ; then
                     shift
                     local args
                     args="$@"
                 else
                     args=$pkg
                 fi

                 nix-shell -p $pkg.out --run "$args"
              fi
          }

          system_update() {
              update_system() {
                  if command -v "nixos-rebuild" &>/dev/null; then
                    original_dir=$(pwd)
                    echo "*** $(date +"%Y-%m-%d %H:%M:%S") - UPDATING SYSTEM"
                    nixos_tmp=$(mktemp -d)
                    ${pkgs.git}/bin/git clone --depth 1 https://github.com/tiredofit/nixos-config "$nixos_tmp" > /dev/null 2>&1
                    cd $nixos_tmp
                    #sudo nixos-rebuild switch --flake $nixos_tmp#$HOSTNAME -b backup.$(date +"%Y%m%d%H%M%S")
                    sudo nixos-rebuild switch --flake $nixos_tmp#$HOSTNAME
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
