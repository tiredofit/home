{ config, inputs, lib, pkgs, specialArgs, ... }:
let
  inherit (specialArgs) displays display_center display_left display_right role;

  displayServer = config.host.home.feature.gui.displayServer ;
  windowManager = config.host.home.feature.gui.windowManager ;

  gameMode = pkgs.writeShellScriptBin "gamemode" ''
    HYPRGAMEMODE=$(hyprctl getoption animations:enabled | awk 'NR==2{print $2}')
    if [ "$HYPRGAMEMODE" = 1 ] ; then
      hyprctl --batch "\
          keyword animations:enabled 0;\
          keyword decoration:drop_shadow 0;\
          keyword decoration:blur 0;\
          keyword general:gaps_in 0;\
          keyword general:gaps_out 0;\
          keyword general:border_size 1;\
          keyword decoration:rounding 0"
      exit
    else
      hyprctl --batch "\
          keyword animations:enabled 1;\
          keyword decoration:drop_shadow 1;\
          keyword decoration:blur 1;\
          keyword general:gaps_in 1;\
          keyword general:gaps_out 1;\
          keyword general:border_size 1;\
          keyword decoration:rounding 1"
    fi
    hyprctl reload
  '';
in

with lib;
{
  imports = [
    #inputs.hyprland.homeManagerModules.default
    ./binds.nix
    ./decorations.nix
    ./displays.nix
    ./input.nix
    ./settings.nix
    ./startup.nix
    ./windowrules.nix
  ];

  config = mkIf (config.host.home.feature.gui.enable && displayServer == "wayland" && windowManager == "hyprland") {
    home = {
      packages = with pkgs;
        [
          gameMode
          #hyprland-share-picker     # If this works outside of Hyprland modularize
        ];
    };

    host = {
      home = {
        applications = {
          hyprcursor.enable = mkDefault true;
          hyprdim.enable = mkDefault true;
          hypridle.enable = mkDefault true;
          hyprlock.enable = true;
          hyprpaper.enable = mkDefault true;
          hyprpicker.enable = mkDefault true;
          hyprkeys.enable = mkDefault true;
          playerctl.enable = mkDefault true;
          satty.enable = mkDefault true;
          rofi.enable = mkDefault true;
        };
      };
    };

    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = mkDefault true;
    };

    xsession = {
      enable = true;
      scriptPath = ".hm-xsession";
        #export NIXOS_OZONE_WL=1
        #export QT_QPA_PLATFORM=wayland;xcb
      windowManager.command = ''
        export CLUTTER_BACKEND=gdk
        export MOZ_ENABLE_WAYLAND=1
        export QT_AUTO_SCREEN_SCALE_FACTOR=1
        export QT_QPA_PLATFORM=wayland
        export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
        export SDL_VIDEODRIVER=wayland
        export WLR_RENDERER=vulkan
        export XDG_CURRENT_DESKTOP=Hyprland
        export XDG_SESSION_DESKTOP=Hyprland
        export XDG_SESSION_TYPE=wayland
        export _JAVA_AWT_WM_NONREPARENTING=1
        Hyprland
      '';
    };
  };
}
