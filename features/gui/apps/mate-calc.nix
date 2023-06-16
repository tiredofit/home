{ pkgs, config, ...}:
{
  home = {
    packages = with pkgs;
      [
        mate.mate-calc
      ];
  };
}
