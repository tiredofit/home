{ config, lib, pkgs, ... }:
with lib;
{
  imports = [
  ];

  host = {
    home = {
      applications = {
        android-tools.enable = mkDefault true;
        blueman.enable = mkDefault true;
        calibre = {
          enable = mkDefault false;
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
        ferdium.enable = mkDefault true;
        firefox = {
          enable = mkDefault true;
          defaultApplication.enable = mkDefault true;
        };
        gnome-system-monitor.enable = mkDefault true;
        gparted.enable = mkDefault true;
        kitty.enable = mkDefault true;
        libreoffice.enable = mkDefault true;
        master-pdf-editor.enable = mkDefault true;
        mate-calc.enable = mkDefault true;
        nemo.enable = mkDefault true;
        pinta.enable = mkDefault true;
        pulsemixer.enable = mkDefault true;
        pwvucontrol.enable = mkDefault true;
        qview = {
          enable = mkDefault true;
          defaultApplication.enable = mkDefault true;
        };
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
        vscode-server.enable = mkDefault true;
      };
    };
  };
}

