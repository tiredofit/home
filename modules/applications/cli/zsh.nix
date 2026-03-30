{ config, lib, pkgs, ... }:
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
      };
    };

    programs.zsh = {
      enable = true;
      autocd = mkDefault true;
      enableCompletion = mkDefault true;
      autosuggestion.enable = mkDefault true;
      syntaxHighlighting.enable = mkDefault true;
      history = {
        extended = mkDefault true;
        ignoreDups = mkDefault true;
        ignoreSpace = mkDefault true;
        share = mkDefault true;
        size = mkDefault 999999;
        path = "$HOME/.local/state/zsh/history";
      };
    };
  };
}
