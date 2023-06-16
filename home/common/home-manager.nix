{ config, pkgs, ... }:
{
  home = {
    stateVersion = "23.11";
  };

  news.display = "show";

  programs = {
    home-manager = {
      enable = true;
    };
  };
}
