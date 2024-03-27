{config, lib, pkgs, osConfig, specialArgs, ...}:

let
  inherit (specialArgs) displays networkInterface org role;
  cfg = config.host.home.applications.i3status-rust;
in
  with lib;
{
  options = {
    host.home.applications.i3status-rust = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Sway/i3 status bar";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          i3status-rust
        ];
    };

    programs = {
      i3status-rust = {
        enable = true;
        package = pkgs.i3status-rust;
        bars = {
          center = {
            icons = "awesome6";
            theme = "native";
            settings = {
              theme = {
                theme = "native";
              };
              icons = {
                icons = "awesome6";
              };
            };
            blocks = mkMerge [
              (mkIf (role != "laptop") (mkAfter [
                 {
                   block = "time";
                   interval = 1;
                   format = "$icon $timestamp.datetime(f:'%a %Y-%m-%d %H:%M:%S', l:en_US)";
                   click = [
                     {
                       button = "left";
                       cmd = "${pkgs.gnome.zenity}/bin/zenity --calendar";
                     }
                   ];
                 }
              ]))

              (mkIf (role == "laptop") (mkAfter [
                 {
                   block = "time";
                   interval = 60;
                   format = "$icon $timestamp.datetime(f:'%H:%M', l:en_US)";
                   format_alt = "$icon $timestamp.datetime(f:'%a %Y-%m-%d %H:%M:%S', l:en_US)";
                   click = [
                     {
                       button = "left";
                       cmd = "${pkgs.gnome.zenity}/bin/zenity --calendar";
                     }
                   ];
                 }
              ]))

              (mkIf ((config.host.home.applications.redshift.enable) || (config.host.home.applications.wl-gammarelay.enable)) (mkAfter [
                {
                  block = "hueshift";
                  step = 500;
                  click_temp = 300;
                  max_temp = 6500;
                  min_temp = 1000;
                }
              ]))

              (mkAfter [
                 {
                   block = "notify";
                   format = " $icon {($notification_count.eng(w:1)) |}";
                 }
              ])

              ## TODO Split for different hardware
              (mkAfter [
                  {
                    block = "sound";
                    device_kind = "sink";
                    driver = "pulseaudio";
                    format = " $icon { $volume|} ";
                    #mappings = {
                    #  "alsa_output.usb-0b0e_Jabra_SPEAK_510_USB_745C4BA487C2021900-00.analog-stereo" = "";
                    #  "alsa_output.pci-0000_10_00.6.analog-stereo.2" = "";
                    #};
                    #"bluez_output.00_00_00_00_00_00.1" = "";
                    step_width = 1;
                    max_vol = 100;
                    click = [
                      {
                        button = "left";
                        cmd = "sound-tool volume mute";
                      }
                      {
                        button = "right";
                        cmd = "sound-tool output choose";
                      }
                    ];
                  }
                ])

              (mkIf (role == "laptop") (mkAfter [
                {
                  block = "net";
                  device = networkInterface;
                  format = " $icon ";
                  format_alt = " {$ssid $signal_strength | Wired connection}";
                  interval = 60;
                  click = [
                    {
                      button = "left";
                      cmd = "${pkgs.kitty}/bin/kitty -e nmtui";
                    }
                    {
                      button = "right";
                      update = true;
                    }
                  ];
                }
              ]))

              (mkIf (role == "laptop") (mkAfter [
                {
                  block = "battery";
                  driver = "sysfs";
                }
              ]))
            ];
          };
          left = {
            icons = "awesome6";
            theme = "native";
            settings = {
              theme = {
                theme = "native";
              };
              icons = {
                icons = "awesome6";
              };
            };
            blocks = [
              {
                block = "custom";
                command = "curl https://wttr.in?format=1";
                interval = 3600;
                click = [
                  {
                    button = "left";
                    cmd = "${pkgs.kitty}/bin/kitty --class \"kitty_floating\" --title \"Weather report as of $(date)\" bash -c \"echo -e 'Weather Report - Press ENTER to close\n' ; curl https://wttr.in?F; read\"";
                  }
                ];
              }
              {
                block = "custom";
                command = "BLOCK_INSTANCE=tron echo \"$(curl -sSL https://cryptoprices.cc/TRX)\"";
                interval = 3600;
                click = [
                  {
                    button = "left";
                    cmd = "${pkgs.firefox}/bin/firefox https://coinmarketcap.com/currencies/tron/";
                  }
                ];
              }
              {
                block = "custom";
                command = "BLOCK_INSTANCE=bitcoin echo \"$(curl -sSL https://cryptoprices.cc/BTC)\"";
                interval = 3600;
                click = [
                  {
                    button = "left";
                    cmd = "${pkgs.firefox}/bin/firefox https://coinmarketcap.com/currencies/bitcoin/";
                  }
                ];
              }
            ];
          };
          right = {
            icons = "awesome6";
            theme = "native";
            settings = {
              theme = {
                theme = "native";
              };
              icons = {
                icons = "awesome6";
              };
            };
            blocks = [
              {
                block = "disk_space";
                info_type = "free";
                alert_unit = "GB";
                alert = 10.0;
                warning = 15.0;
                format = " $icon $used.eng(w:2)";
                format_alt = " $icon $used / $total ";
                path = "/";
                interval = 600;
                click = [
                  {
                    button = "right";
                    update = true;
                  }
                ];
              }
              {
                block = "temperature";
                format = " $icon $min min, $max max, $average avg ";
                format_alt = " $icon $max max ";
                interval = 10;
              }
              {
                block = "memory";
                format = " $icon $mem_used($mem_used_percents.eng(w:1)) $mem_avail $mem_used_percents.eng(w:1) ";
                format_alt = " $icon_swap $swap_free.eng(w:3,u:B,p:M)/$swap_total.eng(w:3,u:B,p:M)($swap_used_percents.eng(w:2)) ";
                interval = 1;
                warning_mem = 70;
                critical_mem = 90;
              }
              {
                block = "cpu";
                format = " $icon $utilization $frequency";
                format_alt = " $icon $frequency{ $boost|} ";
                interval = 1;
              }
              {
                block = "load";
                format = " $icon 1m: $1m.eng(w:4) 5: $5m.eng(w:4) 15: $15m.eng(w:4)";
                interval = 5;
              }
              {
                block = "net";
                device = networkInterface;
                format = " $speed_down.eng(w:6) $speed_up.eng(w:6) $icon {$ssid $signal_strength | Wired connection}";
                interval = 1;
                click = [
                  {
                    button = "left";
                    cmd = "${pkgs.networkmanager}/bin/nmcli device wifi rescan && ${pkgs.kitty}/bin/kitty -e nmtui";
                  }
                ];
              }
            ];
          };
        };
      };
    };
  };
}
