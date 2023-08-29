{ config, lib, pkgs, ... }:
with lib;
let
  inherit (specialArgs) kioskUsername kioskURL;
  displayServer = config.host.home.feature.gui.displayServer ;
in
{
  config = mkIf (displayServer == "x" && config.host.home.feature.gui.enable ) {
    host = {
      home = {
        applications = {
          arandr.enable = true;
          autokey.enable = mkDefault true;
          redshift.enable = true;
          sysstat.enable = true;
          xbindkeys.enable = true;
          xdotool.enable = true;
          xbacklight.enable = true;
          xdpyinfo.enable = true;
          xev.enable = true;
          xprop.enable = true;
        };
      };
    };

    programs = {
      bash = {
        sessionVariables = {
          XINITRC = "$XDG_CONFIG_HOME/X11/xinitrc";
        };
      };
    };
  };
}