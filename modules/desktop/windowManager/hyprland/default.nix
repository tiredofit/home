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
        env = [
          "CLUTTER_BACKEND,wayland"
          "GDK_BACKEND,wayland,x11"
          "QT_QPA_PLATFORM,wayland;xcb"
          "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
          "SDL_VIDEODRIVER,wayland"
          "XCURSOR_SIZE,24"
          "XDG_SESSION_DESKTOP,Hyprland"
        ];

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
          #col.active_border = "rgba(33ccffee) rgba(00ff99ee) 45deg";
          #col.inactive_border = "rgba(595959aa)";
          allow_tearing = false;
          border_size = 2;
          cursor_inactive_timeout = 60;
          gaps_in = 2;
          gaps_out = 5;
          layout = "master";
          resize_corner = 2;
          resize_on_border = true;
        };

        master = {
          allow_small_split = true;
          always_center_master = false;
          drop_at_cursor = true;
          inherit_fullscreen = true;
          mfact = 0.55;
          new_is_master = true;
          new_on_top = true;
          orientation = "center";
          smart_resizing = true;
        };

        decoration = {
          blur = {
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

          #col.shadow = "rgba(1a1a1aee)";
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

        misc = {
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
          force_default_wallpaper = -3;
        };

        plugin = {

        };

        # Keybinds
        bind = [
          "SUPER, F, fullscreen"
          "SUPER, P, pin" # Pin dispatcher, make window appear above everything else on all windows
          "SUPER, Return, exec, kitty"
          "SUPER, V, togglefloating,"
          "SUPER, mouse:274, killactive" # Middle Mouse
          "SUPER, space, pseudo,"

          "SUPER_SHIFT, Q, killactive"
          "SUPER_SHIFT, R, exec, pkill rofi || kitty bash -c $(/nix/store/84d9n102xq8c5j3qlldi9gvglri25ixq-rofi-1.7.5+wayland3/bin/rofi -dmenu -p terminal)"
          "ALT, Tab, bringactivetotop,"
          "ALT, Tab, cyclenext,"
          #"ALT,TAB,workspace,previous"

          # Move focus with mainMod + arrow keys
          "SUPER, left, movefocus, l"
          "SUPER, right, movefocus, r"
          "SUPER, up, movefocus, u"
          "SUPER, down, movefocus, d"

          # Switch workspaces with mainMod + [0-9]
          "SUPER, KP_End, workspace, 1"
          "SUPER, KP_Down, workspace, 2"
          "SUPER, KP_Next, workspace, 3"
          "SUPER, KP_Left, workspace, 4"
          "SUPER, KP_Begin, workspace, 5"
          "SUPER, KP_Right, workspace, 6"
          "SUPER, KP_Home, workspace, 7"
          "SUPER, KP_Up, workspace, 8"
          "SUPER, KP_Prior, workspace, 9"
          #"SUPER, KP_Insert, workspace, 10"

          # Move active window to a workspace with mainMod + SHIFT + [0-9]
          "SUPER SHIFT, KP_End, movetoworkspace, 1"
          "SUPER SHIFT, KP_Down, movetoworkspace, 2"
          "SUPER SHIFT, KP_Next, movetoworkspace, 3"
          "SUPER SHIFT, KP_Left, movetoworkspace, 4"
          "SUPER SHIFT, KP_Begin, movetoworkspace, 5"
          "SUPER SHIFT, KP_Right, movetoworkspace, 6"
          "SUPER SHIFT, KP_Home, movetoworkspace, 7"
          "SUPER SHIFT, KP_Up,  movetoworkspace, 8"
          "SUPER SHIFT, KP_Prior, movetoworkspace, 9"
          #"SUPER SHIFT, KP_Insert, movetoworkspace, 10"

          # moving windows to other workspaces (silent)
          "SUPER ALT, KP_End,   movetoworkspacesilent,1"
          "SUPER ALT, KP_Down,  movetoworkspacesilent,2"
          "SUPER ALT, KP_Next,  movetoworkspacesilent,3"
          "SUPER ALT, KP_Left,  movetoworkspacesilent,4"
          "SUPER ALT, KP_Begin, movetoworkspacesilent,5"
          "SUPER ALT, KP_Right, movetoworkspacesilent,6"
          "SUPER ALT, KP_Home,  movetoworkspacesilent,7"
          "SUPER ALT, KP_Up,    movetoworkspacesilent,8"
          "SUPER ALT, KP_Prior, movetoworkspacesilent,9"
          #"SUPER ALT, KP_Insert, movetoworkspacesilent,0"

          # moving windows around
          "SUPERSHIFT, left, movewindow,l"
          "SUPERSHIFT, right,movewindow,r"
          "SUPERSHIFT, up, movewindow,u"
          "SUPERSHIFT, down, movewindow,d"

          # Turn off animations / game mode
          "WIN, F1, exec,  ~/.config/hypr/gamemode.sh"

          # special workspace
          ## TODO Dynamic Configuration
          "SUPER     SHIFT, grave, movetoworkspace, special"
          "SUPER, grave, togglespecialworkspace, DP-2"

          # Scroll through existing workspaces with mainMod + scroll
          "SUPER, mouse_down, workspace, e+1"
          "SUPER, mouse_up, workspace, e-1"
        ];

        binde = [
          "SUPERCTRL, left, resizeactive,-20 0"
          "SUPERCTRL, right, resizeactive,20 0"
          "SUPERCTRL, up, resizeactive,0 -20"
          "SUPERCTRL, down, resizeactive,0 20"
        ];
        bindl = [
          ",XF86AudioPlay, exec, playerctl play-pause"
          ",XF86AudioPrev, exec, playerctl previous"
          ",XF86AudioNext, exec, playerctl next"
          ",XF86AudioMedia, exec, playerctl play-pause"
          ",XF86AudioStop, exec, playerctl stop"
          ",XF86AudioMute, exec, swayosd-client --output-volume mute-toggle"
        ];
        bindle = [
          ",XF86AudioRaiseVolume, exec, swayosd-client --output-volume +1 --max-volume=100"
          ",XF86AudioLowerVolume, exec, swayosd-client --output-volume -1"
        ];
        bindm = [
          # Move/resize windows with mainMod + LMB/RMB and dragging
          "SUPER, mouse:272, movewindow"
          "SUPER, mouse:273, resizewindow"
        ];

        windowrulev2 = [
          # ZoomPWA
          "workspace 3,class:(^FFPWA-01HTZ7G5XDG9A8VH9ZNCBBS9RT$)"
          "size 1200 1155,class:(^FFPWA-01HTZ7G5XDG9A8VH9ZNCBBS9RT$)"
          "float,title:^My Meeting$"
          "float,class:(^FFPWA-01HTZ7G5XDG9A8VH9ZNCBBS9RT$)"

          # IDLE inhibit while watching videos
          #"idleinhibit focus, class:^(mpv|.+exe)$"
          #"idleinhibit focus, class:^(firefox)$, title:^(.*YouTube.*)$"
          #"idleinhibit fullscreen, class:^(firefox)$"


          # XDG-Portal-GTK File Picker annoyances
          "dimaround,title:^Open Files$"
          "float,title:^Open Files$"
          "size 1290 800, title:^Open Files$"
        ];
      };


      extraConfig = ''
        source=~/src/home/dotfiles/hypr/hyprland.conf

        bind = SUPER, D, exec, pkill rofi || ${config.programs.rofi.package}/bin/rofi -combi-modi window,drun,ssh,run -show combi -show-icons
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
