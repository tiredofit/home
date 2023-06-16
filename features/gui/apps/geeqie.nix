{ pkgs, config, lib, ...}:
{

  home = {
    file = {

    };

    packages = with pkgs;
      [
        geeqie
      ];
  };


}
