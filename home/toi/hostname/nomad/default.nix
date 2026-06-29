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
        act.enable = false;
        android-studio.enable = true;
        bitwarden-cli.enable = true;
        calibre.enable = false;
        chromium.enable = true;
        claude-code = {
          enable = false;
          mcp.enable = true;
        };
        cryfs.enable = true;
        direnv.enable = true;
        feishin.enable = true;
        ferdium.service.enable = true;
        file-roller.enable = true;
        flameshot.enable = true;
        github-client.enable = true;
        ghostty.enable = true;
        gnome-software.enable = true;
        hadolint.enable = true;
        hyprcursor.enable = true;
        lazydocker.enable = true;
        lazygit.enable = true;
        mcp-servers = {
          enable = true;
          secretsFile = ../../user/dave/secrets/mcp/mcp.yaml;
          servers = {
            context7.enable = true;
            everything.enable = true;
            fetch.enable = true;
            filesystem = {
              enable = true;
              args = [ "/home/dave/src/" ];
            };
            git = {
              enable = true;
              args = [ "--repository" "/home/dave/src/nfra/" ];
            };
            github = {
              enable = true;
              secretEnv = { GITHUB_PERSONAL_ACCESS_TOKEN = "mcp/github_token"; };
            };
            homeassistant = {
              enable = false;
              secretEnv = {
                HOMEASSISTANT_URL = "mcp/homeassistant_url";
                HOMEASSISTANT_TOKEN = "mcp/homeassistant_token";
              };
            };
            mcp-nixos.enable = true;
            memory.enable = true;
            playwright.enable = true;
          };
        };
        meld.enable = true;
        mqtt-explorer.enable = false;
        neovim.enable = true;
        nix-development_tools.enable = true;
        networkmanager = {
          enable = true;
          systemtray.enable = mkForce false;
        };
        obsidian.enable = true;
        opencode = {
          enable = true;
          mcp.enable = true;
        };
        playwright.enable = true;
        python.enable = true;
        pwvucontrol.enable = true;
        satty.enable = false;
        shellcheck.enable = true;
        shikane.enable = false;
        shfmt.enable = true;
        ssh.enable = true;
        steam-run.enable = true;
        szyszka.enable = false;
        thunderbird.enable = false;
        virt-manager.enable = true;
        visual-studio-code = {
          enable = true;
          defaultApplication.enable = true;
          mcp.enable = true;
        };
        wps-office.enable = mkForce true;
        yq.enable = true;
        yt-dlp.enable = true;
        zellij.enable = false;
        zoom.enable = true;
        zsh.enable = true;
      };
      feature = {
        gui = {
          enable = true;
          displayServer = "wayland";
          windowManager = [ "niri" "hyprland" ];
          shell = [ "dms" ];
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
              toi.enable = true;
              ghtoi.enable = true;
            };
          };
        };
      };
    };
  };


#  host.home.applications.shikane.settings = {
#    profile = [
#      {
#        name = "laptop";
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
#        exec = []
#          ++ optional (builtins.elem "hyprland" config.host.home.feature.gui.windowManager) "displayhelper_hyprland   \"${laptop_display}\""
#          ++ optional config.host.home.applications.hyprpaper.enable "displayhelper_hyprpaper  \"${laptop_display}\""
#          ++ optional config.host.home.applications.hyprlock.enable "displayhelper_hyprlock   \"${laptop_display}\""
#          ++ optional config.host.home.applications.waybar.enable "displayhelper_waybar     \"${laptop_display}\""
#          ++ [ "sound-tool               \"reset\"" ];
#      }
#      {
#        name = "dock";
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
#        exec = []
#          ++ optional (builtins.elem "hyprland" config.host.home.feature.gui.windowManager) "displayhelper_hyprland   \"${dock_middle}\" \"${dock_right}\" \"${dock_left}\""
#          ++ optional config.host.home.applications.hyprlock.enable "displayhelper_hyprlock   \"${dock_middle}\""
#          ++ optional config.host.home.applications.hyprpaper.enable "displayhelper_hyprpaper  \"${dock_middle}\" \"${dock_right}\" \"${dock_left}\""
#          ++ optional config.host.home.applications.waybar.enable "displayhelper_waybar     \"${dock_middle}\" \"${dock_right}\" \"${dock_left}\""
#          ++ [ "sound-tool               \"disable\"         \"AIR HUB,Jabra SPEAK\"" ];
#      }
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
#    ];
#  };
}
