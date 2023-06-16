{ pkgs, config, lib, ...}:
{
  home = {
    packages = with pkgs;
      [
        gnome.seahorse
      ];
  };
}
