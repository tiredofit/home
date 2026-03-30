{ config, lib, pkgs, ... }:
## Generic bash module (no user-specific aliases/functions)
let
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

        shellOptions = [
          "autocd"
        ];
      };
    };
  };
}
