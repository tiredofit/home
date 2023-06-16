{ pkgs, config, lib, ...}:
{

  home = {
    file = {
      # ".config/whaever".source =  ../../../dotfiles/whatever;
    };

    packages = with pkgs;
      [
        encfs
        gencfsm
      ]
      ++ (lib.optionals pkgs.stdenv.isLinux [
      ]);
  };

  programs = {

  };

}
