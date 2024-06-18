{ config, lib, pkgs, ... }:
with lib;
{
  imports = [
  ];

  host = {
    home = {
      applications = {
        android-tools.enable = mkDefault true;
        ark = {
          enable = mkDefault false;
          defaultApplication.enable = mkDefault true;
        };
        bleachbit.enable = mkDefault true;
        blueman.enable = mkDefault true;
        calibre = {
          enable = mkDefault true;
          defaultApplication.enable = mkDefault true;
        };
        chromium.enable = mkDefault true;
        comma.enable = mkDefault true;
        diffuse = {
          enable = mkDefault true;
          defaultApplication.enable = mkDefault true;
        };
        drawio = {
          enable = mkDefault true;
          defaultApplication.enable = mkDefault true;
        };
        eog = {
          enable = mkDefault true;
          defaultApplication.enable = mkDefault true;
        };
        ferdium.enable = mkDefault true;
        firefox = {
          enable = mkDefault true;
          defaultApplication.enable = mkDefault true;
        };
        geeqie.enable = mkDefault true;
        gnome-system-monitor.enable = mkDefault true;
        gparted.enable = mkDefault true;
        kitty.enable = mkDefault true;
        lazygit.enable = mkDefault true;
        libreoffice.enable = mkDefault true;
        master-pdf-editor.enable = mkDefault true;
        mate-calc.enable = mkDefault true;
        nemo.enable = mkDefault true;
        pinta.enable = mkDefault true;
        pulsemixer.enable = mkDefault true;
        remmina = {
          enable = mkDefault true;
          defaultApplication.enable = mkDefault true;
        };
        seahorse.enable = mkDefault true;
        tea.enable = mkDefault true;
        vlc = {
          enable = mkDefault true;
          defaultApplication.enable = mkDefault true;
        };
        wps-office.enable = mkDefault true;
      };
      feature = {
        fonts.enable = mkDefault true;
        mime.defaults.enable = mkDefault true;
        theming.enable = mkDefault true;
      };
      service = {
        decrypt_encfs_workspace.enable = mkDefault true;
        vscode-server.enable = mkDefault true;
      };
    };
  };
}

