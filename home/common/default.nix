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
    ../../features/cli/file-compression.nix
    ../../features/cli/sops.nix
    ]
    ++ optionals ( role == "workstation" ) [
      ../../features/cli/direnv.nix
      ../../features/cli/nix-index.nix
      ../../features/gui/desktop/${windowmanager}.nix
      ../../features/gui/fonts.nix
    ];

    host = {
      home = {
        applications = {
          act.enable = true;
          android-tools.enable = true;
          bat.enable = true;
          blueman.enable = true;
          btop.enable = true;
          chromium.enable = true;
          comma.enable = true;
          diceware.enable = true;
          diffuse.enable = true;
          docker-compose = true;
          drawio.enable = true;
          duf.enable = true;
          dust.enable = true;
          encfs.enable = true;
          eog.enable = true;
          file-roller.enable = true;
          firefox.enable = true;
          ferdium.enable = true;
          flameshot.enable = true;
          fzf.enable = true;
          github-client.enable = true;
          gnome-system-monitor.enable = true;
          geeqie.enable = true;
          git.enable = true;
          gnupg.enable = true;
          gparted.enable = true;
          greenclip.enable = true;
          htop.enable = true;
          hugo.enable = true;
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
          neovim.enable = true;
          nextcloud-client.enable = true;
          pinta.enable = true;
          ranger.enable = true;
          restic.enable = true;
          rclone.enable = true;
          ripgrep.enable = true;
          seahorse.enable = true;
          smplayer.enable = true;
          thunar.enable = true;
          tmux.enable = true;
          virt-manager.enable = true;
          vivaldi.enable = true; # Workstation
          wget.enable = true;
          yt-dlp.enable = true;
          zathura.enable = true;
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

