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
      settings = {
        input = {
          follow_mouse = 1;
          kb_layout = "us";
          kb_model = "";
          kb_options = "";
          kb_rules = "";
          kb_variant = "";
          numlock_by_default = true;
          repeat_delay = 200;
          repeat_rate = 40;
          sensitivity = 0;
          touchpad = {
            natural_scroll = false;
          };
        };
        gestures = {
          workspace_swipe = false;
        };

        # UI
        general = {
          gaps_in = 2;
          gaps_out = 5;
          border_size = 2;
          col.active_border = "rgba(33ccffee) rgba(00ff99ee) 45deg";
          col.inactive_border = "rgba(595959aa)";
          cursor_inactive_timeout = 60;
          layout = "master";
          resize_on_border = true;
          allow_tearing = false;
          resize_corner = 2;
        };

        master = {
          allow_small_split = true;
          inherit_fullscreen = true;
          new_is_master = true;
          new_on_top = true;
          mfact = 0.55;
          orientation = "center";
          always_center_master = false;
          smart_resizing = true;
          drop_at_cursor = true;
        };

        decoration = {
          blur ={
            enabled = true;
            brightness = 1;
            contrast = 1.0;
            ignore_opacity = true;
            new_optimizations = true;
            passes = 3;
            popups = true;
            size = 4;
            vibrancy = 0.50;
            vibrancy_darkness = 0.50;
            xray = false;
          };

          col.shadow = "rgba(1a1a1aee)";
          dim_inactive = false;
          dim_strength = 0.2;
          drop_shadow = true;
          rounding = 5;
          shadow_range = 4;
          shadow_render_power = 3;
        };

        animations = {
          enabled = true;
          animation = [
          "border, 1, 10, default"
          "fade, 1, 7, default"
          "windows, 1, 5, myBezier"
          "windowsMove, 1, 5, myBezier"
          "windowsOut, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 20%"
          "workspaces, 1, 10, overshot , slidevert"
        ];
        bezier = [
          "myBezier, 0.05, 0.9, 0.1, 1.1"
          "overshot, 0.05, 0.9, 0.1, 1.1"
        ];
      };
      };

      extraConfig = ''
        source=~/src/home/dotfiles/hypr/hyprland.conf

        bind = $mainMod, D, exec, pkill rofi || ${config.programs.rofi.package}/bin/rofi -combi-modi window,drun,ssh,run -show combi -show-icons
        bind = SUPER, V, exec, cliphist list | ${config.programs.rofi.package}/bin/rofi -dmenu | cliphist decode | wl-copy
      '';
      #plugins = [
      #  inputs.hyprland-plugins.packages.${pkgs.system}.hyprbars
      #  inputs.hyprland-plugins.packages.${pkgs.system}.hyprexpo
      #];
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
        #export NIXOS_OZONE_WL=1
        export CLUTTER_BACKEND="wayland"
        export ECORE_EVAS_ENGINE=wayland-egl
        export ELM_ENGINE=wayland_egl
        export GDK_BACKEND=wayland,X11
        export MOZ_ENABLE_WAYLAND=1
        export NO_AT_BRIDGE=1
        export QT_AUTO_SCREEN_SCALE_FACTOR=1
        export QT_QPA_PLATFORM=wayland;xcb
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
