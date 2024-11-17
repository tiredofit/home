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
          hyprpolkitagent.enable = mkDefault true;
          hyprsunset.enable = mkDefault true;
          hyprkeys.enable = mkDefault true;
          playerctl.enable = mkDefault true;
          satty.enable = mkDefault true;
          rofi.enable = mkDefault true;
        };
      };
    };

    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        env = [
          "XDG_CURRENT_DESKTOP,Hyprland"
          "XDG_SESSION_TYPE,wayland"
          "XDG_SESSION_DEKSTOP,Hyprland"
          "QT_AUTO_SCREEN_SCALE_FACTOR,1"
          "QT_QPA_PLATFORM,wayland;xcb"
          "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
          "QT_QPA_PLATFORMTHEME,qt6ct"
          "MOZ_ENABLE_WAYLAND,1"
          "GDK_BACKEND,wayland,x11,*"
          "SDL_VIDEODRIVER,wayland"
          "CLUTTER_BACKEND,wayland"
          "XDG_SESSION_TYPE,wayland"
          "ELECTRON_OZONE_PLATFORM_HINT,auto"
          "NIXOS_OZONE_WL,1"
        ];
      };
      xwayland.enable = mkDefault true;
    };

    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      config.common = {
        "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
        #"org.freedesktop.impl.portal.ScreenCast" = [ "hyprland" ];
        #"org.freedesktop.impl.portal.Screenshot" = [ "hyprland" ];
        "org.freedesktop.portal.FileChooser" = [ "xdg-desktop-portal-shana" ];
      };
      extraPortals = [
        #pkgs.xdg-desktop-portal-hyprland
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-wlr
        pkgs.xdg-desktop-portal-shana
      ];
    };

    xsession = {
      enable = true;
      scriptPath = ".hm-xsession";
      windowManager.command = ''
        #export XDG_CURRENT_DESKTOP=Hyprland
        #export XDG_SESSION_TYPE=wayland
        #export XDG_SESSION_DEKSTOP=Hyprland
        #export QT_AUTO_SCREEN_SCALE_FACTOR=1
        #export QT_QPA_PLATFORM,wayland=xcb
        #export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
        #export QT_QPA_PLATFORMTHEME=qt6ct
        #export MOZ_ENABLE_WAYLAND=1
        #export GDK_BACKEND="wayland,x11,*"
        #export SDL_VIDEODRIVER=wayland
        #export CLUTTER_BACKEND=wayland
        #export XDG_SESSION_TYPE=wayland
        Hyprland
      '';
    };
  };
}
