{ config, lib, pkgs, ... }:
with lib;
{
  imports = [
  ];

  host = {
    home = {
      applications = {
        docker-compose.enable = mkDefault true;
        lazydocker.enable = mkDefault true;
      };
      feature = {
      };
      service = {
      };
    };
  };
}
