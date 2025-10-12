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
          arandr.enable = mkDefault true;
          autokey.enable = mkDefault false;
          redshift.enable = mkDefault true;
          sysstat.enable = mkDefault true;
          xbindkeys.enable = mkDefault true;
          xdotool.enable = mkDefault true;
          xbacklight.enable = mkDefault true;
          xdpyinfo.enable = mkDefault true;
          xev.enable = mkDefault true;
          xprop.enable = mkDefault true;
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