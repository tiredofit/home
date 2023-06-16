{ config, pkgs, ...}:
{
  home = {
    file = {
      ".config/draw-io/config.json".source = ../../../dotfiles/draw-io/config.json;
      ".config/draw-io/Prefrences".source = ../../../dotfiles/draw-io/Preferences;
    };

    packages = with pkgs;
      [
        drawio
      ];
  };
}
