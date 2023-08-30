{ config, lib, pkgs, ... }:
with lib;
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