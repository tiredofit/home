{ config, lib, pkgs, ...}:
{
  imports = [
    ../apps/dunst.nix
    ../apps/greenclip.nix
    ./x-common.nix
  ];

  home = {
    file = {
      ".config/i3/status".source = ../../../dotfiles/i3/status;
      ".config/i3/scripts".source = ../../../dotfiles/i3/scripts;
      ".config/rofi".source = ../../../dotfiles/rofi;
    };

    packages = with pkgs;
      [
        alttab                              # application picker
        autotiling                          # window management
        betterlockscreen                    # a... better lock screen
        dex                                 # autostart applications
        dunst                               # notification daemon
        feh                                 # set wallpaper
        i3status-rust                       # provide information to i3bar
        lxappearance                        # changew icons and themes
        nitrogen                            # set wallpaper
        numlockx                            # auto enable number lock
        picom                               # transparency and shadows, compositor
        rofi                                # application launcher
        xbanish                             # hide mouse when typing
        xbindkeys                           # bind keys to commands
        xfce.thunar                         # xfce4's file manager
        xfce.thunar-volman                  # xfce4's file manager
        xfce.thunar-archive-plugin          # xfce4's file manager
        xfce.thunar-media-tags-plugin       # xfce4's file manager
        xidlehook                           # do things when system goes idle
        volctl                              # volume control
      ];
  };

  xsession = {
    enable = true;
    scriptPath = ".hm-xsession";
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      config = {
        assigns = {
          "3" = [{ class = "^Ferdium"; }];
        };
        bars = let  ## TODO This is used in multiple areas - move to top of configuration
          mon_left = "DP-3";
          mon_center = "DP-2";
          mon_right = "HDMI-1";
        in [
          {
            id = "bar-left"; # TODO - Adapt for various screens
            statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3/status/left.rs";
            position = "top";
            trayOutput = "none";
            extraConfig = ''
              output ${mon_left}
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
            id = "bar-center";
            statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3/status/center.rs";
            position = "top";
            extraConfig = ''
              output ${mon_center}
              tray_output ${mon_center}
            '';
            workspaceButtons = true;
            workspaceNumbers = true;

            fonts = {
                names = [ "pango:Noto Sans NF" ];
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
            statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3/status/right.rs";
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
            { "class" = "Arandr"; }                     # Display Management
            { "class" = "Calendar" ; }                  # Thunderbird Detail Popup
            { "title" = "Volume Control"; }             # PulseAudio Volume Control
            { "class" = "kitty_floating" ; }            # When Passing something to Kitty with WM_CLASS kitty_floating
            { "class" = "virt-manager"; }               # QEMU Virtualization Manager
            { "title" = "Settings"; }
            { "title" = "Preferences$"; }
            { "title" = "Timewarrior Tracking" ; }      # Timewarrior
            { "title" = "^join\?action=join.*$" ; }     # Zoom - For meetings that you have joined via a link
            { "class" = "^join\?action=join.*$" ; }     # Zoom - For meetings that you have joined via a link
            { "title" = "^zoom\s?$" ; }                 # Zoom - notification window to floating with no focus
            { "title" = "Virtual Machine Manager" ; }   # QEMU Virtualization Manager
            { "class" = ".zoom" ; }                     # Zoom
            { "window_role" = "(pop-up|bubble|dialog)" ; }
            { "window_role" = "pop-up"; }
            { "window_role" = "task_dialog"; }
          ];
          modifier = "Mod4";
        };
        modifier = "Mod4";
        keybindings = let
          mod = config.xsession.windowManager.i3.config.modifier;
          mod_d_rofi = "exec rofi -combi-modi window,drun,ssh,run -show combi -show-icons";
          in {
             ### Keybind Applications (xmodmap -pke for grabbing keycodes)
             ### or xev | awk -F'[ )]+' '/^KeyPress/ { a[NR+2] } NR in a { printf "%-3s %s\n", $5, $8 }'
            "${mod}+Shift+e" = "exec i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -B 'Yes' 'i3-msg exit'";
            "${mod}+Shift+q" = "kill";
            "${mod}+space" = "floating toggle";
            # change focus
            "${mod}+j" = "focus left";
            "${mod}+k" = "focus down";
            "${mod}+l" = "focus up";
            "${mod}+semicolon" = "focus right";
            "${mod}+Left" = "focus left";
            "${mod}+Down" = "focus down";
            "${mod}+Up" = "focus up";
            "${mod}+Right" = "focus right";

            # move focused window
            "${mod}+Shift+j" = "move left";
            "${mod}+Shift+k" = "move down";
            "${mod}+Shift+l" = "move up";
            "${mod}+Shift+semicolon" = "move right";
            "${mod}+Shift+Left" = "move left";
            "${mod}+Shift+Down" = "move down";
            "${mod}+Shift+Up" = "move up";
            "${mod}+Shift+Right" = "move right";

            # split in horizontal orientation
            "${mod}+h" = "split h";

            # split in vertical orientation
            "${mod}+v" = "split v";

            # split toggle
            "${mod}+t" = "split toggle";

            # enter fullscreen mode for the focused container
            "${mod}+f" = "fullscreen toggle";

            # change container layout (stacked, tabbed, toggle split)
            "${mod}+s" = "layout stacking";
            "${mod}+w" = "layout tabbed";
            "${mod}+e" = "layout toggle split";

            # toggle tiling / floating
            "${mod}+Shift+space" = "floating toggle";

            # change focus between tiling / floating windows
            #"${mod}+space" = "focus mode_toggle";
            "${mod}+c" = "floating toggle";

            # focus the parent container
            "${mod}+a" = "focus parent";


            ## Mode Launchers
            "${mod}+r" = "mode resize";

            ## Misc
            "${mod}+Shift+p" = "bar mode toggle ";     # Hide Bars

            ### Mouse Binds
            "--release button2" = "kill";               # The middle button over a titlebar kills the window
            "--whole-window ${mod}+button2" =  "kill";  # The middle button and a modifer over any part of the window kills the window
            "button3" = "floating toggle";              # The right button toggles floating
            "${mod}+button3" = "floating toggle";       # The right button toggles floating
            "button9" = "move left";                    # The side buttons move the window around
            "button8" = "move right";                   # The side buttons move the window around

            ## Applications
            "XF86Calculator" = "exec 'mate-calc'";                                                                                    # Calculator
            "${mod}+Shift+d" = "exec rofi -modi 'clipboard:greenclip print' -show clipboard -run-command '{cmd}'";                    # Clipboard
            "Print" = "exec flameshot gui";                                                                                           # Flameshot
            "${mod}+Shift+s" = "exec flameshot gui";                                                                                  # Flameshot
            "${mod}+Shift+x" = "exec ~/.config/i3/scripts/lock.sh";                                                                   # Lock screen
            "${mod}+d" = "exec rofi -combi-modi window#drun#ssh#run -show combi -show-icons";                                         # Program Launcher
            "${mod}+Return" = "exec kitty";                                                                                           # Terminal
            "${mod}+Mod1+space" = "exec ~/.config/scripts/timewarrior.sh start";                                                      # Timewarrior GUI
            "XF86AudioRaiseVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +1% && killall -SIGUSR1 i3status-rs"; # Volume Controls
            "XF86AudioLowerVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -1% && killall -SIGUSR1 i3status-rs"; # Volume Controls
            "XF86AudioMute" = "exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle  && killall -SIGUSR1 i3status-rs";      # Volume Controls
            "XF86AudioMicMute" = "exec --no-startup-id pactl set-source-mute @DEFAULT_SOURCE@ toggle && killall -SIGUSR1 i3status-rs";# Volume Controls

      };
      modes = {
          resize = {
            "j" = "resize shrink width 40 px or 40 ppt";        # Pressing left will shrink the window’s width.
            "k" = "resize grow height 40 px or 40 ppt";         # Pressing down will grow the window’s height.
            "l" = "resize shrink height 40 px or 40 ppt";       # Pressing up will shrink the window’s height.
            "semicolon" = "resize grow width 40 px or 40 ppt";  # Pressing right will grow the window’s width.
            "Left" = "resize shrink width 40 px or 40 ppt";     # Pressing left will shrink the window’s width.
            "Down" = "resize grow height 40 px or 40 ppt";      # Pressing down will grow the window’s height.
            "Up" = "resize shrink height 40 px or 40 ppt";      # Pressing up will shrink the window’s height.
            "Right" = "resize grow width 40 px or 40 ppt";      # Pressing right will grow the window’s width.
            "Return" = "mode default";                          # back to normal: Enter or Escape or $mod+r
            "Escape" = "mode default";                          # back to normal: Enter or Escape or $mod+r
            "$mod+r" = "mode default";                          # back to normal: Enter or Escape or $mod+r
          };
        };
        startup = [
          { command = "${pkgs.alttab}/bin/alttab -fg '#d58681' -bg '#4a4a4a' -frame '#eb564d' -t 128x150 -i 127x64"; always = false; notification = false; }  # Running Application Manager
          #{ command = "${pkgs.autokey-gtk}/bin/autokey-gtk"; always = false; notification = false; }            # Autokey Parser for Firefox
          { command = "${pkgs.autotiling}/bin/autotiling"; always = true; notification = false; }              # Auto Tile H/V
          { command = "${pkgs.ferdium}/bin/ferdium"; always = false; notification = true; }                 # IM
          { command = "${pkgs.flameshot}/bin/flameshot"; always = false; notification = true; }               # Screenshot
          { command = "${pkgs.haskellPackages.greenclip}/bin/greenclip daemon"; always = true; notification = false; }        # Clipboard Management
          { command = "${pkgs.nextcloud-client}/bin/nextcloud --background"; always = false; notification = true; }  # Nextcloud Client
          { command = "${pkgs.nitrogen}/bin/nitrogen --restore"; always = false; notification = false; }     # Desktop Background
          { command = "${pkgs.numlockx}/bin/numlockx on"; always = false; notification = false; }            # Number Lock on by Default TODO - Seperate for small keyboards
          #{ command = "opensnitch-ui"; always = false; notification = true; }           # Firewall
          { command = "${pkgs.redshift}/bin/redshift -P -O 3000"; always = false; notification = false; }    # Gamma correction
          { command = "${pkgs.volctl}/bin/volctl"; always = false; notification = false; }                 # Volume Control
          { command = "${pkgs.xbanish}/bin/xbanish"; always = false; notification = false; }                # Hide Mouse Cursor when typing
          #{ command = "${pkgs.xidlehook}/bin/xidlehook --not-when-fullscreen --not-when-audio --timer 600 ~/.config/i3/scripts/lock.sh ' ' --timer 300 'xset dpms force off' ' ' --timer 900 'systemctl suspend' ' '"; always = false; notification = false; } # Power Management
          { command = "${pkgs.xidlehook}/bin/xidlehook --timer 600 ~/.config/i3/scripts/lock.sh ' ' --timer 300 'xset dpms force off' ' ' --timer 900 'systemctl suspend' ' '"; always = false; notification = false; } # Power Management
          #{ command = "~/.config/i3/scripts/x_3screenlayout.sh"; always = false; notification = false; }     # Display Setup # TODO - Seperate for different screens / systems
          #{ command = "~/.config/scripts/decrypt.sh"; always = false; notification = false; }  # Decryption script # TODO - Secrets and SystemD service
        ];
        terminal = "kitty";
        workspaceAutoBackAndForth = true;
        workspaceLayout = "default"; # Bounce back and forth between workspaces using same workspace key
        workspaceOutputAssign = let  ## TODO This is used in multiple areas - move to top of configuration
          mon_left = "DP-3";
          mon_center = "DP-2";
          mon_right = "HDMI-1";
        in [
           { workspace = "1"; output = "${mon_left}"; }
           { workspace = "4"; output = "${mon_left}"; }
           { workspace = "7"; output = "${mon_left}"; }
           { workspace = "2"; output = "${mon_center}"; }
           { workspace = "5"; output = "${mon_center}"; }
           { workspace = "8"; output = "${mon_center}"; }
           { workspace = "3"; output = "${mon_right}"; }
           { workspace = "6"; output = "${mon_right}"; }
           { workspace = "9"; output = "${mon_right}"; }
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

        for_window [title="Zoom - Licensed Account"] floating enable floating_minimum_size 360x690; floating_maximum_size 360x690;
        for_window [title="Settings" ] floating enable
        for_window [class="virt-manager" ] floating enable

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

        bindcode Mod4+Shift+$KP_1 move container to workspace $ws1
        bindcode Mod4+Shift+$KP_2 move container to workspace $ws2
        bindcode Mod4+Shift+$KP_3 move container to workspace $ws3
        bindcode Mod4+Shift+$KP_4 move container to workspace $ws4
        bindcode Mod4+Shift+$KP_5 move container to workspace $ws5
        bindcode Mod4+Shift+$KP_6 move container to workspace $ws6
        bindcode Mod4+Shift+$KP_7 move container to workspace $ws7
        bindcode Mod4+Shift+$KP_8 move container to workspace $ws8
        bindcode Mod4+Shift+$KP_9 move container to workspace $ws9
        bindcode Mod4+Shift+$KP_0 move container to workspace $ws10

      '';
    };
  };

  services = {
    picom = {
      enable = false;
      settings = {
        shadow = true;
        no-dnd-shadow = true;
        no-dock-shadow = true;
        shadow-radius = 7;
        shadow-offset-x = -7;
        shadow-offset-y = -7;
        shadow-opacity = 0.7;
        shadow-red = 0.0;
        shadow-green = 0.0;
        shadow-blue = 0.0;
        shadow-exclude = [
          "name = 'Notification'"
          "class_g = 'Conky'"
          "class_g ?= 'Notify-osd'"
          "class_g = 'Cairo-clock'"
        ];
        shadow-ignore-shaped = false;
        xinerama-shadow-crop = false;
        opacity = 0.8;
        inactive-opacity = 0.8;
        active-opacity = 1.0;
        frame-opacity = 0.7;
        inactive-opacity-override = false;
        alpha-step = 0.06;
        inactive-dim = 0.0;
        blur-kern = "3x3box";
        blur-background-exclude = [
          "window_type = 'dock'"
          "window_type = 'desktop'"
        ];
        fading = true;
        fade-in-step = 0.03;
        fade-out-step = 0.03;
        fade-exclude = [ ];

        mark-wmwin-focused = true;
        mark-ovredir-focused = true;
        detect-rounded-corners = true;
        detect-client-opacity = true;
        backend = "glx";
        vsync = false;
        dbe = false;
        paint-on-overlay = true;
        focus-exclude = [
          "class_g = 'Cairo-clock'"
        ];
        detect-transient = true;
        detect-client-leader = true;
        invert-color-include = [ ];
        glx-copy-from-front = false;
        use-damage = false;
        wintypes = {
          tooltip = {
            tooltip = {
              fade=true;
              shadow=true;
              opacity=0.95;
              focus=true;
              full-shadow=false;
            };
            popup_menu = {
              opacity=1.0;
            };
            dropdown_menu = {
              opacity=1.0;
            };
            utility = {
              shadow=false;
              opacity=1.0;
            };
          };
        };
        class_g = "zoom";
      };
    };
  };
}
