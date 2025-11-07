{ config, lib, pkgs, ... }:
with lib;
{
  imports = [
  ];

  host = {
    home = {
      applications = {
        blanket.enable = mkDefault true;
        cryfs.enable = mkDefault true;
        docker-compose.enable = mkDefault true;
        nextcloud-client.enable = mkDefault true;
        networkmanager = {
          enable = mkDefault true;
          systemtray.enable = mkDefault false;
        };
        shikane.enable = mkDefault true;
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
