{ config, lib, pkgs, ... }:
## PERSONALIZE
let
  cfg = config.host.home.applications.zsh;
in
  with lib;
{
  options = {
    host.home.applications.zsh = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Shell";
      };
    };
  };

  config = mkIf cfg.enable {
    # Disable Liquid Prompt by default to avoid slow prompt startup; enable manually if desired
    host.home.applications.liquidprompt.enable = mkForce false;
    home = {
      activation = {
        config-zsh_history = ''
          if [ ! -d $HOME/.local/state/zsh ]; then
              echo "** Creating Local ZSH History directory"
              mkdir -p $HOME/.local/state/zsh
              touch $HOME/.local/state/zsh/history
              chown -R $USER $HOME/.local/state/zsh
          fi
        '';
            #zsh-compile-site-functions = ''
            #  echo "** Compiling zsh site-functions for faster startup"
            #  ZSHCOMPILER="${pkgs.zsh}/bin/zcompile"
            #  CACHE_DIR="''${XDG_CACHE_HOME:-$HOME/.cache}/zsh/compiled"
            #  mkdir -p "$CACHE_DIR"
            #  # Compile files placed by home-manager (siteFunctions) and common zsh configs
            #  for f in "$HOME/.local/share/zsh"/*.zsh "$HOME/.local/share/zsh"/*/*.zsh "$HOME/.config/zsh"/*.zsh "$HOME/.config/zsh"/*/*.zsh; do
            #    [ -f "$f" ] || continue
            #    echo "Compiling $f"
            #    $ZSHCOMPILER "$f" 2>/dev/null || true
            #  done
            #  # Pre-generate compinit dump so interactive shells skip heavy compinit work
            #  # Determine zsh version by invoking the packaged zsh (activation runs in sh)
            #  zsh_ver="$("${pkgs.zsh}/bin/zsh" -c 'printf "%s" "$ZSH_VERSION"')"
            #  ZCOMPDUMP="''${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-''${zsh_ver}"
            #  mkdir -p "$(dirname "$ZCOMPDUMP")"
            #  export ZCOMPDUMP
            #  "${pkgs.zsh}/bin/zsh" -c 'autoload -Uz compinit; compinit -d "$ZCOMPDUMP" 2>/dev/null || true'
            #'';
      };
    };

    programs.zsh = {
      enable = true;
      autocd = true;
      enableCompletion = mkDefault true;
      autosuggestion.enable = mkDefault true;
      syntaxHighlighting.enable = mkDefault true;
      history = {
        extended = true;
        ignoreDups = true;
        ignoreSpace = true;
        share = true;
        size = 999999;
        path = "$HOME/.local/state/zsh/history";
      };

      plugins = [
      ];

      oh-my-zsh = {
        enable = true;
        plugins = [
          "alias-finder"
          "colored-man-pages"
          "colorize"
          "copyfile"
          "copypath"
          "direnv"
          "docker-compose"
          "docker"
          "extract"
          "gh"
          "git"
          "golang"
          "ssh"
          "sudo"
        ];
        custom = ''
        '';
      };

      sessionVariables = {
        XDG_DATA_HOME = "$HOME/.local/share";
        XDG_CONFIG_HOME = "$HOME/.config";
        XDG_STATE_HOME = "$HOME/.local/state";
        XDG_CACHE_HOME = "$HOME/.cache";
      };

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
    };

    home.packages = with pkgs; [
    ];

    programs.zsh.initContent = lib.mkOrder 500 ''
    '';

    programs.zsh.siteFunctions = {
      src = lib.mkOrder 5 ''
        src() {
          if [ -d "$HOME/src" ]; then
            cd "$HOME/src"
          else
            echo "No $HOME/src"
            return 1
          fi
        }
      '';

      srccfg = lib.mkOrder 6 ''
        cfg() {
          if [ -d "$HOME/.config" ]; then
            cd "$HOME/.config"
          else
            echo "No $HOME/.config"
            return 1
          fi
        }
      '';

      srcgh = lib.mkOrder 7 ''
        srcgh() {
          if [ -d "$HOME/src/gh" ]; then
            cd "$HOME/src/gh"
          else
            echo "No $HOME/src/gh"
            return 1
          fi
        }
      '';

      srcsd = lib.mkOrder 8 ''
        srcsd() {
          if [ -d "$HOME/src/sd" ]; then
            cd "$HOME/src/sd"
          else
            echo "No $HOME/src/sd"
            return 1
          fi
        }
      '';

      changelog = lib.mkOrder 9 ''
        changelog() {
          if [ -f "$HOME/src/scripts/changelog/changelogger.sh" ]; then
            "$HOME/src/scripts/changelog/changelogger.sh" "$@"
          else
            echo "changelog script missing"
            return 1
          fi
        }
      '';

      vld = lib.mkOrder 11 ''
        vld() {
          if [ -d "/var/local/data" ]; then
            cd /var/local/data
          else
            echo "No /var/local/data"
            return 1
          fi
        }
      '';

      vldb = lib.mkOrder 12 ''
        vldb() {
          if [ -d "/var/local/db" ]; then
            cd /var/local/db
          else
            echo "No /var/local/db"
            return 1
          fi
        }
      '';

      vlds = lib.mkOrder 13 ''
        vlds() {
          if [ -d "/var/local/data/_system" ]; then
            cd /var/local/data/_system
          else
            echo "No /var/local/data/_system"
            return 1
          fi
        }
      '';

      wifi_scan = lib.mkOrder 14 ''
        wifi_scan() {
          if command -v nmcli >/dev/null 2>&1; then
            nmcli device wifi rescan && nmcli device wifi list
          else
            echo "nmcli not available"
            return 1
          fi
        }
      '';

      derp = lib.mkOrder 15 ''
        derp() {
          if command -v curl >/dev/null 2>&1; then
            curl "https://cht.sh/$1"
          else
            echo "curl not available"
            return 1
          fi
        }
      '';

      weather = lib.mkOrder 16 ''
        weather() {
          if command -v curl >/dev/null 2>&1; then
            curl -sSL "https://wttr.in?F"
          else
            echo "curl not available"
            return 1
          fi
        }
      '';

      grep = lib.mkOrder 17 ''
        grep() {
          command grep --color=auto "$@"
        }
      '';

      ports = lib.mkOrder 18 ''
        ports() {
          if command -v netstat >/dev/null 2>&1; then
            netstat -tulanp "$@"
          else
            echo "netstat not available"
            return 1
          fi
        }
      '';

      tree = lib.mkOrder 19 ''
        tree() {
          if command -v tree >/dev/null 2>&1; then
            tree -Cs "$@"
          else
            echo "tree not available"
            return 1
          fi
        }
      '';

      frg = lib.mkOrder 10 ''
if command -v "rg" &>/dev/null && command -v "fzf" &>/dev/null && command -v "bat" &>/dev/null; then
  frg() {
    result=$(rg --ignore-case --color=always --line-number --no-heading "$@" |
      fzf --ansi \
          --color 'hl:-1:underline,hl+:-1:underline:reverse' \
          --delimiter ':' \
          --preview "bat --color=always {1} --theme='Solarized (light)' --highlight-line {2}" \
          --preview-window 'up,60%,border-bottom,+{2}+3/3,~3')
    file=$(echo "$result" | cut -d: -f1)
    linenumber=$(echo "$result" | cut -d: -f2)
    if [ -n "$file" ]; then
      $EDITOR +"$linenumber" "$file"
    fi
  }
fi
'';

      sir = lib.mkOrder 20 ''
if command -v "rg" &>/dev/null; then
  sir() {
    if [ -z "$1" ] || [ -z "$2" ] ; then echo "Search inside Replace: sir <find_string_named> <sring_replaced>" ; return 1 ; fi
    for file in $(rg -l "$1") ; do
      sed -i "s|$1|$2|g" "$file"
    done
  }
fi
'';

      _sysls = lib.mkOrder 30 ''
if command -v "fzf" &>/dev/null; then
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
fi
'';

      sysexec = lib.mkOrder 40 ''
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
'';

      far = lib.mkOrder 50 ''
far() {
  if [ -z "$1" ] || [ -z "$2" ] ; then echo "Rename files: far <find_file_named> <file_renamed>" ; return 1 ; fi
  for file in $(find -name "$1") ; do
    mv "$file" "$(dirname "$file")/$2"
  done
}
'';

      man = lib.mkOrder 60 ''
man() {
  LESS_TERMCAP_md=$'\e[01;31m' \
  LESS_TERMCAP_me=$'\e[0m' \
  LESS_TERMCAP_se=$'\e[0m' \
  LESS_TERMCAP_so=$'\e[01;44;33m' \
  LESS_TERMCAP_ue=$'\e[0m' \
  LESS_TERMCAP_us=$'\e[01;32m' \
  command man "$@"
}
'';

      system_update = lib.mkOrder 70 ''
system_update() {
  update_system() {
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
'';

      resetcow = lib.mkOrder 80 ''
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

      days_from_epoch = lib.mkOrder 90 ''
days_from_epoch() {
  local input_date="$1"
  if [[ "$input_date" =~ ^[0-9]{8}$ ]]; then
    input_date="''${input_date:0:4}-''${input_date:4:2}-''${input_date:6:2}"
  fi
  echo $(( $(date -d "$input_date" +%s) / 86400 ))
}
'';

      timestamp = lib.mkOrder 100 ''
timestamp() {
  case "''${1,,}" in
    date )
      local f="$2";
      local d="$3";
      touch -t "$(date -d "$d" +%Y%m%d)$(date -r "$f" +%H%M.%S)" "$f"
    ;;
  esac
}
'';
    };
  };
}
