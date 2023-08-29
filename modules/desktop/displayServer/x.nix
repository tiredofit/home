{ config, lib, pkgs, ... }:
with lib;
let
  inherit (specialArgs) kioskUsername kioskURL;
  displayServer = config.host.home.feature.gui.displayServer ;
in
{
  config = mkIf (displayServer == "x" && config.host.home.feature.gui.enable ) {
    ## TODO These should be seperated into modules at some point as they are all common to X
    home = {
      packages = with pkgs;
        [
          arandr           # screen layout manager
          autokey          # override keymaps
          redshift         # gamma control
          sysstat          # get system information
          xbindkeys        # bind keys to commands
          xdotool          # automation
          xorg.xbacklight  # control screen brightness, the same as light
          xorg.xdpyinfo    # get screen information
          xorg.xev         # get x input information
          xorg.xprop       # get window information
        ];
    };

    programs = {
      bash = {
        sessionVariables = {
          XINITRC = "$XDG_CONFIG_HOME/X11/xinitrc";
        };

        shellAliases = {
          windowtitle = "xprop | grep WM_CLASS" ; # get window title from x application
        };

        initExtra = ''
          keypress() {
            xev | awk -F'[ )]+' '/^KeyPress/ { a[NR+2] } NR in a { printf "%-3s %s\n", $5, $8 }'
          }
        '';
      };
    };
  };
}