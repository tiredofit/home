{ pkgs, config, lib, ...}:

{
  imports = [
    ./common.nix
  ];

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
}
