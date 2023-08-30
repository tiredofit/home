{ inputs, config, lib, pkgs, ... }:
with lib;
{
  home = {
    activation = {
      report-changes = ''
        PATH=$PATH:${lib.makeBinPath [ pkgs.nvd pkgs.nix ]}
        mkdir -p $HOME/.local/state/home-manager/logs
        ${pkgs.nvd}/bin/nvd diff $(ls -dv /nix/var/nix/profiles/per-user/$USER/profile-*-link | tail -2)
        nvd diff $(ls -dv /nix/var/nix/profiles/per-user/$USER/profile-*-link | tail -2) > "$HOME/.local/state/home-manager/logs/$(date +'%Y%m%d%H%M%S')-$USER-$(ls -dv /nix/var/nix/profiles/per-user/$USER/profile-*-link | tail -1 | cut -d '-' -f 3)-$(readlink $(ls -dv /nix/var/nix/profiles/per-user/$USER/profile-*-link | tail -1)| cut -d / -f 4 | cut -d - -f 1).log"
      '';
    };
  };

  nix = {
    settings = {
      auto-optimise-store = mkDefault true;
      experimental-features = [ "nix-command" "flakes" "repl-flake" ];
      warn-dirty = mkDefault false;
    };

    package = pkgs.nixFlakes;
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;
  };

  nixpkgs = {
    config = {
      allowUnfree = mkDefault true;
      allowUnfreePredicate = (_: true);
    };
  };

  programs = {
    bash = {
      initExtra = ''
        if [ -f "$XDG_RUNTIME_DIR"/secrets/gh_token ] ; then
            export NIX_CONFIG="access-tokens = github.com=$(cat $XDG_RUNTIME_DIR/secrets/gh_token)"
        fi
      '';
    };

    nix-index = {
      enable = mkDefault true;
      enableBashIntegration = mkDefault true;
    };
  };
}
