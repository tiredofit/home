{ config, lib, pkgs, ... }:

let
  shellAliases = {
    ".." = "cd ..";
    "..." = "cd ...";
    dotfiles = "cd ~/.config/home-manager/dotfiles";
    home = "cd ~";
    fuck = "sudo $(history -p !!)"; # run last command as root
    mkdir = "mkdir -p"; # no error, create parents
    scstart = "systemctl start $@"; # systemd service start
    scstop = "systemctl stop $@"; # systemd service stop
    scenable = "systemctl disable $@"; # systemd service enable
    scdisable = "systemctl disable $@"; # systemd service disable
  };
  cfg = config.host.home.applications.bash;
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
        bash_history_state_create = ''
          if [ -d "$HOME"/.local/state/bash ]; then
              mkdir -p "$HOME"/.local/state/bash
              chown -R $USER "$HOME"/.local/state/bash
          fi
        '';
      };

      packages = with pkgs; [ bashInteractive ];
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

          if [ -d "/home/$USER/src/home" ] ; then
              alias hm="cd ~/src/home"
              alias hmupdate="nix flake update $HOME/src/home --extra-experimental-features 'nix-command flakes'"
              alias hmswitch="home-manager switch --flake $HOME/src/home/#$HOSTNAME.$USER --extra-experimental-features 'nix-command flakes' $@"
          fi

          if [ -d "/home/$USER/src/nixos" ] ; then
              alias nixos="cd ~/src/nixos"
              alias nixosupdate="sudo nix flake update $HOME/src/nixos/ --extra-experimental-features 'nix-command flakes'"
              alias nixswitch="sudo nixos-rebuild switch --flake $HOME/src/nixos/#$HOSTNAME $@"
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

          if [ -d "$XDG_RUNTIME_DIR/secrets/bashrc.d" ] ; then
            for script in $XDG_RUNTIME_DIR/secrets/bashrc.d/* ; do
                source $script
            done
          fi

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
