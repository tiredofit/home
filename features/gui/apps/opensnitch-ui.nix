{ pkgs, config, lib, ...}:
{
  home = {
    file = {
    };

    packages = with pkgs;
      [
        opensnitch-ui
      ];
  };

#  services = {
#    opensnitch-ui = {
#      enable = true;
#    };
#  };

}
