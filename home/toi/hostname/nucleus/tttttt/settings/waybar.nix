{ config, lib, pkgs, ... }:
with lib; {
  config = mkIf config.host.home.applications.waybar.enable {
    programs = {
      waybar = {
      };
    };

    xdg = {
      configFile = {
        "waybar/config" = {
          text = ''
            {
              "height": 30,
              "layer": "top",
              "spacing": 4,
              "modules-left": [
                "hyprland/workspaces"
              ],
              "modules-right": [
                "temperature",
                "cpu",
                "disk",
                "memory",
                "temperature",
                "clock",
                "custom/power"
              ],
              "clock": {
                "tooltip-format": "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>",
                "format-alt": "{:%Y-%m-%d}"
              },
              "cpu": {
                "format": "{load} {usage} {avg_frequency} ",
                "interval": 60,
                "on-click": "${pkgs.gnome-system-monitor}/bin/gnome-system-monitor --show-resources-tab"
              },
              "disk": {
                "format": "{used}/{total}",
                "interval": 600,
                "on-click": "kitty ncdu ~",
                "on-click-right": "${pkgs.gnome-system-monitor}/bin/gnome-system-monitor --show-file-systems-tab",
                "path": "/"
              },
              "hyprland/submap": {},
              "hyprland/window": {
                "max-length": 200,
                "separate-outputs": true
              },
              "hyprland/workspaces": {
                "active-only": "false",
                "on-click": "activate",
                "sort-by-number": true
              },
              "memory": {
                "format": "{used:0.1f}G/{total:0.1f}G ",
                "interval": 300,
                "on-click": "${pkgs.gnome-system-monitor}/bin/gnome-system-monitor --show-processes-tab"
              },
              "temperature": {
                "critical-threshold": 80,
                "format": "{temperatureC}°C {icon}",
                "format-icons": [
                    "",
                    "",
                    ""
                ]
              },
              "custom/power": {
                "format" : "⏻ ",
                "tooltip": false,
                "menu": "on-click",
                "menu-file": "$HOME/.config/waybar/power_menu.xml", // Menu file in resources folder
                "menu-actions": {
                  "shutdown": "shutdown",
                  "reboot": "reboot",
                  "refresh": "hyprctl dispatch exit"
                }
              }
            }
          '';
        };


        "waybar/modules.d/power_menu.xml" = {
          text = ''
            <?xml version="1.0" encoding="UTF-8"?>
            <interface>
              <object class="GtkMenu" id="menu">
                <child>
                    <object class="GtkMenuItem" id="refresh">
                        <property name="label">Refresh</property>
                    </object>
                </child>
                <child>
                  <object class="GtkSeparatorMenuItem" id="delimiter1"/>
                </child>
                <child>
                    <object class="GtkMenuItem" id="reboot">
                        <property name="label">Reboot</property>
                    </object>
                </child>
                <child>
                    <object class="GtkMenuItem" id="shutdown">
                        <property name="label">Shutdown</property>
                    </object>
                </child>
              </object>
            </interface>
          '';
        };
      };
    };
    wayland.windowManager.hyprland = mkIf (config.host.home.feature.gui.displayServer == "wayland" && config.host.home.feature.gui.windowManager == "hyprland" && config.host.home.feature.gui.enable) {
      settings = {
        bind = [
          "SUPER_SHIFT, W, exec, ${config.host.home.feature.uwsm.prefix}systemctl --user restart waybar.service"
        ];
      };
    };
  };
}
