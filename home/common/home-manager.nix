{ config, pkgs, ... }:
{
  home = {
    stateVersion = "23.11";
  };

  manual.manpages.enable = false;
  news.display = "show";

  programs = {
    home-manager = {
      enable = true;
    };
  };
}
