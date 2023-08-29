{ config, lib, pkgs, ... }:
{
  imports = [
  ];

  host = {
    home = {
      applications = {
        android-tools.enable = true;
        blueman.enable = true;
        calibre.enable = true;
        chromium.enable = true;
        diffuse.enable = true;
        drawio.enable = true;
        encfs.enable = true;
        eog.enable = true;
        ferdium.enable = true;
        firefox.enable = true;
        flameshot.enable = true;
        gh.enable = true;
        gnome-encfs-manager.enable = true;
        gnome-system-monitor.enable = true;
        gparted.enable = true;
        greenclip.enable = true;
        hugo.enable = true;
        kitty.enable = true;
        libreoffice.enable = true;
        master-pdf-editor.enable = true;
        mate-calc.enable = true;
        nextcloud-client.enable = true;
        nmap.enable = true;
        opensnitch-ui.enable = true;
        pinta.enable = true;
        pulsemixer.enable = true;
        seahorse.enable = true;
        smartgit.enable = true;
        smplayer.enable = true;
        sqlite-browser.enable = true;
        thunar.enable = true;
        thunderbird.enable = true;
        virt-manager.enable = true;
        visual-studio-code.enable = true;
        wps-office.enable = true;
        yt-dlp.enable = true;
        zoom.enable = true;
      };
      service = {
        decrypt_encfs_workspace = true;
        vscode-server.enable = true;
      }
    };
  };

  home = {
    packages = with pkgs;
      [
        tea
      ];
  };
}