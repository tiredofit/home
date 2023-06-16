{ config, pkgs, lib, ...}:
{

  home = {
    file = {
      # ".config/whaever".source =  ../../../dotfiles/whatever;
    };

    packages = with pkgs;
      [
        nmap
      ]
      ++ (lib.optionals pkgs.stdenv.isLinux [
      ]);
  };

  programs = {

  };

}
