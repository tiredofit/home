{ config, lib, pkgs, specialArgs, ...}:
let
  inherit (specialArgs) role;
  dock_left="d/Dell Inc. DELL S3220DGF 63BQF43";
  dock_left_mode="2560x1440@60.0";
  dock_left_position="0,0";
  dock_middle="d/Dell Inc. DELL S3220DGF 9H4VF43";
  dock_middle_mode="2560x1440@119.998";
  dock_middle_position="2560,0";
  dock_right="d/Dell Inc. DELL S3220DGF GSDTF43";
  dock_right_mode="2560x1440@119.99800";
  dock_right_position="5120,0";
  laptop_display="d/Lenovo Group Limited 0x403A";
  laptop_display_mode="1920x1200@60.00";
  laptop_external="HDMI-A-1";
in
  with lib;
{
  host = {
    home = {
      applications = {
        act.enable = true;
        avidemux.enable = true;
        calibre.enable = false;
        chromium.enable = true;
        claude-code.enable = false;
        cryfs.enable = true;
        czkawka.enable = true;
        devenv.enable = false;
        direnv.enable = true;
        file-roller.enable = true;
        floorp.enable = true;
        github-client.enable = true;
        ghostty.enable = true ;
        gnome-software.enable = true;
        hadolint.enable = true;
        kitty.enable = true;
        lazydocker.enable = true;
        lazygit.enable = true;
        meld.enable = true;
        mp3gain.enable = false;
        nix-development_tools.enable = true;
        networkmanager = {
          enable = true;
          systemtray.enable = false;
        };
        nmap.enable = false;
        obsidian.enable = false;
        opensnitch-ui.enable = false;
        python.enable = true;
        pwvucontrol.enable = true;
        rofi.enable = true;
        sonusmix.enable = false;
        shellcheck.enable = true;
        shfmt.enable = true;
        sonixd.enable = true;
        smartgit.enable = true;
        ssh = {
          enable = true;
          relaxedBlocks = [
            "192.168.1.0/24"
          ];
        };
        steam-run.enable = false;
        szyszka.enable = true;
        thunderbird.enable = true;
        virt-manager.enable = true;
        visual-studio-code = {
          enable = mkDefault true;
          defaultApplication.enable = true;
        };
        walker.enable = false;
        wps-office.enable = mkForce true;
        yq.enable = true;
        yt-dlp.enable = true;
        zoom.enable = true;
        zenbrowser.enable = true;
      };
      feature = {
        gui = {
          enable = true;
          displayServer = "wayland";
          windowManager = "hyprland";
        };
      };
      service = {
        decrypt_cryfs_workspace.enable = true;
        vscode-server.enable = mkForce false;
      };
      user = {
        dave = {
          secrets = {
            act = {
              toi.enable = true;
            };
            github = {
              toi.enable = true;
            };
            ssh = {
              sd.enable = true;
              toi.enable = true;
              ghtoi.enable = true;
            };
          };
        };
      };
    };
  };

  host.home.applications.shikane.settings = {
    profile = [
      {
        name = "laptop";
        output = [
          {
            enable = true;
            search = "${laptop_display}";
            mode = "${laptop_display_mode}";
            position = "0,0";
            scale = 1.0;
            transform = "normal";
            adaptive_sync = false;
          }
        ];
        exec = [
          "displayhelper_hyprland   \"${laptop_display}\""
          "displayhelper_hyprpaper  \"${laptop_display}\""
          "displayhelper_waybar     \"${laptop_display}\""
          "displayhelper_hyprlock   \"${laptop_display}\""
          "sound-tool               \"reset\""
        ];
      }
      {
        name = "dock";
        output = [
          {
            enable = false;
            search = "${laptop_display}";
          }
          {
            enable = true;
            search = "${dock_left}";
            mode = "${dock_left_mode}";
            position = "${dock_left_position}";
            scale = 1.0;
            transform = "normal";
            adaptive_sync = false;
          }
          {
            enable = true;
            search = "${dock_middle}";
            mode = "${dock_middle_mode}";
            position = "${dock_middle_position}";
            scale = 1.0;
            transform = "normal";
            adaptive_sync = false;
          }
          {
            enable = true;
            search = "${dock_right}";
            mode = "${dock_right_mode}";
            position = "${dock_right_position}";
            scale = 1.0;
            transform = "normal";
            adaptive_sync = false;
          }
        ];
        exec = [
          "displayhelper_hyprland   \"${dock_middle}\" \"${dock_right}\" \"${dock_left}\""
          "displayhelper_hyprlock   \"${dock_middle}\""
          "displayhelper_hyprpaper  \"${dock_middle}\" \"${dock_right}\" \"${dock_left}\""
          "displayhelper_waybar     \"${dock_middle}\" \"${dock_right}\" \"${dock_left}\""
          "sound-tool               \"disable\"         \"AIR HUB,Jabra SPEAK\""
        ];
      }
#      {
#        name = "laptop (+embedded, -hdmi)";
#        output = [
#          {
#            enable = true;
#            search = "${laptop_display}";
#            mode = "${laptop_display_mode}";
#            position = "0,0";
#            scale = 1.0;
#            transform = "normal";
#            adaptive_sync = false;
#          }
#        ];
#        exec = [
#          "displayhelper_hyprland   \"${laptop_display}\""
#          "displayhelper_hyprpaper  \"${laptop_display}\""
#          "displayhelper_waybar     \"${laptop_display}\""
#          "displayhelper_hyprlock   \"${laptop_display}\""
#          ];
#      }
#      {
#        name = "laptop (+embedded, +hdmi)";
#        output = [
#          {
#            enable = true;
#            search = "${laptop_display}";
#            mode = "${laptop_display_mode}";
#            position = "0,0";
#            scale = 1.0;
#            transform = "normal";
#            adaptive_sync = false;
#          }
#          {
#            enable = true;
#            search = "HDMI-A-1";
#            scale = 1.0;
#            transform = "normal";
#            adaptive_sync = false;
#          }
#        ];
#        exec = [
#          "displayhelper_hyprland   \"${laptop_display}\" \"HDMI-A-1\""
#          "displayhelper_hyprlock   \"${laptop_display}\""
#          "displayhelper_hyprpaper  \"${laptop_display}\" \"HDMI-A-1\""
#          "displayhelper_waybar     \"${laptop_display}\" \"HDMI-A-1\""
#        ];
#      }
#      {
#        name = "laptop (-embedded, +hdmi)";
#        output = [
#          {
#            enable = false;
#            search = "${laptop_display}";
#          }
#          {
#            enable = true;
#            search = "HDMI-A-1";
#            mode = "${laptop_display_mode}";
#            scale = 1.0;
#            transform = "normal";
#            adaptive_sync = false;
#          }
#        ];
#        exec = [
#          "displayhelper_hyprland   \"HDMI-A-1\""
#          "displayhelper_hyprpaper  \"HDMI-A-1\""
#          "displayhelper_hyprlock   \"HDMI-A-1\""
#          "displayhelper_waybar     \"HDMI-A-1\""
#        ];
#      }
#      {
#        name = "laptop (+embedded, -hdmi) + dock (-dp2, -dp1, +hdmi)";
#        output = [
#          {
#            enable = true;
#            search = "${laptop_display}";
#            mode = "${laptop_display_mode}";
#            position = "0,0";
#            scale = 1.0;
#            transform = "normal";
#            adaptive_sync = false;
#          }
#          {
#            enable = true;
#            search = "${dock_right}";
#            mode = "${dock_right_mode}";
#            position = "${dock_right_position}";
#            scale = 1.0;
#            transform = "normal";
#            adaptive_sync = false;
#          }
#        ];
#        exec = [
#          "displayhelper_hyprland   \"${laptop_display}\" \"${dock_right}\""
#          "displayhelper_hyprpaper   \"${laptop_display}\" \"${dock_right}\""
#          "displayhelper_hyprlock   \"${laptop_display}\""
#          "displayhelper_waybar     \"${laptop_display}\" \"${dock_right}\""
#        ];
#      }
#      {
#        name = "laptop (+embedded, +hdmi) + dock (-dp2, -dp1, +hdmi)";
#        output = [
#          {
#            enable = true;
#            search = "${laptop_display}";
#            mode = "${laptop_display_mode}";
#            position = "0,0";
#            scale = 1.0;
#            transform = "normal";
#            adaptive_sync = false;
#          }
#          {
#            enable = true;
#            search = "HDMI-A-1";
#            scale = 1.0;
#            transform = "normal";
#            adaptive_sync = false;
#          }
#          {
#            enable = true;
#            search = "${dock_right}";
#            mode = "${dock_right_mode}";
#            position = "${dock_right_position}";
#            scale = 1.0;
#            transform = "normal";
#            adaptive_sync = false;
#          }
#        ];
#        exec = [
#          "displayhelper_hyprland   \"${laptop_display}\" \"HDMI-A-1\" \"${dock_right}\""
#          "displayhelper_hyprpaper   \"${laptop_display}\" \"HDMI-A-1\" \"${dock_right}\""
#          "displayhelper_hyprlock   \"${laptop_display}\""
#          "displayhelper_waybar     \"${laptop_display}\" \"HDMI-A-1\" \"${dock_right}\""
#        ];
#      }
#      {
#        name = "laptop (-embedded, -hdmi) + dock (-dp2, -dp1, +hdmi)";
#        output = [
#          {
#            enable = false;
#            search = "${laptop_display}";
#          }
#          {
#            enable = true;
#            search = "${dock_right}";
#            mode = "${dock_right_mode}";
#            position = "${dock_right_position}";
#            scale = 1.0;
#            transform = "normal";
#            adaptive_sync = false;
#          }
#        ];
#        exec = [
#          "displayhelper_hyprland   \"${dock_right}\""
#          "displayhelper_hyprpaper  \"${dock_right}\""
#          "displayhelper_hyprlock   \"${dock_right}\""
#          "displayhelper_waybar     \"${dock_right}\""
#        ];
#      }
#      {
#        name = "laptop (-embedded, +hdmi) + dock (-dp2, -dp1, +hdmi)";
#        output = [
#          {
#            enable = false;
#            search = "${laptop_display}";
#          }
#          {
#            enable = true;
#            search = "HDMI-A-1";
#            scale = 1.0;
#            transform = "normal";
#            adaptive_sync = false;
#          }
#          {
#            enable = true;
#            search = "${dock_right}";
#            mode = "${dock_right_mode}";
#            position = "${dock_right_position}";
#            scale = 1.0;
#            transform = "normal";
#            adaptive_sync = false;
#          }
#        ];
#        exec = [
#          "displayhelper_hyprland   \"HDMI-A-1\" \"${dock_right}\""
#          "displayhelper_hyprlock   \"HDMI-A-1\""
#          "displayhelper_hyprpaper  \"HDMI-A-1\" \"${dock_right}\""
#          "displayhelper_waybar     \"HDMI-A-1\" \"${dock_right}\""
#        ];
#      }
#      {
#        name = "laptop (+embedded, -hdmi) + dock (-dp2, +dp1, -hdmi)";
#        output = [
#          {
#            enable = true;
#            search = "${laptop_display}";
#            mode = "${laptop_display_mode}";
#            scale = 1.0;
#            transform = "normal";
#            adaptive_sync = false;
#          }
#          {
#            enable = true;
#            search = "${dock_middle}";
#            scale = 1.0;
#            transform = "normal";
#            adaptive_sync = false;
#          }
#        ];
#        exec = [
#          "displayhelper_hyprland   \"${laptop_display}\" \"${dock_middle}\""
#          "displayhelper_hyprlock   \"${laptop_display}\""
#          "displayhelper_hyprpaper  \"${laptop_display}\" \"${dock_middle}\""
#          "displayhelper_waybar     \"${laptop_display}\" \"${dock_middle}\""
#        ];
#      }
#      {
#        name = "laptop (+embedded, +hdmi) + dock (-dp2, +dp1, -hdmi)";
#        output = [
#          {
#            enable = true;
#            search = "${laptop_display}";
#            mode = "${laptop_display_mode}";
#            position = "0,0";
#            scale = 1.0;
#            transform = "normal";
#            adaptive_sync = false;
#          }
#          {
#            enable = true;
#            search = "HDMI-A-1";
#            scale = 1.0;
#            transform = "normal";
#            adaptive_sync = false;
#          }
#          {
#            enable = true;
#            search = "${dock_middle}";
#            mode = "${dock_middle_mode}";
#            position = "${dock_middle_position}";
#            scale = 1.0;
#            transform = "normal";
#            adaptive_sync = false;
#          }
#        ];
#        exec = [
#          "displayhelper_hyprland   \"${laptop_display}\" \"HDMI-A-1\" \"${dock_middle}\""
#          "displayhelper_hyprlock   \"${laptop_display}\""
#          "displayhelper_hyprpaper  \"${laptop_display}\" \"${dock_middle}\""
#          "displayhelper_waybar     \"${laptop_display}\" \"HDMI-A-1\" \"${dock_middle}\""
#        ];
#      }
#      {
#        name = "laptop (+embedded, +hdmi) + dock (+dp2, -dp1, -hdmi)";
#        output = [
#          {
#            enable = true;
#            search = "${laptop_display}";
#            mode = "${laptop_display_mode}";
#            scale = 1.0;
#            transform = "normal";
#            adaptive_sync = false;
#          }
#          {
#            enable = true;
#            search = "HDMI-A-1";
#            scale = 1.0;
#            transform = "normal";
#            adaptive_sync = false;
#          }
#          {
#            enable = true;
#            search = "${dock_left}";
#            mode = "${dock_left_mode}";
#            position = "${dock_left_position}";
#            scale = 1.0;
#            transform = "normal";
#            adaptive_sync = false;
#          }
#        ];
#        exec = [
#          "displayhelper_hyprland   \"${laptop_display}\" \"HDMI-A-1\" \"${dock_left}\""
#          "displayhelper_hyprlock   \"${laptop_display}\""
#          "displayhelper_hyprpaper  \"${laptop_display}\" \"HDMI-A-1\" \"${dock_left}\""
#          "displayhelper_waybar     \"${laptop_display}\" \"HDMI-A-1\" \"${dock_left}\""
#        ];
#      }
#      {
#        name = "laptop (+embedded, +hdmi) + dock (+dp2, +dp1, +hdmi)";
#        output = [
#          {
#            enable = true;
#            search = "${laptop_display}";
#            mode = "${laptop_display_mode}";
#            scale = 1.0;
#            transform = "normal";
#            adaptive_sync = false;
#          }
#          {
#            enable = true;
#            search = "HDMI-A-1";
#            scale = 1.0;
#            transform = "normal";
#            adaptive_sync = false;
#          }
#          {
#            enable = true;
#            search = "${dock_left}";
#            mode = "${dock_left_mode}";
#            position = "${dock_left_position}";
#            scale = 1.0;
#            transform = "normal";
#            adaptive_sync = false;
#          }
#          {
#            enable = true;
#            search = "${dock_middle}";
#            mode = "${dock_middle_mode}";
#            position = "${dock_middle_position}";
#            scale = 1.0;
#            transform = "normal";
#            adaptive_sync = false;
#          }
#          {
#            enable = true;
#            search = "${dock_right}";
#            mode = "${dock_right_mode}";
#            position = "${dock_right_position}";
#            scale = 1.0;
#            transform = "normal";
#            adaptive_sync = false;
#          }
#        ];
#        exec = [
#          "displayhelper_hyprland   \"${laptop_display}\" \"HDMI-A-1\" \"${dock_middle}\" \"${dock_right}\" \"${dock_left}\""
#          "displayhelper_hyprlock   \"${laptop_display}\""
#          "displayhelper_hyprpaper  \"${laptop_display}\" \"HDMI-A-1\" \"${dock_middle}\" \"${dock_right}\" \"${dock_left}\""
#          "displayhelper_waybar     \"${laptop_display}\" \"HDMI-A-1\" \"${dock_middle}\" \"${dock_right}\" \"${dock_left}\""
#        ];
#      }
#
#        #   .-------.       .-------.       .-------.
#        #   |  LEFT |       |MIDDLE |       | RIGHT |
#        #   |       |       |       |       |       |
#        #   |       |       |       |       |       |
#        #   '-------'       '-------'       '-------'
#
#      {
#        name = "laptop (-embedded, -hdmi) + dock (+dp2, +dp1, +hdmi)";
#        output = [
#          {
#            enable = false;
#            search = "${laptop_display}";
#          }
#          {
#            enable = true;
#            search = "${dock_left}";
#            mode = "${dock_left_mode}";
#            position = "${dock_left_position}";
#            scale = 1.0;
#            transform = "normal";
#            adaptive_sync = false;
#          }
#          {
#            enable = true;
#            search = "${dock_middle}";
#            mode = "${dock_middle_mode}";
#            position = "${dock_middle_position}";
#            scale = 1.0;
#            transform = "normal";
#            adaptive_sync = false;
#          }
#          {
#            enable = true;
#            search = "${dock_right}";
#            mode = "${dock_right_mode}";
#            position = "${dock_right_position}";
#            scale = 1.0;
#            transform = "normal";
#            adaptive_sync = false;
#          }
#        ];
#        exec = [
#          "displayhelper_hyprland   \"${dock_middle}\" \"${dock_right}\" \"${dock_left}\""
#          "displayhelper_hyprlock   \"${dock_middle}\""
#          "displayhelper_hyprpaper  \"${dock_middle}\" \"${dock_right}\" \"${dock_left}\""
#          "displayhelper_waybar     \"${dock_middle}\" \"${dock_right}\" \"${dock_left}\""
#        ];
#      }
#
#      {
#        name = "laptop (+embedded, -hdmi) + dock (+dp2, +dp1, +hdmi)";
#        output = [
#          {
#            enable = true;
#            search = "${laptop_display}";
#            mode = "${laptop_display_mode}";
#            scale = 1.0;
#            transform = "normal";
#            adaptive_sync = false;
#          }
#          {
#            enable = true;
#            search = "${dock_left}";
#            mode = "${dock_left_mode}";
#            position = "${dock_left_position}";
#            scale = 1.0;
#            transform = "normal";
#            adaptive_sync = false;
#          }
#          {
#            enable = true;
#            search = "${dock_middle}";
#            mode = "${dock_middle_mode}";
#            position = "${dock_middle_position}";
#            scale = 1.0;
#            transform = "normal";
#            adaptive_sync = false;
#          }
#          {
#            enable = true;
#            search = "${dock_right}";
#            mode = "${dock_right_mode}";
#            position = "${dock_right_position}";
#            scale = 1.0;
#            transform = "normal";
#            adaptive_sync = false;
#          }
#        ];
#        exec = [
#          "displayhelper_hyprland   \"${laptop_display}\" \"${dock_middle}\" \"${dock_right}\" \"${dock_left}\""
#          "displayhelper_hyprlock   \"${laptop_display}\""
#          "displayhelper_hyprpaper  \"${laptop_display}\" \"${dock_middle}\" \"${dock_right}\" \"${dock_left}\""
#          "displayhelper_waybar     \"${laptop_display}\" \"${dock_middle}\" \"${dock_right}\" \"${dock_left}\""
#        ];
#      }
    ];
  };
}
