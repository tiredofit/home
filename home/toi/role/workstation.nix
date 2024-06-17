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
        calibre = {
          enable = mkDefault true;
          defaultApplication.enable = mkDefault true;
        };
        docker-compose.enable = mkDefault true;
        git.enable = mkDefault true;
        encfs.enable = mkDefault false;
        neovim.enable = mkDefault false;
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

  xdg = {
    mimeApps = {
      enable = mkDefault true;
    };
  };
}
