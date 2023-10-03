{ config, lib, pkgs, ... }:
let
  displayServer = config.host.home.feature.gui.displayServer ;
  windowManager = config.host.home.feature.gui.windowManager ;
in
with lib;
{
  config = mkIf (config.host.home.feature.gui.enable && displayServer == "x" && windowManager == "cinnamon") {
    home = {
      packages = with pkgs;
        [
          cinnamon.bulky
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
          cinnamon.mint-artwork
          cinnamon.mint-cursor-themes
          cinnamon.mint-themes
          cinnamon.mint-x-icons
          cinnamon.mint-y-icons
          cinnamon.muffin
          cinnamon.nemo-with-extensions
          cinnamon.pix
          cinnamon.warpinator
          cinnamon.xapp
          cinnamon.xreader
          cinnamon.xviewer
          glib
          gsettings-desktop-schemas
          killall
          libgnomekbd
          networkmanagerapplet
          polkit_gnome
          sound-theme-freedesktop
          xdg-user-dirs
          xplayer
        ];
    };

    xsession = {
      enable = true;
      scriptPath = ".hm-xsession";
      windowManager.command = ''
        cinnamon-session
      '';
    };
  };
}
