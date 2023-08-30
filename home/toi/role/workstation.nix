{ config, lib, pkgs, ... }:
with lib;
{
  imports = [
  ];

  host = {
    home = {
      applications = {
        act.enable = mkDefault true;
        android-tools.enable = mkDefault true;
        calibre.enable = mkDefault true;
        docker-compose = mkDefault true;
        encfs.enable = mkDefault false;
        nextcloud-client.enable = mkDefault true;
        tea.enable = mkDefault true;
      };
      feature = {

      };
      service = {
        decrypt_encfs_workspace = mkDefault true;
        vscode-server.enable = mkDefault true;
      };
    };
  };
}