{ config, lib, pkgs, ... }:
with lib;
{
  imports = [
  ];

  host = {
    home = {
      applications = {
        cryfs.enable = mkDefault true;
        docker-compose.enable = mkDefault true;
        git.enable = mkDefault true;
        nextcloud-client.enable = mkDefault true;
        networkmanager = {
          enable = mkDefault true;
          systemtray.enable = mkDefault false;
        };
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
