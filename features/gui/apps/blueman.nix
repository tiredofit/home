{ config, pkgs, ...}:
{

  home = {
    file = {
    };

    packages = with pkgs;
      [
        blueman
      ];
  };
}
