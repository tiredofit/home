{ pkgs, config, lib, ...}:
{
  home = {

    packages = with pkgs;
      [
        thunderbird
      ];
  };

  programs = {
    thunderbird = {
      enable = false;
      ## TODO - This needs conversion
  };
  };

}
