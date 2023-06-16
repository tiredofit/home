{ pkgs, config, lib, ...}:
{
  home = {
    packages = with pkgs;
      [
        pinta
      ];
  };
}
