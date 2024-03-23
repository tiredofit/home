{ config, inputs, lib, pkgs, ...}:
let
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
    inputs.hyprland.homeManagerModules.default
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
          hyprcursor.enable = true;
          hyprdim.enable = true;
          hypridle.enable = true;
          hyprlock.enable = true;
          hyprpaper.enable = true;
          hyprpicker.enable = true;
          hyprkeys.enable = true;
          hyprshot.enable = true;
          playerctl.enable = true;
          rofi.enable = true;
        };
      };
    };

    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
      extraConfig = ''
        source=~/src/home/dotfiles/hypr/hyprland.conf

        bind = $mainMod, D, exec, pkill rofi || ${config.programs.rofi.package}/bin/rofi -combi-modi window,drun,ssh,run -show combi -show-icons
        bind = SUPER, V, exec, cliphist list | ${config.programs.rofi.package}/bin/rofi -dmenu | cliphist decode | wl-copy
      '';
    };

    xdg.configFile."hypr/hyprpaper.conf".text = ''
      preload = ~/.config/hypr/background/left.jpg
      preload = ~/.config/hypr/background/middle.jpg
      preload = ~/.config/hypr/background/right.jpg

      wallpaper = HDMI-A-1,~/.config/hypr/background/right.jpg
      wallpaper = DP-2,~/.config/hypr/background/middle.jpg
      wallpaper = DP-3,~/.config/hypr/background/left.jpg
    '';

    xsession = {
      enable = true;
      scriptPath = ".hm-xsession";
      windowManager.command = ''
        export MOZ_ENABLE_WAYLAND=1
        #export NIXOS_OZONE_WL=1
        export WLR_RENDERER=vulkan
        export XDG_SESSION_TYPE=wayland
        export XDG_SESSION_DESKTOP=Hyprland
        export XDG_CURRENT_DESKTOP=Hyprland
        export QT_AUTO_SCREEN_SCALE_FACTOR=1
        export QT_QPA_PLATFORM=wayland;xcb
        export ECORE_EVAS_ENGINE=wayland-egl
        export ELM_ENGINE=wayland_egl
        export SDL_VIDEODRIVER=wayland
        export _JAVA_AWT_WM_NONREPARENTING=1
        export NO_AT_BRIDGE=1
        export GDK_BACKEND=wayland,X11
        export CLUTTER_BACKEND="wayland"
        Hyprland
      '';
    };
  };
}
