{ pkgs, config, ...}:
{
  home = {
    file = {
      ".config/swaync".source = ../../../dotfiles/swaync/config.json;
    };

    packages = with pkgs;
      [
        swaynotificationcenter
      ];
  };
}
