{ pkgs, config, lib, ...}:
{

  home = {
    file = {
      ".config/flameshot/flameshot.ini".source = ../../../dotfiles/flameshot/flameshot.ini;
    };

    packages = with pkgs;
      [
        flameshot
      ];
  };
}
