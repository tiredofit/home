{ config, lib, pkgs, ... }:
{
  imports = [
    ../../features/cli/android-tools.nix
    ../../features/cli/encfs.nix
    ../../features/gui/apps/geeqie.nix
    ../../features/cli/gh.nix
    ../../features/cli/hugo.nix
    ../../features/cli/nmap.nix
    ../../features/cli/yt-dlp.nix
    ../../features/services/decrypt_encfs_workspace.nix
    ../../features/gui/apps/calibre.nix
    ../../features/gui/apps/gnome-encfs-manager.nix
    ../../features/gui/apps/nextcloud-desktop.nix
    ../../features/gui/apps/masterpdfeditor.nix
    ../../features/gui/apps/opensnitch-ui.nix
    ../../features/gui/apps/smartgit.nix
    ../../features/gui/apps/sqlitebrowser.nix
    ../../features/gui/apps/thunderbird.nix
    ../../features/gui/apps/virt-manager.nix
    ../../features/gui/apps/wpsoffice.nix
    ../../features/gui/apps/zoom.nix
  ];

  home = {
    packages = with pkgs;
      [
        tea
      ];
  };
}