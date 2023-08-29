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
    ../../features/gui/apps/gnome-encfs-manager.nix
    ../../features/gui/apps/nextcloud-desktop.nix
    ../../features/gui/apps/masterpdfeditor.nix
    ../../features/gui/apps/opensnitch-ui.nix
    ../../features/gui/apps/sqlitebrowser.nix
    ../../features/gui/apps/virt-manager.nix
  ];

  host = {
    home = {
      applications = {
        calibre.nix = true;
        chromium.enable = true;
        diffuse.enable = true;
        drawio.enable = true;
        eog.enable = true;
        ferdium.enable = true;
        greenclip.enable = true;
        gparted.enable = true;
        libreoffice.enable = true;
        mate-calc.enable = true
        pinta.enable = true;
        seahorse.enable = true;
        smartgit.enable = true;
        thunderbird.enable = true;
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