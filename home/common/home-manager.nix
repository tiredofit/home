{ config, lib, pkgs, ... }:
with lib;
{
  home = {
    activation = {
      profile_directories_state_create = ''
        if [ -d "$HOME"/.cache ]; then
            mkdir -p "$HOME"/.cache
        fi

        if [ -d "$HOME"/.local/share ]; then
            mkdir -p "$HOME"/.local/share
        fi

        if [ -d "$HOME"/.local/state ]; then
            mkdir -p "$HOME"/.local/state
        fi

        if [ -d "$HOME"/.config ]; then
            mkdir -p "$HOME"/.config
        fi
      '';
    };
    stateVersion = mkDefault "23.11";
  };

  manual.manpages.enable = mkDefault false;
  news.display = mkDefault "show";

  programs = {
    bash = {
      initExtra = ''
        if [ -d "~/src/nixos" ]; then
          alias nixos="cd ~/src/nixos"
          alias nixosupdate="sudo nix flake update $HOME/src/nixos/ --extra-experimental-features 'nix-command flakes'"
          alias nixswitch="sudo nixos-rebuild switch --flake $HOME/src/nixos/#$HOSTNAME $@"
        fi
      '';
    };
    home-manager = {
      enable = mkForce true;
    };
  };
}
