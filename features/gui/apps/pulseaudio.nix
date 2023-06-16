{ pkgs, config, lib, ...}:
{

  home = {
    file = {
      # ".config/whaever".source =  ../../../dotfiles/whatever;
    };

    packages = with pkgs;
      [
        pulsemixer
      ]
      ++ (lib.optionals pkgs.stdenv.isLinux [
      ]);
  };
}
