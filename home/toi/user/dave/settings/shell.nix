{ config, lib, pkgs, ... }:
let
  sessionVariables = {
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_STATE_HOME = "$HOME/.local/state";
    XDG_CACHE_HOME = "$HOME/.cache";
  };

  shellAliases = {
    ".." = "cd ..";
    "..." = "cd ...";
    fuck = "sudo $(history -p !!)";
    home = "cd ~";
    mkdir = "mkdir -p";
    s = "sudo systemctl";
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

  shellFunctions = ''
    system_update() {
      # update system and/or home configurations
      # syntax: system_update [home|system|all]
      update_system() {
        # update NixOS system via flake
        # syntax: update_system
        if command -v "nixos-rebuild" &>/dev/null; then
          original_dir=$(pwd)
          echo "*** $(date +"%Y-%m-%d %H:%M:%S") - UPDATING SYSTEM"
          nixos_tmp=$(mktemp -d)
          ${pkgs.git}/bin/git clone --depth 1 https://github.com/tiredofit/nixos-config "$nixos_tmp" > /dev/null 2>&1
          cd $nixos_tmp
          if command -v nixos-rebuild-ng > /dev/null 2>&1 ; then
            NIXOS_REBUILD_CMD="nixos-rebuild-ng"
          else
            NIXOS_REBUILD_CMD="nixos-rebuild"
          fi
          $NIXOS_REBUILD_CMD switch --sudo --flake $nixos_tmp#$HOSTNAME
          cd $original_dir
          rm -rf $nixos_tmp
          if [ "$SSH_CONNECTION" = "" ]; then
            ${pkgs.libnotify}/bin/notify-send "*** $(date +"%Y-%m-%d %H:%M:%S") - SYSTEM UPGRADE COMPLETE"
          fi
        fi
      }

      update_home() {
        # update Home Manager config from flake
        # syntax: update_home
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
        home ) update_home ;;
        system ) update_system ;;
        all ) update_system; update_home ;;
        * ) update_system; update_home ;;
      esac
    }

    vld() {
      # change to /var/local/data if present
      # syntax: vld
      if [ -d "/var/local/data" ]; then
        cd /var/local/data
      else
        echo "No /var/local/data"
        return 1
      fi
    }

    vldb() {
      # change to /var/local/db if present
      # syntax: vldb
      if [ -d "/var/local/db" ]; then
        cd /var/local/db
      else
        echo "No /var/local/db"
        return 1
      fi
    }

    vlds() {
      # change to /var/local/data/_system if present
      # syntax: vlds
      if [ -d "/var/local/data/_system" ]; then
        cd /var/local/data/_system
      else
        echo "No /var/local/data/_system"
        return 1
      fi
    }

    colorize() {
      # colorize file output using bat/ccze or cat
      # syntax: colorize <file>
      if [ -t 1 ]; then
        if command -v bat >/dev/null 2>&1; then
          bat --paging=never "$@"
        else
          cat "$@"
        fi
      else
        cat "$@"
      fi
    }

    days_from_epoch() {
      # convert YYYYMMDD or date to days since epoch
      # syntax: days_from_epoch <YYYYMMDD|date>
      local input_date="$1"
      if [[ "$input_date" =~ ^[0-9]{8}$ ]]; then
        input_date="$${input_date:0:4}-$${input_date:4:2}-$${input_date:6:2}"
      fi
      echo $(( $(date -d "$input_date" +%s) / 86400 ))
    }

    derp() {
      # fetch command help from cht.sh
      # syntax: derp <query>
      if command -v curl >/dev/null 2>&1; then
        curl "https://cht.sh/$1"
      else
        echo "curl not available"
        return 1
      fi
    }

    far() {
      # rename files matching a pattern
      # syntax: far <find_pattern> <new_name>
      if [ -z "$1" ] || [ -z "$2" ]; then
        echo "Rename files: far <find_file_named> <file_renamed>"
        return 1
      fi
      for file in $(find -name "$1"); do
        mv "$file" "$(dirname "$file")/$2"
      done
    }

    findalias() {
      # search defined shell aliases
      # syntax: findalias [pattern]
      if [ -z "$1" ]; then
        alias
        return
      fi
      if command -v rg >/dev/null 2>&1; then
        alias | rg -i -- "$@"
      else
        alias | grep -i -- "$@" || true
      fi
    }

    grep() {
      # colorized grep wrapper
      # syntax: grep <pattern> [files]
      command grep --color=auto "$@"
    }

    man() {
      # Improved man with colorized less
      # syntax: man <command>
      LESS_TERMCAP_md=$'\e[01;31m' \
      LESS_TERMCAP_me=$'\e[0m' \
      LESS_TERMCAP_se=$'\e[0m' \
      LESS_TERMCAP_so=$'\e[01;44;33m' \
      LESS_TERMCAP_ue=$'\e[0m' \
      LESS_TERMCAP_us=$'\e[01;32m' \
      command man "$@"
    }

    ports() {
      # show open network ports
      # syntax: ports
      if command -v netstat >/dev/null 2>&1; then
        netstat -tulanp "$@"
      else
        echo "netstat not available"
        return 1
      fi
    }

    resetcow() {
      # remove Copy-on-Write from file/dir (nocow)
      # syntax: resetcow <file|dir> [search_dir]
      process_path() {
        # helper to process path for resetcow
        # syntax: process_path <path>
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

    timestamp() {
      # touch file with timestamp from another file/date
      # syntax: timestamp date <file> <date>
      case "$${1,,}" in
        date )
          local f="$2";
          local d="$3";
          touch -t "$(date -d "$d" +%Y%m%d)$(date -r "$f" +%H%M.%S)" "$f"
        ;;
      esac
    }

    tree() {
      # tree wrapper with options
      # syntax: tree [dir]
      if command -v tree >/dev/null 2>&1; then
        tree -Cs "$@"
      else
        echo "tree not available"
        return 1
      fi
    }

    weather() {
      # show weather in terminal via wttr.in
      # syntax: weather
      if command -v curl >/dev/null 2>&1; then
        curl -sSL "https://wttr.in?F"
      else
        echo "curl not available"
        return 1
      fi
    }
  '';
in
{
  home.sessionVariables = lib.mkMerge [
    sessionVariables
    (lib.mkIf config.host.home.applications.zsh.enable {
      ZDOTDIR = "${config.xdg.configHome}/zsh";
    })
  ];

  programs = {
    bash = lib.mkIf config.host.home.applications.bash.enable {
      initExtra = shellFunctions;
      shellAliases = shellAliases;
    };

    zsh = lib.mkIf config.host.home.applications.zsh.enable {
      dotDir = "${config.xdg.configHome}/zsh";
      initContent = shellFunctions;
      initExtraFirst = ''
        p10k_file="$HOME/.cache/p10k-instant-prompt-$USER.zsh"
        if [[ -r "$p10k_file" ]]; then source "$p10k_file"; fi
        source ${config.xdg.configHome}/zsh/.p10k.zsh
        if [[ "$TERM_PROGRAM" == "vscode" ]]; then
            typeset POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=()
        fi

      '';
      plugins = [
        {
          name = "zsh-powerlevel10k";
          src = "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/";
          file = "powerlevel10k.zsh-theme";
        }
      ];
      sessionVariables = {
        ZDOTDIR = "${config.xdg.configHome}/zsh";
      };
      shellAliases = shellAliases;
    };
  };

  home.file = {
    "${config.xdg.configHome}/zsh/.p10k.zsh".source = ../dotfiles/p10k/p10k.zsh;
  };
}

