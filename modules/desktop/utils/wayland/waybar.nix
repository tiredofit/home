{ config, inputs, lib, pkgs, ... }:
let
  cfg = config.host.home.applications.waybar;

  script_displayhelper_waybar = pkgs.writeShellScriptBin "displayhelper_waybar" ''
    _get_display_name() {
        ${pkgs.wlr-randr}/bin/wlr-randr --json | ${pkgs.jq}/bin/jq -r --arg desc "$(echo "''${1}" | sed "s|^d/||g")" '.[] | select(.description | test("^(d/)?\($desc)")) | .name'
    }

    if [ -z "''${1}" ]; then exit 1; fi

    _tmp_waybar_config=$(mktemp)
    case "''${1}" in
        * )
            display_name=$(_get_display_name "''${1}")
            jq -n \
                --arg output "''${display_name}" \
                --arg xdg_config_home "''${XDG_CONFIG_HOME}" \
                    '
                      [
                          {
                              "output": $output,
                              "include": ($xdg_config_home + "/waybar/bar-primary.json")
                          }
                      ]
                    ' \
                    > ''${_tmp_waybar_config}
            shift
        ;;
    esac

    for display in "''${@}" ; do
        display_counter=''${display_counter:-"2"}

        case "''${display_counter}" in
            2 )
                _bar_name="secondary"
            ;;
            3 )
                _bar_name="tertiary"
            ;;
            * )
                _bar_name="wildcard"
            ;;
        esac

        display_name=$(_get_display_name "''${display}")

        if [ "''${display_counter}" -le 3 ] ; then
            if [ -z "''${display_name}" ] ; then break; fi
            jq \
                --arg bar_name "''${_bar_name}" \
                --arg output "''${display_name}" \
                --arg xdg_config_home "''${XDG_CONFIG_HOME}" \
                    ' . +
                        [
                            {
                                "output": $output,
                                "include": ($xdg_config_home + "/waybar/bar-" + $bar_name + ".json")
                            }
                        ]
                    ' \
                        ''${_tmp_waybar_config} > ''${_tmp_waybar_config}-temp && mv ''${_tmp_waybar_config}-temp ''${_tmp_waybar_config}

            (( display_counter+=1 ))
        else
            jq \
                '. +
                    [
                        {
                            "output": (map("!" + .output) | join(", ")),
                            "include": "/home/dave/.config/waybar/bar-wildcard.json"
                        }
                    ]
                ' \
                        ''${_tmp_waybar_config} > ''${_tmp_waybar_config}-temp && mv ''${_tmp_waybar_config}-temp ''${_tmp_waybar_config}
        fi
    done

    cp -aR "''${_tmp_waybar_config}" "''${XDG_CONFIG_HOME}"/waybar/config
    rm -rf \
        "''${_tmp_waybar_config}" \
        "''${_tmp_waybar_config}"-temp
    systemctl --user restart waybar.service
  '';
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
      service.enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Auto start on user session start";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          script_displayhelper_waybar
        ];
    };

    programs = {
      waybar = {
        enable = true;
        package = pkgs.unstable.waybar;
        systemd.enable = false;
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

          #custom-hyprsunset {
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

    systemd.user.services.waybar = mkIf cfg.service.enable {
      Unit = {
        Description = "Highly customizable Wayland bar for Sway and Wlroots based compositors.";
        Documentation = "man:waybar(5)";
        After = [ "graphical-session.target" ];
      };

      Service = {
        Type = "exec";
        ExecStart = "${pkgs.waybar}/bin/waybar";
        ExecReload = "kill -SIGUSR2 $MAINPID";
        Restart = "on-failure";
        Slice = "app-graphical.slice";
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };

    wayland.windowManager.hyprland = mkIf (config.host.home.feature.gui.displayServer == "wayland" && config.host.home.feature.gui.windowManager == "hyprland" && config.host.home.feature.gui.enable) {
      settings = {
        bind = [
          "SUPER_SHIFT, W, exec, ${config.host.home.feature.uwsm.prefix}systemctl --user restart waybar.service"
        ];
      };
    };

    xdg = {
      configFile = {
        "waybar/modules.d/custom.json" = {
          text = ''
            {
              "custom/cryptotrackingBTC": {
                "exec": "${pkgs.curl}/bin/curl -sSL https://cryptoprices.cc/BTC",
                "format": "{}",
                "restart-interval": 3600
              },
              "custom/cryptotrackingTRX": {
                "exec": "${pkgs.curl}/bin/curl -sSL https://cryptoprices.cc/TRX",
                "format": "{}",
                "restart-interval": 3600
              },
              "custom/notification": {
                "escape": true,
                "exec": "swaync-client -swb",
                "exec-if": "which swaync-client",
                "format": "{} {icon}",
                "format-icons": {
                    "dnd-inhibited-none": "",
                    "dnd-inhibited-notification": "<span foreground='red'><sup></sup></span>",
                    "dnd-none": "",
                    "dnd-notification": "<span foreground='red'><sup></sup></span>",
                    "inhibited-none": "",
                    "inhibited-notification": "<span foreground='red'><sup></sup></span>",
                    "none": "",
                    "notification": "<span foreground='red'><sup></sup></span>"
                },
                "on-click": "swaync-client -t -sw",
                "on-click-right": "swaync-client -d -sw",
                "return-type": "json",
                "tooltip": false
              },
              "custom/hyprsunset-temperature": {
                "restart-interval": 3600,
                "exec": "sleep 0.3; hyprctl hyprsunset temperature",
                "exec-on-event": true,
                "format": "{} ",
                "on-click": "hyprctl hyprsunset temperature 3000",
                "on-click-middle": "hyprctl hyprsunset temperature 5000",
                "on-click-right": "hyprctl hyprsunset temperature 6500",
                "on-scroll-down": "hyprctl hyprsunset temperature -500",
                "on-scroll-up": "hyprctl hyprsunset temperature +500"
              },
              "custom/weather": {
                "exec": "${pkgs.wttrbar}/bin/wttrbar",
                "format": "{} °",
                "restart-interval": 3600,
                "return-type": "json",
                "tooltip": true
              }
            }
          '';
        };
        "waybar/modules.d/hardware.json" = {
            text = ''
              {
                "battery": {
                  "interval": 60,
                  "states": {
                    "warning": 30,
                    "critical": 15
                  },
                  "format": "{capacity}% {icon}",
                  "format-icons": ["", "", "", "", ""],
                  "max-length": 25
                },
                "bluetooth": {
                  "format": " {status}",
                  "format-connected": " {num_connections} connected",
                  "format-disabled": "Bluetooth Disabled",
                  "on-click": "blueman-manager",
                  "tooltip-format": "{controller_alias}\t{controller_address}",
                  "tooltip-format-connected": "{controller_alias}\t{controller_address}\n\n{device_enumerate}",
                  "tooltip-format-enumerate-connected": "{device_alias}\t{device_address}"
                },
                "cpu": {
                  "format": "{load} {usage} {avg_frequency} ",
                  "interval": 10,
                  "on-click": "${pkgs.gnome-system-monitor}/bin/gnome-system-monitor --show-resources-tab"
                },
                "disk": {
                  "format": "{used}/{total}",
                  "interval": 30,
                  "on-click": "kitty ncdu ~",
                  "on-click-right": "${pkgs.gnome-system-monitor}/bin/gnome-system-monitor --show-file-systems-tab",
                  "path": "/"
                },
                "keyboard-state": {
                  "capslock": true,
                  "device-path": "event3",
                  "format": {
                    "capslock": "C {icon}",
                    "numlock": "N {icon}",
                    "scrolllock": "S {icon}"
                  },
                  "format-icons": {
                    "locked": "",
                    "unlocked": ""
                  },
                  "numlock": true,
                  "scrollock": true
                },
                "memory": {
                  "format": "{used:0.1f}G/{total:0.1f}G ",
                  "interval": 10,
                  "on-click": "${pkgs.gnome-system-monitor}/bin/gnome-system-monitor --show-processes-tab"
                },
                "network": {
                  "format-alt": "{ifname}: {ipaddr}/{cidr}",
                  "format-disconnected": "Disconnected ⚠",
                  "format-ethernet": "{ipaddr}/{cidr} ",
                  "format-linked": "{ifname} (No IP) ",
                  "format-wifi": "{essid} ({signalStrength}%)  ",
                  "on-click-right": "nmcli device wifi rescan && kitty sudo nmtui",
                  "tooltip-format": "{ifname} via {gwaddr} "
                },
                "pulseaudio": {
                  "format": "{volume}%  {icon}  {format_source}",
                  "format-bluetooth": "{volume}% {icon} {format_source}",
                  "format-bluetooth-muted": " {icon} {format_source}",
                  "format-icons": {
                    "car": "",
                    "default": [
                        "",
                        "",
                        ""
                    ],
                    "hands-free": "",
                    "headphone": "",
                    "headset": "",
                    "phone": "",
                    "portable": ""
                  },
                  "format-muted": " {format_source}",
                  "format-source": " {volume}% ",
                  "format-source-muted": "",
                  "on-click": "pwvucontrol",
                  "on-click-right": "sound-tool output cycle"
                },
                "temperature": {
                  "critical-threshold": 80,
                  "format": "{temperatureC}°C {icon}",
                  "format-icons": [
                      "",
                      "",
                      ""
                  ]
                }
              }
          '';
        };

        "waybar/modules.d/hyprland.json" = {
          text = ''
            {
              "hyprland/submap": {},
              "hyprland/window": {
                  "max-length": 200,
                  "separate-outputs": true
              },
              "hyprland/workspaces": {
                  "active-only": "false",
                  "on-click": "activate",
                  "sort-by-number": true
              }
            }
          '';
        };

        "waybar/modules.d/user.json" = {
          text = ''
            {
              "user": {
                "format": "uptime {work_H} {work_M} {work_S} ↑)",
                "height": 30,
                "icon": true,
                "interval": 60,
                "width": 30
              }
            }
          '';
        };

        "waybar/modules.d/utils.json" = {
          text = ''
            {
               "clock": {
                 "actions": {
                 "on-click-backward": "tz_down",
                 "on-click-forward": "tz_up",
                 "on-click-right": "mode",
                 "on-scroll-down": "shift_down",
                 "on-scroll-up": "shift_up"
               },
               "calendar": {
                 "format": {
                   "days": "<span color='#ecc6d9'><b>{}</b></span>",
                   "months": "<span color='#ffead3'><b>{}</b></span>",
                   "today": "<span color='#ff6699'><b><u>{}</u></b></span>",
                   "weekdays": "<span color='#ffcc66'><b>{}</b></span>",
                   "weeks": "<span color='#99ffdd'><b>W{}</b></span>"
                 },
                 "mode": "month",
                 "mode-mon-col": 2,
                 "on-click-right": "mode",
                 "on-scroll": 1,
                 "weeks-pos": ""
               },
                 "format": "{:%H:%M:%S}",
                 "format-alt": "{:%Y-%m-%d}",
                 "interval": 1,
                 "tooltip-format": "<tt><small>{calendar}</small></tt>"
               },
               "idle_inhibitor": {
                 "format": "{icon}",
                 "format-icons": {
                   "activated": "",
                   "deactivated": ""
                 }
               },
               "tray": {
                 "icon-size": 22,
                 "spacing": 10
               }
            }
          '';
        };

        "waybar/modules.d/wlr.json" = {
          text = ''
            {
              "wlr/taskbar": {
                "app_ids-mapping": {
                    "firefoxdeveloperedition": "firefox-developer-edition"
                },
                "format": "{icon} {title}",
                "icon-size": 28,
                "icon-theme": "Numix-Circle",
                "ignore-list": [
                    "Alacritty"
                ],
                "on-click": "activate",
                "on-click-middle": "close",
                "on-click-right": "minimize",
                "tooltip-format": "{title}"
              }
            }
          '';
        };

        "waybar/bar-primary.json" = {
          text = ''
            {
              "include": [
                 "~/.config/waybar/modules.d/custom.json",
                 "~/.config/waybar/modules.d/hardware.json",
                 "~/.config/waybar/modules.d/hyprland.json",
                 "~/.config/waybar/modules.d/utils.json",
                 "~/.config/waybar/modules.d/wlr.json",
              ],
              "height": 30,
              "layer": "top",
              "spacing": 4,
              "modules-center": [
                "hyprland/window"
              ],
              "modules-left": [
                "hyprland/workspaces"
              ],
              "modules-right": [
                "custom/hyprsunset-temperature",
                "idle_inhibitor",
                "battery",
                "keyboard-state",
                "pulseaudio",
                "custom/notification",
                "clock",
                "tray"
              ],
            }
          '';
        };

        "waybar/bar-secondary.json" = {
          text = ''
            {
              "include": [
                 "~/.config/waybar/modules.d/custom.json",
                 "~/.config/waybar/modules.d/hardware.json",
                 "~/.config/waybar/modules.d/hyprland.json",
                 "~/.config/waybar/modules.d/utils.json",
                 "~/.config/waybar/modules.d/wlr.json",
              ],
              "layer": "top",
              "height": 30,
              "spacing": 4,
              "modules-center": [
                "hyprland/window"
              ],
              "modules-left": [
                "hyprland/workspaces"
              ],
              "modules-right": [
                "temperature",
                "cpu",
                "disk",
                "memory",
                "bluetooth",
                "network"
              ],
            }
          '';
        };

        "waybar/bar-tertiary.json" = {
          text = ''
            {
              "include": [
                 "~/.config/waybar/modules.d/custom.json",
                 "~/.config/waybar/modules.d/hyprland.json",
                 "~/.config/waybar/modules.d/user.json",
                 "~/.config/waybar/modules.d/wlr.json",
              ],
              "height": 30,
              "layer": "top",
              "spacing": 8,
              "modules-center": [],
              "modules-left": [
                "hyprland/workspaces"
              ],
              "modules-right": [
                "custom/weather",
                "custom/cryptotrackingBTC",
                "custom/cryptotrackingTRX",
                "user"
              ],
            }
          '';
        };

        "waybar/bar-wildcard.json" = {
          text = ''
            {
              "include": [
                 "~/.config/waybar/modules.d/custom.json",
                 "~/.config/waybar/modules.d/hyprland.json",
                 "~/.config/waybar/modules.d/user.json",
                 "~/.config/waybar/modules.d/wlr.json",
              ],
              "height": 30,
              "layer": "top",
              "spacing": 8,
              "modules-center": [],
              "modules-left": [
                "hyprland/workspaces"
              ],
              "modules-right": [
              ],
            }
          '';
        };
      };
    };
  };
}