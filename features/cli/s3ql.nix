{ config, pkgs, ...}:
{

  home = {
    packages = with pkgs;
      [
        s3ql
      ];
  };
}
