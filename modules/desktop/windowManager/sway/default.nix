{ config, lib, pkgs, ... }:
let
  displayServer = config.host.home.feature.gui.displayServer;
  windowManager = config.host.home.feature.gui.windowManager;
in
with lib; {
  config = mkIf (config.host.home.feature.gui.enable && displayServer == "wayland" && windowManager == "sway") {

      host = {
        home = {
          applications = {
            autotiling.enable = true;
            dunst.enable = true;
            i3status-rust.enable = true;
            swayidle.enable = true;
            swaylock.enable = true;
            rofi.enable = true;
          };
        };
      };

      wayland.windowManager.sway = {
        enable = true;
        config = {
          assigns = { "3" = [{ class = "^Ferdium"; }]; };
          bars =
            let # # TODO This is used in multiple areas - move to top of configuration
              mon_left = "DP-3";
              mon_center = "DP-2";
              mon_right = "HDMI-A-1";
            in [
              {
                id = "bar-left"; # TODO - Adapt for various screens
                statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/sway/status/left.rs";
                position = "top";
                trayOutput = "none";
                extraConfig = ''
                  output ${mon_left}
                '';
                workspaceButtons = true;
                workspaceNumbers = true;
                fonts = {
                  names = [ "pango:Noto Sans NF" "FontAwesome" ];
                  size = 12.0;
                };
                colors = {
                  background = "#222222";
                  focusedWorkspace = {
                    background = "#0088CC";
                    border = "#0088CC";
                    text = "#ffffff";
                  };
                  activeWorkspace = {
                    background = "#333333";
                    border = "#333333";
                    text = "#888888";
                  };
                  inactiveWorkspace = {
                    background = "#333333";
                    border = "#333333";
                    text = "#888888";
                  };
                  separator = "#666666";
                  statusline = "#dddddd";
                  urgentWorkspace = {
                    background = "#2f343a";
                    border = "#900000";
                    text = "#ffffff";
                  };
                };
              }
              {
                id = "bar-center";
                statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/sway/status/center.rs";
                position = "top";
                extraConfig = ''
                  output ${mon_center}
                  tray_output ${mon_center}
                '';
                workspaceButtons = true;
                workspaceNumbers = true;
                fonts = {
                  names = [ "pango:Noto Sans" "FontAwesome" ];
                  size = 12.0;
                };
                colors = {
                  background = "#222222";
                  focusedWorkspace = {
                    background = "#0088CC";
                    border = "#0088CC";
                    text = "#ffffff";
                  };
                  activeWorkspace = {
                    background = "#333333";
                    border = "#333333";
                    text = "#888888";
                  };
                  inactiveWorkspace = {
                    background = "#333333";
                    border = "#333333";
                    text = "#888888";
                  };
                  separator = "#666666";
                  statusline = "#dddddd";
                  urgentWorkspace = {
                    background = "#2f343a";
                    border = "#900000";
                    text = "#ffffff";
                  };
                };
              }
              {
                id = "bar-right";
                statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/sway/status/right.rs";
                position = "top";
                trayOutput = "none";
                extraConfig = ''
                  output ${mon_right}
                  tray_output ${mon_right}
                '';
                workspaceButtons = true;
                workspaceNumbers = true;
                fonts = {
                  names = [ "pango:Noto Sans" "FontAwesome" ];
                  size = 12.0;
                };
                colors = {
                  background = "#222222";
                  focusedWorkspace = {
                    background = "#0088CC";
                    border = "#0088CC";
                    text = "#ffffff";
                  };
                  activeWorkspace = {
                    background = "#333333";
                    border = "#333333";
                    text = "#888888";
                  };
                  inactiveWorkspace = {
                    background = "#333333";
                    border = "#333333";
                    text = "#888888";
                  };
                  separator = "#666666";
                  statusline = "#dddddd";
                  urgentWorkspace = {
                    background = "#2f343a";
                    border = "#900000";
                    text = "#ffffff";
                  };
                };
              }
            ];
          fonts = {
            names = [ "Hack Nerd Font" ];
            size = 10.0;
          };
          gaps = {
            inner = 10;
            outer = 5;
            smartGaps = true;
          };
          floating = {
            criteria = [
              { "class" = "Arandr"; } # Display Management
              { "class" = "Calendar"; } # Thunderbird Detail Popup
              { "title" = "Volume Control"; } # PulseAudio Volume Control
              { "class" = "kitty_floating"; } # When Passing something to Kitty with WM_CLASS kitty_floating
              { "class" = "virt-manager"; } # QEMU Virtualization Manager
              { "title" = "Preferences$"; }
              { "title" = "Timewarrior Tracking"; } # Timewarrior
              { "title" = "^join?action=join.*$"; } # Zoom - For meetings that you have joined via a link
              { "class" = "^join?action=join.*$"; } # Zoom - For meetings that you have joined via a link
              { "title" = "^zooms?$"; } # Zoom - notification window to floating with no focus
              { "class" = ".zoom"; } # Zoom
              { "window_role" = "(pop-up|bubble|dialog)"; }
              { "window_role" = "pop-up"; }
              { "window_role" = "task_dialog"; }
            ];
          };
          modifier = "Mod4";
          keybindings = let
            mod = "Mod4";
            mod_d_rofi = "exec ${config.programs.rofi.package}/bin/rofi -combi-modi window,drun,ssh,run -show combi -show-icons";
          in {
            ### Keybind Applications (xmodmap -pke for grabbing keycodes)
            ### or xev | awk -F'[ )]+' '/^KeyPress/ { a[NR+2] } NR in a { printf "%-3s %s\n", $5, $8 }'
            "Mod4+Shift+e" = "swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -B 'Yes, exit sway' 'swaymsg exit'";
            "Mod4+Shift+q" = "kill";
            "Mod4+space" = "floating toggle";
            # change focus
            "Mod4+j" = "focus left";
            "Mod4+k" = "focus down";
            "Mod4+l" = "focus up";
            "Mod4+semicolon" = "focus right";
            "Mod4+Left" = "focus left";
            "Mod4+Down" = "focus down";
            "Mod4+Up" = "focus up";
            "Mod4+Right" = "focus right";
            # move focused window
            "Mod4+Shift+j" = "move left";
            "Mod4+Shift+k" = "move down";
            "Mod4+Shift+l" = "move up";
            "Mod4+Shift+semicolon" = "move right";
            "Mod4+Shift+Left" = "move left";
            "Mod4+Shift+Down" = "move down";
            "Mod4+Shift+Up" = "move up";
            "Mod4+Shift+Right" = "move right";
            # split in horizontal orientation
            "Mod4+h" = "split h";
            # split in vertical orientation
            "Mod4+v" = "split v";
            # split toggle
            "Mod4+t" = "split toggle";
            # enter fullscreen mode for the focused container
            "Mod4+f" = "fullscreen toggle";
            # change container layout (stacked, tabbed, toggle split)
            "Mod4+s" = "layout stacking";
            "Mod4+w" = "layout tabbed";
            "Mod4+e" = "layout toggle split";
            "Mod4+Shift+space" = "floating toggle"; # toggle tiling / floating
            # change focus between tiling / floating windows
            #"Mod4+space" = "focus mode_toggle";
            "Mod4+c" = "floating toggle";

            "Mod4+a" = "focus parent"; # focus the parent container

            "Mod4+r" = "mode resize"; ## Mode Launchers
            ## Misc
            "Mod4+Shift+p" = "bar mode toggle "; # Hide Bars
            ### Mouse Binds
            "--release button2" = "kill"; # The middle button over a titlebar kills the window
            "--whole-window Mod4+button2" = "kill"; # The middle button and a modifer over any part of the window kills the window
            "button3" = "floating toggle"; # The right button toggles floating
            "Mod4+button3" = "floating toggle"; # The right button toggles floating
            "button9" = "move left"; # The side buttons move the window around
            "button8" = "move right"; # The side buttons move the window around

            ## Applications
            "XF86Calculator" = "exec 'mate-calc'"; # Calculator
            #"Mod4+Shift+d" = "exec rofi -modi 'clipboard:greenclip print' -show clipboard -run-command '{cmd}'";                    # Clipboard
            "Print" = "exec flameshot gui"; # Flameshot
            "Mod4+Shift+s" = "exec flameshot gui"; # Flameshot
            "Mod4+Shift+x" = "exec swaylock -f -e -l -L  -c 000000"; # Lock screen
            "Mod4+d" = "exec ${config.programs.rofi.package}/bin/rofi -combi-modi window#drun#ssh#run -show combi -show-icons"; # Program Launcher
            "Mod4+Return" = "exec kitty"; # Terminal
            "Mod4+Mod1+space" = "exec ~/.config/scripts/timewarrior.sh start"; # Timewarrior GUI
            "XF86AudioRaiseVolume" = "exec --no-startup-id sound-tool volume up && killall -SIGUSR1 i3status-rs"; # Volume Controls
            "XF86AudioLowerVolume" = "exec --no-startup-id sound-tool volume up && killall -SIGUSR1 i3status-rs"; # Volume Controls
            "XF86AudioMute" = "exec --no-startup-id sound-tool volume mute && killall -SIGUSR1 i3status-rs"; # Volume Controls
            "XF86AudioMicMute" = "exec --no-startup-id sound-tool mic mute && killall -SIGUSR1 i3status-rs"; # Volume Controls
          };
          modes = {
            resize = {
              "j" = "resize shrink width 40 px or 40 ppt"; # Pressing left will shrink the window’s width.
              "k" = "resize grow height 40 px or 40 ppt"; # Pressing down will grow the window’s height.
              "l" =  "resize shrink height 40 px or 40 ppt"; # Pressing up will shrink the window’s height.
              "semicolon" = "resize grow width 40 px or 40 ppt"; # Pressing right will grow the window’s width.
              "Left" = "resize shrink width 40 px or 40 ppt"; # Pressing left will shrink the window’s width.
              "Down" = "resize grow height 40 px or 40 ppt"; # Pressing down will grow the window’s height.
              "Up" = "resize shrink height 40 px or 40 ppt"; # Pressing up will shrink the window’s height.
              "Right" = "resize grow width 40 px or 40 ppt"; # Pressing right will grow the window’s width.
              "Return" = "mode default"; # back to normal: Enter or Escape or $mod+r
              "Escape" = "mode default"; # back to normal: Enter or Escape or $mod+r
              "Mod4+r" = "mode default"; # back to normal: Enter or Escape or $mod+r
            };
          };
          startup = [
            #{ command = "~/.config/scripts/decrypt.sh"; always = false; }  # Decryption script # TODO - Secrets and SystemD service
            {
              command = "autotiling";
              always = true;
            } # Auto Tile H/V
            {
              command = "dunst";
              always = false;
            } # Notification Manager
            {
              command = "opensnitch-ui --background";
              always = false;
            } # Firewall
            {
              command = "ferdium --ozone-platform=wayland --enable-features-WaylandWindowDecorations";
              always = false;
            } # IM
            #{ command = "flameshot"; always = false; }                                                                     # Screenshot
            {
              command = "nextcloud --background";
              always = false;
            } # Nextcloud Client
            {
              command = "opensnitch-ui";
              always = false;
            } # Firewall
            {
              command = "swayidle -w timeout 600 'swaylock -f -e -l -L  -c 000000' timeout 1800 'swaymsg ''output * dpms off'' resume 'swaymsg ''output * dpms on'' timeout 2700 'systemctl suspend' before-sleep 'swaylock -f -e -l -L -c 000000'";
              always = false;
            }
            {
              command = "way-displays";
              always = false;
            } # Displays
            {
              command = "sleep 5; way-displays -c ~/.config/waydisplays/cfg.yaml -s ORDER DP-3 DP-2 HDMI-A-1";
              always = false;
            }
          ];
          terminal = "kitty";
          workspaceAutoBackAndForth = true;
          workspaceLayout = "default"; # Bounce back and forth between workspaces using same workspace key
          workspaceOutputAssign =
            let # # TODO This is used in multiple areas - move to top of configuration
              mon_left = "DP-3";
              mon_center = "DP-2";
              mon_right = "HDMI-A-1";
            in [
              {
                workspace = "1";
                output = "${mon_left}";
              }
              {
                workspace = "4";
                output = "${mon_left}";
              }
              {
                workspace = "7";
                output = "${mon_left}";
              }
              {
                workspace = "2";
                output = "${mon_center}";
              }
              {
                workspace = "5";
                output = "${mon_center}";
              }
              {
                workspace = "8";
                output = "${mon_center}";
              }
              {
                workspace = "3";
                output = "${mon_right}";
              }
              {
                workspace = "6";
                output = "${mon_right}";
              }
              {
                workspace = "9";
                output = "${mon_right}";
              }
            ];
        };
        extraConfig = ''
          ## Stuff that never made it into the configuration options
          ## TODO Review

          ## Focus Rules
          no_focus [class=".*zoom"]
          no_focus [title="^zoom\s?$"]

          ## Popups during fullscreen (smart/ignore/leave_fullscreen)
          popup_during_fullscreen smart

          ## Keyboard app Launcher
          set $mode_launcher Launch: [c]hromium [d]iffuse [f]irefox [t]hunderbird [v]scode [z]oom
          bindsym Mod4+o mode "$mode_launcher"
          mode "$mode_launcher" {
              bindsym c exec chromium ; mode "default"
              bindsym d exec diffuse ; mode "default"
              bindsym f exec firefox ; mode "default"
              bindsym t exec thunderbird ; mode "default"
              bindsym v exec code ; mode "default"
              bindsym z exec zoom ; mode "default"
              bindsym Escape mode "default"
              bindsym Return mode "default"
          }

          ## We move these keybinds here due to some weird stuff that happens with keycodes and numberlock
          set $ws1 "1"
          set $ws2 "2"
          set $ws3 "3"
          set $ws4 "4"
          set $ws5 "5"
          set $ws6 "6"
          set $ws7 "7"
          set $ws8 "8"
          set $ws9 "9"
          set $ws10 "10"

          # Number Pad Mapping
          set $KP_1 "87"
          set $KP_2 "88"
          set $KP_3 "89"
          set $KP_4 "83"
          set $KP_5 "84"
          set $KP_6 "85"
          set $KP_7 "79"
          set $KP_8 "80"
          set $KP_9 "81"
          set $KP_0 "90"

          ## switch to workspace
          bindsym Mod4+1 workspace number $ws1
          bindsym Mod4+2 workspace number $ws2
          bindsym Mod4+3 workspace number $ws3
          bindsym Mod4+4 workspace number $ws4
          bindsym Mod4+5 workspace number $ws5
          bindsym Mod4+6 workspace number $ws6
          bindsym Mod4+7 workspace number $ws7
          bindsym Mod4+8 workspace number $ws8
          bindsym Mod4+9 workspace number $ws9
          bindsym Mod4+0 workspace number $ws10

          bindsym Mod4+Mod2+KP_1 workspace number $ws1
          bindsym Mod4+Mod2+KP_2 workspace number $ws2
          bindsym Mod4+Mod2+KP_3 workspace number $ws3
          bindsym Mod4+Mod2+KP_4 workspace number $ws4
          bindsym Mod4+Mod2+KP_5 workspace number $ws5
          bindsym Mod4+Mod2+KP_6 workspace number $ws6
          bindsym Mod4+Mod2+KP_7 workspace number $ws7
          bindsym Mod4+Mod2+KP_8 workspace number $ws8
          bindsym Mod4+Mod2+KP_9 workspace number $ws9
          bindsym Mod4+Mod2+KP_0 workspace number $ws10

          ## move focused container to workspace
          bindsym Mod4+Shift+1 move container to workspace number $ws1
          bindsym Mod4+Shift+2 move container to workspace number $ws2
          bindsym Mod4+Shift+3 move container to workspace number $ws3
          bindsym Mod4+Shift+4 move container to workspace number $ws4
          bindsym Mod4+Shift+5 move container to workspace number $ws5
          bindsym Mod4+Shift+6 move container to workspace number $ws6
          bindsym Mod4+Shift+7 move container to workspace number $ws7
          bindsym Mod4+Shift+8 move container to workspace number $ws8
          bindsym Mod4+Shift+9 move container to workspace number $ws9
          bindsym Mod4+Shift+0 move container to workspace number $ws10

          #bindcode Mod4+Shift+$KP_1 move container to workspace $ws1
          #bindcode Mod4+Shift+$KP_2 move container to workspace $ws2
          #bindcode Mod4+Shift+$KP_3 move container to workspace $ws3
          #bindcode Mod4+Shift+$KP_4 move container to workspace $ws4
          #bindcode Mod4+Shift+$KP_5 move container to workspace $ws5
          #bindcode Mod4+Shift+$KP_6 move container to workspace $ws6
          #bindcode Mod4+Shift+$KP_7 move container to workspace $ws7
          #bindcode Mod4+Shift+$KP_8 move container to workspace $ws8
          #bindcode Mod4+Shift+$KP_9 move container to workspace $ws9
          #bindcode Mod4+Shift+$KP_0 move container to workspace $ws10
        '';
      };
      xsession = {
        enable = true;
        scriptPath = ".hm-xsession";
        windowManager.command = ''
          export MOZ_ENABLE_WAYLAND=1
          export NIXOS_OZONE_WL=1
          export XDG_SESSION_TYPE=wayland
          export XDG_SESSION_DESKTOP=sway
          export XDG_CURRENT_DESKTOP=sway
          export CLUTTER_BACKEND=wayland
          export QT_QPA_PLATFORM=wayland-egl
          export ECORE_EVAS_ENGINE=wayland-egl
          export ELM_ENGINE=wayland_egl
          export SDL_VIDEODRIVER=wayland
          export _JAVA_AWT_WM_NONREPARENTING=1
          export NO_AT_BRIDGE=1
          sway
        '';
      };
    };

}
