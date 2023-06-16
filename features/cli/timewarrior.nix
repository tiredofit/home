{ config, pkgs, ...}:
{
  home = {
    packages = with pkgs;
      [
        timewarrior
      ];
  };
}
