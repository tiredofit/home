{ config, pkgs, lib, ...}:
{
  home = {
    file = {
      # ".config/whaever".source =  ../../../dotfiles/whatever;
    };

    packages = with pkgs;
      [
        mp3gain
      ]
      ++ (lib.optionals pkgs.stdenv.isLinux [
      ]);
  };

  programs = {

  };

}
