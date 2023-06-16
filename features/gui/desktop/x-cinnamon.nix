{ config, pkgs, ...}:
{
  imports = [
    ./x-common.nix
  ];

  home = {
    packages = with pkgs;
      [
        cinnamon.cinnamon-common
        cinnamon.cinnamon-control-center
        cinnamon.cinnamon-desktop
        cinnamon.cinnamon-gsettings-overrides
        cinnamon.cinnamon-menus
        cinnamon.cinnamon-screensaver
        cinnamon.cinnamon-session
        cinnamon.cinnamon-settings-daemon
        cinnamon.cinnamon-translations
        cinnamon.cjs
        cinnamon.muffin
        cinnamon.nemo
        networkmanagerapplet
      ];
  };

  xsession = {
    enable = true;
    scriptPath = ".hm-xsession";
    windowManager.command = ''
      cinnamon-session
    '';
  };
}
