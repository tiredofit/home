{ config, pkgs, lib, ...}:
{

  home = {
    file = {
    };

    packages = with pkgs;
      [

      ]
      ++ (lib.optionals pkgs.stdenv.isLinux [
      ]);
  };

  programs = {

  };

}
