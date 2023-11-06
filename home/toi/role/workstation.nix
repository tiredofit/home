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
        docker-compose.enable = mkDefault true;
        git.enable = mkDefault true;
        encfs.enable = mkDefault false;
        neovim.enable = mkDefault true;
        nextcloud-client.enable = mkDefault true;
        tea.enable = mkDefault true;
      };
      feature = {

      };
      service = {
        decrypt_encfs_workspace.enable = mkDefault true;
        vscode-server.enable = mkDefault true;
      };
    };
  };
}