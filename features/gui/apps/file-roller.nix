{ config, pkgs, ...}:
{
  home = {
    packages = with pkgs;
      [
        gnome.file-roller
      ];
  };
}
