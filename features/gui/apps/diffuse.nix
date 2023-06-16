{ config, pkgs, ...}:
{
  home = {
    packages = with pkgs;
      [
        diffuse
      ];
  };
}
