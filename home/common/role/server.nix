{ config, lib, pkgs, ... }:
{
  imports = [
  ];

  host = {
    home = {
      applications = {
        docker-compose = mkDefault true;
      };
      feature = {

      };
      service = {
      }
    };
  };
}