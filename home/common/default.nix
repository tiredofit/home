{ config, inputs, lib, pkgs, specialArgs, ... }:

let
  inherit (specialArgs) role windowmanager;
in
with lib;
{
  imports = [
    ./colours.nix
    ./home-manager.nix
    ./locale.nix
    ./nix.nix
    #../../features/cli/nix.nix # FIXME This is putting a secret for github
    ../../features/cli/act.nix
    ../../features/cli/bash.nix
    ../../features/cli/bat.nix
    ../../features/cli/btop.nix
    ../../features/cli/comma.nix
    ../../features/cli/diceware.nix
    ../../features/cli/docker-compose.nix
    ../../features/cli/duf.nix
    ../../features/cli/dust.nix
    ../../features/cli/file-compression.nix
    ../../features/cli/fzf.nix
    ../../features/cli/git.nix
    ../../features/cli/gnupg.nix
    ../../features/cli/htop.nix
    ../../features/cli/jq.nix
    ../../features/cli/lazygit.nix
    ../../features/cli/less.nix
    ../../features/cli/liquidprompt.nix
    ../../features/cli/lsd.nix
    ../../features/cli/nano.nix
    ../../features/cli/ncdu.nix
    ../../features/cli/neofetch.nix
    ../../features/cli/ranger.nix
    ../../features/cli/ripgrep.nix
    ../../features/cli/sops.nix
    ../../features/cli/tmux.nix
    ../../features/cli/wget.nix
    ../../features/cli/zoxide.nix
    ]
    ++ optionals ( role == "workstation" ) [
      ../../features/cli/direnv.nix
      ../../features/cli/nix-index.nix
      ../../features/cli/zathura.nix
      ../../features/gui/apps/blueman.nix
      ../../features/gui/apps/gnome-system-monitor.nix
      ../../features/gui/apps/gparted.nix
      ../../features/gui/apps/vivaldi.nix
      ../../features/gui/desktop/${windowmanager}.nix
      ../../features/gui/fonts.nix
      ../../features/gui/apps/chromium.nix
      ../../features/gui/apps/diffuse.nix
      ../../features/gui/apps/drawio.nix
      ../../features/gui/apps/eog.nix
      ../../features/gui/apps/ferdium.nix
      ../../features/gui/apps/firefox.nix
      ../../features/gui/apps/flameshot.nix
      ../../features/gui/apps/firefox.nix
      ../../features/gui/apps/kitty.nix
      ../../features/gui/apps/libreoffice.nix
      ../../features/gui/apps/mate-calc.nix
      ../../features/gui/apps/smplayer.nix
      ../../features/gui/apps/thunar.nix
      ../../features/gui/apps/vscode.nix
    ];

    host = {
      home = {
        applications = {
          file-roller.enable = true;
          pinta.enable = true;
        };
      };
    };

    home = {
      packages = with pkgs;
        [
          nixfmt
          xmlstarlet
          yq-go
        ]
        ++ lib.optionals ( role == "workstation" ) [
#          hadolint
          mtr
          shellcheck
          shfmt
          xdg-ninja
        ]
        ++ lib.optionals ( role == "workstation" || role == "server" )
        [

        ]
        ++ (lib.optionals pkgs.stdenv.isLinux
        [
          psmisc
          strace
        ]);
    };
}

