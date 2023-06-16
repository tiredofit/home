{ config, pkgs, ...}:
{
  home = {
    packages = with pkgs;
      [
        ripgrep
      ];
  };

  ## TODO - This isn't in 23.05
  programs = {
    #ripgrep = {
    #  enable = false;
    #};
  };
}
