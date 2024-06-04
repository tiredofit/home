{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.waybar;
in
  with lib;
{
  options = {
    host.home.applications.waybar = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Status bar for Wayland";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          wttrbar
        ];
    };

    programs = {
      waybar = {
        enable = true;
        settings = [
          {
            # CENTER
            "layer" = "top";
            "output" = [ "DP-2" ];
            "height" = 30;
            "width" = null;
            "spacing"= 4;
            "modules-left" = [
               "hyprland/workspaces"
            ];
            "modules-center" = [
                "hyprland/window"
            ];
            "modules-right" = [
               "custom/wl-gammarelay-temperature"
               "idle_inhibitor"
               "keyboard-state"
               "pulseaudio"
               "custom/notification"
               "clock"
               "tray"
            ];
            "hyprland/workspaces" = {
               "on-click" = "activate";
               "active-only" = "false";
               "sort-by-number" = true;
            };
            "hyprland/window" = {
               "max-length" = 200;
               "separate-outputs" = true;
            };
            "wlr/taskbar" = {
                "format" = "{icon} {title}";
                "icon-size" = 28;
                "icon-theme" = "Numix-Circle";
                "tooltip-format" = "{title}";
                "on-click" = "activate";
                "on-click-middle" = "close";
                "on-click-right" = "minimize";
                "ignore-list" = [
                   "Alacritty"
                ];
                "app_ids-mapping" = {
                   "firefoxdeveloperedition" = "firefox-developer-edition";
                };
            };
            "custom/wl-gammarelay-temperature" = {
               "format" = "{} ";
               "exec" = "wl-gammarelay-rs watch {t}";
               "on-click" = "busctl --user set-property rs.wl-gammarelay / rs.wl.gammarelay Temperature q 3000";
               "on-click-middle" = "busctl --user set-property rs.wl-gammarelay / rs.wl.gammarelay Temperature q 5000";
               "on-click-right" = "busctl --user set-property rs.wl-gammarelay / rs.wl.gammarelay Temperature q 6500";
               "on-scroll-up" = "busctl --user -- call rs.wl-gammarelay / rs.wl.gammarelay UpdateTemperature n +500";
               "on-scroll-down" = "busctl --user -- call rs.wl-gammarelay / rs.wl.gammarelay UpdateTemperature n -500";
            };
            "custom/notification" = {
                "tooltip" = false;
                #"icon-size" = "14";
                "format" = "{} {icon}";
                "format-icons" = {
                   "notification" = "<span foreground='red'><sup></sup></span>";
                   "none" = "";
                   "dnd-notification" = "<span foreground='red'><sup></sup></span>";
                   "dnd-none" = "";
                   "inhibited-notification" = "<span foreground='red'><sup></sup></span>";
                   "inhibited-none" = "";
                   "dnd-inhibited-notification" = "<span foreground='red'><sup></sup></span>";
                   "dnd-inhibited-none" = "";
                };
                "return-type" = "json";
                "exec-if" = "which swaync-client";
                "exec" = "swaync-client -swb";
                "on-click" = "swaync-client -t -sw";
                "on-click-right" = "swaync-client -d -sw";
                "escape" = true ;
            };
            "hyprland/submap" = {};
            "keyboard-state" = {
               "numlock" = true;
               "capslock" = true;
               "scrollock" = true;
               "format" = {
                  "numlock" = "N {icon}";
                  "capslock" = "C {icon}";
                  "scrolllock" = "S {icon}";
               };
               "format-icons" = {
                  "locked" = "";
                  "unlocked" = "";
               };
               "device-path" = "event3";
            };
            "idle_inhibitor" = {
                "format" = "{icon}";
                "format-icons" = {
                   "activated" = "";
                   "deactivated" = "";
                };
            };
            "tray" = {
                "icon-size" = 22;
                "spacing" = 10;
            };
            "clock" = {
                "interval" = 1;
                "format" = "{:%H:%M:%S}";
                "format-alt" = "{:%Y-%m-%d}";
                "tooltip-format" = "<tt><small>{calendar}</small></tt>";
                "calendar" = {
                    "mode" = "month";
                    "mode-mon-col" = 2;
                    "weeks-pos" = "";
                    "on-scroll" = 1;
                    "on-click-right" = "mode";
                    "format" = {
                       "months" = "<span color='#ffead3'><b>{}</b></span>";
                       "days" = "<span color='#ecc6d9'><b>{}</b></span>";
                       "weeks" = "<span color='#99ffdd'><b>W{}</b></span>";
                       "weekdays" = "<span color='#ffcc66'><b>{}</b></span>";
                       "today" = "<span color='#ff6699'><b><u>{}</u></b></span>";
                    };
                };
                "actions" = {
                   "on-click-right" = "mode";
                   "on-click-forward" = "tz_up";
                   "on-click-backward" = "tz_down";
                   "on-scroll-up" = "shift_up";
                   "on-scroll-down" = "shift_down";
                };
            };
            "pulseaudio" = {
                "format" = "{volume}%  {icon}  {format_source}";
                "format-bluetooth" = "{volume}% {icon} {format_source}";
                "format-bluetooth-muted" = " {icon} {format_source}";
                "format-muted" = " {format_source}";
                "format-source" = " {volume}% ";
                "format-source-muted" = "";
                "format-icons" = {
                  "headphone" = "";
                  "hands-free" = "";
                  "headset" = "";
                  "phone" = "";
                  "portable" = "";
                  "car" = "";
                  "default" = [
                     ""
                     ""
                     ""
                  ];
                };
                "on-click" = "pavucontrol";
            };
          }
          {
            # RIGHT
            "layer" = "top";
            "output" = "HDMI-A-1";
            "height" = 36;
            "spacing" = 4;
            "modules-left" = [
              "hyprland/workspaces"
            ];
            "modules-center" = [
              "hyprland/window"
            ];
            "modules-right" = [
              "temperature"
              "cpu"
              "disk"
              "memory"
              "bluetooth"
              "network"
            ];
            "hyprland/workspaces" = {
              "on-click" = "activate";
              "active-only" = "true";
            };
            "hyprland/window" = {
               "max-length" = 200;
               "separate-outputs" = true;
            };
            "wlr/taskbar" = {
                "format" = "{icon} {title}";
                "icon-size" = 28;
                "icon-theme" = "Numix-Circle";
                "tooltip-format" = "{title}";
                "on-click" = "activate";
                "on-click-middle" = "close";
                "on-click-right" = "minimize";
                "ignore-list" = [
                   "Alacritty"
                ];
                "app_ids-mapping" = {
                   "firefoxdeveloperedition" = "firefox-developer-edition";
                };
            };
            "cpu" = {
              "interval" = 10;
              "format" = "{load} {usage} {avg_frequency} ";
              "on-click" = "gnome-system-monitor --show-resources-tab";
            };
            "disk" = {
              "interval" = 30;
              "format" = "{used}/{total}";
              "path" = "/";
              "on-click" = "kitty ncdu ~";
              "on-click-right" = "gnome-system-monitor --show-file-systems-tab";
            };
            "memory" = {
              "interval" = 10;
              "format" = "{used:0.1f}G/{total:0.1f}G ";
              "on-click" = "gnome-system-monitor --show-processes-tab";
            };
            "temperature" = {
              # "thermal-zone" = 2,
              # "hwmon-path" = "/sys/class/hwmon/hwmon2/temp1_input",
              "critical-threshold" = 80;
              # "format-critical" = "{temperatureC}°C {icon}";
              "format" = "{temperatureC}°C {icon}";
              "format-icons" = [
                  ""
                  ""
                  ""
              ];
            };
            "bluetooth" = {
               # "controller" = "controller1" # specify the alias of the controller if there are more than 1 on the system
               "format" = " {status}";
               "format-disabled" = "Bluetooth Disabled"; # an empty format will hide the module
               "format-connected" = " {num_connections} connected";
               "tooltip-format" = "{controller_alias}\t{controller_address}";
               "tooltip-format-connected" = "{controller_alias}\t{controller_address}\n\n{device_enumerate}";
               "tooltip-format-enumerate-connected" = "{device_alias}\t{device_address}";
               "on-click" = "blueman-manager";
            };
            "network" = {
               # "interface" = "wlp2*"; # (Optional) To force the use of this interface
               "format-wifi" = "{essid} ({signalStrength}%)  ";
               "format-ethernet" = "{ipaddr}/{cidr} ";
               "tooltip-format" = "{ifname} via {gwaddr} ";
               "format-linked" = "{ifname} (No IP) ";
               "format-disconnected" = "Disconnected ⚠";
               "format-alt" = "{ifname}: {ipaddr}/{cidr}";
               "on-click-right" = "nmcli device wifi rescan && kitty sudo nmtui";
            };
          }
          {
            # LEFT
            "layer" = "top";
            "output" = "DP-3";
            "spacing" = 8;
            "modules-left" = [
              "hyprland/workspaces"
            ];
            "modules-center" = [
            ];
            "modules-right" = [
              "custom/weather"
              "custom/cryptotrackingBTC"
              "custom/cryptotrackingTRX"
              "user"
            ];
            "height" = 30;
            "hyprland/workspaces" = {
               "on-click" = "activate";
               "active-only" = "true";
            };
            "custom/weather" = {
               "format" = "{} °";
               "tooltip" = true;
               "interval" = 3600;
               "exec" = "wttrbar";
               "return-type" = "json";
            };
            "custom/cryptotrackingBTC" = {
               "format" = "{}";
               "exec" = "curl -sSL https://cryptoprices.cc/BTC";
               "restart-interval" = 3600;
            };
            "custom/cryptotrackingTRX" = {
               "format" = "{}";
               "exec" = "curl -sSL https://cryptoprices.cc/TRX";
               "restart-interval" = 3600;
            };
            "user" = {
               "format" = "uptime {work_H} {work_M} {work_S} ↑)";
               "interval" = 60;
               "height" = 30;
               "width" = 30;
               "icon" = true;
            };
          }
        ];
        style = ''
          * {
              font-family: Noto Sans NF, Helvetica, Arial, sans-serif;
              font-size: 13px;
              color: #ffffff;
          }

          window#waybar {
              background-color: rgba(43, 48, 59, 0.5);
              border-bottom: 3px solid rgba(100, 114, 125, 0.5);
              color: #ffffff;
              transition-property: background-color;
              transition-duration: .5s;
          }

          window#waybar.hidden {
              opacity: 0.2;
          }


          window#waybar.empty {
              background-color: transparent;
          }

          button {
              /* Use box-shadow instead of border so the text isn't offset */
              box-shadow: inset 0 -3px transparent;
              border: none;
              border-radius: 0;
          }

          button:hover {
              background: inherit;
              box-shadow: inset 0 -3px #ffffff;
          }

          #workspaces button {
              padding: 0 5px;
              background-color: transparent;
              color: #00ffff;
          }

          #workspaces button:hover {
              background: rgba(0, 0, 0, 0.2);
          }

          #workspaces button.active {
              background-color: #64727D;
              box-shadow: inset 0 -3px #ffffff;
          }

          #workspaces button.urgent {
              background-color: #eb4d4b;
          }

          #mode {
              background-color: #64727D;
              border-bottom: 3px solid #ffffff;
          }

          #clock,
          #bluetooth,
          #battery,
          #cpu,
          #memory,
          #disk,
          #temperature,
          #backlight,
          #network,
          #pulseaudio,
          #wireplumber,
          #custom-media,
          #mode,
          #idle_inhibitor,
          #custom-notification,
          #scratchpad {
              padding: 0 20px;
              color: #ffffff;
          }

          #window,
          #workspaces {
              margin: 0 4px;
          }

          .modules-left > widget:first-child > #workspaces {
              margin-left: 0;
          }

          .modules-right > widget:last-child > #workspaces {
              margin-right: 0;
          }

          #battery {
              background-color: #ffffff;
              color: #000000;
          }

          #battery.charging, #battery.plugged {
              color: #ffffff;
              background-color: #26A65B;
          }

          @keyframes blink {
              to {
                  background-color: #ffffff;
                  color: #000000;
              }
          }

          #battery.critical:not(.charging) {
              background-color: #f53c3c;
              color: #ffffff;
              animation-name: blink;
              animation-duration: 0.5s;
              animation-timing-function: linear;
              animation-iteration-count: infinite;
              animation-direction: alternate;
          }

          label:focus {
              background-color: #000000;
          }

          #temperature {
              background-color: #f0932b;
          }

          #temperature.critical {
              background-color: #eb4d4b;
          }


          #cpu {
              background-color: #2ecc71;
              color: #000000;
          }

          #memory {
              background-color: #9b59b6;
          }

          #disk {
              background-color: #964B00;
          }

          #bluetooth {
              background-color: #64727D;
          }

          #network {
              background-color: #2980b9;
          }

          #network.disconnected {
              background-color: #f53c3c;
          }

          #backlight {
              background-color: #90b1b1;
          }


          #scratchpad {
              background: rgba(0, 0, 0, 0.2);
          }

          #scratchpad.empty {
              background-color: transparent;
          }

          #custom-media {
              background-color: #66cc99;
              color: #2a5c45;
              padding: 0 20px;
              min-width: 100px;
          }

          #custom-wl-gammarelay-temperature {
              background: #264653;
              color: #ffffff;
              padding: 0 20px;
              opacity: 1;
              transition-property: opacity;
              transition-duration: 0.25s;
          }

          #idle_inhibitor {
              background-color: #287271;
          }

          #idle_inhibitor.activated {
              background-color: #ecf0f1;
              color: #2d3436;
          }

          #keyboard-state {
              background: #2a9d8f;
              color: #000000;
              min-width: 16px;
          }

          #keyboard-state > label {
              color: #000000;
              padding: 0 5px;
          }

          #keyboard-state > label.locked {
              background: rgba(255, 255, 255, 0.1);
          }

          #pulseaudio {
              background-color: #8ab17d;
              color: #111111;
          }

          #pulseaudio.muted {
              background-color: #90b1b1;
              color: #2a5c45;
          }

          #custom-notification {
              font-family: "NotoSansMono NF";
              background: #98bb6c;
              color: #ffffff;
              padding: 0 20px;
              opacity: 1;
              transition-property: opacity;
              transition-duration: 0.25s;
          }

          #clock {
              background-color: #879693;
          }

          #tray {
              padding: 0 20px;
              color: #000000;
              background-color: #7593af;
            }

            #tray > .passive {
                -gtk-icon-effect: dim;
                color: #000000;
            }

            #tray > .needs-attention {
                -gtk-icon-effect: highlight;
                background-color: #eb4d4b;
                color: #000000;
            }

            #tray menu * {
                color: #000000;
            }

            #tray menu *:hover {
              background: #7593af;
              color: #000000
            }
        '';
      };
    };

    wayland.windowManager.hyprland = mkIf (config.host.home.feature.gui.displayServer == "wayland" && config.host.home.feature.gui.windowManager == "hyprland" && config.host.home.feature.gui.enable) {
      settings = {
        exec-once = [
          "waybar"
        ];
        bind = [
          "SUPER_SHIFT, W, exec, pkill waybar || waybar"
        ];
      };
    };
  };
}
