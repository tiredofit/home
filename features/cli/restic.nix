{ config, pkgs, ...}:
{
    packages = with pkgs;
      [
        restic
      ];
  };
}
