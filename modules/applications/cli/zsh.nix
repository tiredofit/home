{ config, lib, pkgs, ... }:
## PERSONALIZE
let
  cfg = config.host.home.applications.zsh;
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
      #packages = with pkgs; [
      #  zshInteractive
      #];
    };

    programs.zsh = {
      enable = true;
      #zsh-autoenv.enable = mkDefault true;
      #enableBashCompletion = true;
      enableCompletion = mkDefault true;
      autosuggestion.enable = mkDefault true;
      syntaxHighlighting.enable = mkDefault true;
      history = {
        size = 999999;
        path = "$HOME/.local/state/zsh/history";
      };
      plugins = [
        {
          name = "powerlevel10k";
          src = pkgs.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
        {
          name = "powerlevel10k-config";
          src = lib.cleanSource ../../../dotfiles/p10k;
          file = "p10k.zsh";
        }
      ];
      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "sudo"
          "docker"
        ];
        custom = ''
        '';
      };
    };

    home.packages = with pkgs; [
      zsh-powerlevel10k  # Ensure only zsh-powerlevel10k is included
    ];

    programs.zsh.initContent = ''
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi
    '';

  };
}