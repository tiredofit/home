{ config, pkgs, lib, ...}:
{

  home = {
    file = {
      # ".config/whaever".source =  ../../../dotfiles/whatever;
    };

    packages = with pkgs;
      [
        android-tools
      ]
      ++ (lib.optionals pkgs.stdenv.isLinux [
      ]);
  };

  programs = {
    bash = {
      sessionVariables = {
        ANDROID_HOME="${config.xdg.dataHome}/android" ;
      };
    };
  };
}
