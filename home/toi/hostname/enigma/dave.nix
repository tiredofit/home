{ config, lib, pkgs, ... }:
{
  host = {
    home = {
      applications = {
        herdr.enable = true;
      };
    };
  };
}
