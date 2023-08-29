{ config, lib, pkgs, ... }:
{
  imports = [
    ../../features/cli/android-tools.nix
    ../../features/cli/encfs.nix
    ../../features/cli/gh.nix
    ../../features/cli/hugo.nix
    ../../features/cli/nmap.nix
    ../../features/cli/yt-dlp.nix
    ../../features/services/decrypt_encfs_workspace.nix
  ];

  host = {
    home = {
      applications = {
        blueman.enable = true;
        calibre.enable = true;
        chromium.enable = true;
        diffuse.enable = true;
        drawio.enable = true;
        eog.enable = true;
        ferdium.enable = true;
        firefox.enable = true;
        flameshot.enable = true;
        gnome-system-monitor.enable = true;
        gnome-encfs-manager.enable = true;
        greenclip.enable = true;
        gparted.enable = true;
        kitty.enable = true;
        libreoffice.enable = true;
        master-pdf-editor.enable = true;
        mate-calc.enable = true;
        nextcloud-client.enable = true;
        opensnitch-ui.enable = true;
        pinta.enable = true;
        seahorse.enable = true;
        smartgit.enable = true;
        smplayer.enable = true;
        sqlite-browser.enable = true;
        thunar.enable = true;
        thunderbird.enable = true;
        virt-manager.enable = true;
        wps-office.enable = true;
        zoom.enable = true;
      };
    };
  };

  home = {
    packages = with pkgs;
      [
        tea
      ];
  };
}