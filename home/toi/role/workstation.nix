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
        nextcloud-client.enable = mkDefault true;
      };
      feature = {
      };
      service = {
      };
    };
  };

  xdg = {
    mimeApps = {
      enable = mkDefault true;
    };
  };
}
