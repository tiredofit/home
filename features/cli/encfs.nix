{ pkgs, ...}:
{
  home = {
    packages = with pkgs;
      [
        encfs
      ];
  };
}
