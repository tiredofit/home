{ inputs, config, lib, pkgs, ... }:
with lib;
{
  home = {
    activation = {
      report-changes = ''
        PATH=$PATH:${lib.makeBinPath [ pkgs.nvd pkgs.nix ]}
        if [ ! -d /nix/var/nix/profiles/per-user/$USER ]; then
            if [ -d $HOME/.local/state/nix/profiles ] ; then
                PROFILE_PATH="$HOME/.local/state/nix/profiles"
            else
                PROFILE_PATH=null
            fi
        else
            PROFILE_PATH="/nix/var/nix/profiles/per-user/$USER"
        fi

        if [ -n "$PROFILE_PATH" ] && [ "$PROFILE_PATH" != "null" ]; then
            mkdir -p $HOME/.local/state/home-manager/logs
            if [ $(ls "$PROFILE_PATH"/profile-*-link 2> /dev/null | wc -l) -gt 0 ]; then
                ${pkgs.nvd}/bin/nvd diff $(ls -dv $PROFILE_PATH/profile-*-link | tail -2)
                nvd diff $(ls -dv $PROFILE_PATH/profile-*-link | tail -2) > "$HOME/.local/state/home-manager/logs/$(date +'%Y%m%d%H%M%S')-$USER-$(ls -dv $PROFILE_PATH/profile-*-link | tail -1 | cut -d '-' -f 3)-$(readlink $(ls -dv $PROFILE_PATH/profile-*-link | tail -1)| cut -d / -f 4 | cut -d - -f 1).log"
            elif [ $(ls "$PROFILE_PATH"/home-manager-*-link 2> /dev/null | wc -l) -gt 0 ]; then
                ${pkgs.nvd}/bin/nvd diff $(ls -dv $PROFILE_PATH/home-manager-*-link | tail -2)
                nvd diff $(ls -dv $PROFILE_PATH/home-manager-*-link | tail -2) > "$HOME/.local/state/home-manager/logs/$(date +'%Y%m%d%H%M%S')-$USER-$(ls -dv $PROFILE_PATH/home-manager-*-link | tail -1 | cut -d '-' -f 3)-$(readlink $(ls -dv $PROFILE_PATH/home-manager-*-link | tail -1)| cut -d / -f 4 | cut -d - -f 1).log"
            fi
        else
            echo "ERROR - Can't write Home-Manager generation log file"
        fi
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
