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
    ../../features/cli/bash.nix
    ../../features/cli/comma.nix
    ../../features/cli/diceware.nix
    ../../features/cli/docker-compose.nix
    ../../features/cli/duf.nix
    ../../features/cli/dust.nix
    ../../features/cli/file-compression.nix
    ../../features/cli/git.nix
    ../../features/cli/gnupg.nix
    ../../features/cli/ripgrep.nix
    ../../features/cli/sops.nix
    ../../features/cli/wget.nix
    ]
    ++ optionals ( role == "workstation" ) [
      ../../features/cli/direnv.nix
      ../../features/cli/nix-index.nix
      ../../features/cli/zathura.nix
      ../../features/gui/desktop/${windowmanager}.nix
      ../../features/gui/fonts.nix
    ];

    host = {
      home = {
        applications = {
          act.enable = true;
          bat.enable = true;
          blueman.enable = true;
          btop.enable = true;
          chromium.enable = true;
          diffuse.enable = true;
          drawio.enable = true;
          eog.enable = true;
          file-roller.enable = true;
          firefox.enable = true;
          ferdium.enable = true;
          flameshot.enable = true;
          fzf.enable = true;
          gnome-system-monitor.enable = true;
          geeqie.enable = true;
          gnupg.enable = true;
          gparted.enable = true;
          greenclip.enable = true;
          htop.enable = true;
          jq.enable = true;
          kitty.enable = true;
          lazygit.enable = true;
          less.enable = true;
          lsd.enable = true;
          libreoffice.enable = true;
          liquidprompt.enable = true;
          mate-calc.enable = true;
          mp3gain.enable = true;
          nano.enable = true;
          neofetch.enable = true;
          ncdu.enable = true;
          nmap.enable = true;
          nextcloud-client.enable = true;
          pinta.enable = true;
          ranger.enable = true;
          seahorse.enable = true;
          smplayer.enable = true;
          thunar.enable = true;
          tmux.enable = true;
          virt-manager.enable = true;
          vivaldi.enable = true; # Workstation
          yt-dlp.enable = true;
          zoxide.enable = true;
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

