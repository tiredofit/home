{ config, lib, pkgs, ... }:
with lib;
{
  imports = [
  ];

  host = {
    home = {
      applications = {
        docker-compose.enable = mkDefault true;
        git.enable = mkDefault true;
        neovim.enable = mkDefault true;
        tea.enable = mkDefault true;
      };
      feature = {

      };
      service = {
        vscode-server.enable = mkDefault true;
      };
    };
  };
}