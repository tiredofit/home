{ config, lib, pkgs, specialArgs, ...}:
let
  inherit (specialArgs) role;
  display_left="d/Dell Inc. DELL S3220DGF 63BQF43";
  display_left_mode="2560x1440@119.998";
  display_left_position="0,0";
  display_middle="d/Dell Inc. DELL S3220DGF 9H4VF43";
  display_middle_mode="2560x1440@120.00";
  display_middle_position="2560,0";
  display_right="d/Dell Inc. DELL S3220DGF GSDTF43";
  display_right_mode="2560x1440@119.99800";
  display_right_position="5120,0";
in
with lib;
{
  host = {
    home = {
      applications = {
        act.enable = true;
        avidemux.enable = true;
        calibre.enable = true;
        cryfs.enable = true;
        czkawka.enable = true;
        github-client.enable = true;
        gnome-software.enable = true;
        hadolint.enable = true;
        hugo.enable = false;
        lazydocker.enable = true;
        lazygit.enable = true;
        mp3gain.enable = true;
        nix-development_tools.enable = true;
        nmap.enable = true;
        obsidian.enable = true;
        peazip.enable = true;
        python.enable = true;
        pwvucontrol.enable = true;
        sonusmix.enable = true;
        shellcheck.enable = true;
        shfmt.enable = true;
        sonixd.enable = true;
        smartgit.enable = true;
        ssh = {
          enable = true;
          ignore = {
            "192.168.1.0/24" = true;
            "192.168.4.0/24" = true;
          };
        };
        szyszka.enable = true;
        thunderbird.enable = true;
        virt-manager.enable = true;
        visual-studio-code = {
          enable = true;
          defaultApplication.enable = true;
        };
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
      service.decrypt_cryfs_workspace.enable = true;
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
              sr.enable = true;
              toi.enable = true;
            };
          };
        };
      };
    };
  };

  host.home.applications.shikane.settings = {
    profile = [
        #   .-------.       .-------.       .-------.
        #   |  LEFT |       |MIDDLE |       | RIGHT |
        #   |       |       |       |       |       |
        #   |       |       |       |       |       |
        #   '-------'       '-------'       '-------'

      {
        name = "beef (+dp2, +dp1, +hdmi)'";
        output = [

          {
            enable = true;
            search = "${display_left}";
            mode = "${display_left_mode}";
            position = "${display_left_position}";
            scale = 1.0;
            transform = "normal";
            adaptive_sync = false;
          }
          {
            enable = true;
            search = "${display_middle}";
            mode = "${display_middle_mode}";
            position = "${display_middle_position}";
            scale = 1.0;
            transform = "normal";
            adaptive_sync = false;
          }
          {
            enable = true;
            search = "${display_right}";
            mode = "${display_right_mode}";
            position = "${display_right_position}";
            scale = 1.0;
            transform = "normal";
            adaptive_sync = false;
          }
        ];
        exec = [
          "displayhelper_hyprland \"${display_middle}\" \"${display_right}\" \"${display_left}\""
          "displayhelper_hyprlock \"${display_middle}\""
          "displayhelper_hyprpaper \"${display_middle}\" \"${display_right}\" \"${display_left}\""
          "displayhelper_waybar   \"${display_middle}\" \"${display_right}\" \"${display_left}\""
        ];
      }

        #   .-------.       .-------.       .-------.
        #   |  N/A  |       |MIDDLE |       | N/A   |
        #   |       |       |       |       |       |
        #   |       |       |       |       |       |
        #   '-------'       '-------'       '-------'

      {
        name = "beef (-dp2, +dp1, -hdmi)'";
        output = [
          {
            enable = false;
            search = "${display_left}";
            mode = "${display_left_mode}";
            position = "${display_left_position}";
            scale = 1.0;
            transform = "normal";
            adaptive_sync = false;
          }
          {
            enable = true;
            search = "${display_middle}";
            mode = "${display_middle_mode}";
            position = "${display_middle_position}";
            scale = 1.0;
            transform = "normal";
            adaptive_sync = false;
          }
          {
            enable = false;
            search = "${display_right}";
            mode = "${display_right_mode}";
            position = "${display_right_position}";
            scale = 1.0;
            transform = "normal";
            adaptive_sync = false;
          }
        ];
        exec = [
          "displayhelper_hyprland   \"${display_middle}\""
          "displayhelper_hyprlock   \"${display_middle}\""
          "displayhelper_hyprpaper  \"${display_middle}\""
          "displayhelper_waybar     \"${display_middle}\""
        ];
      }
      {
        name = "beef (+left, -center, -right)";
        output = [
          {
            enable = false;
            search = "${display_middle}";
          }
          {
            enable = false;
            search = "${display_right}";
          }
          {
            enable = true;
            search = "${display_left}";
            mode = "${display_left_mode}";
            position = "${display_left_position}";
            scale = 1.0;
            transform = "normal";
            adaptive_sync = false;
          }
        ];
        exec = [
          "displayhelper_hyprland   \"${display_left}\""
          "displayhelper_hyprlock   \"${display_left}\""
          "displayhelper_hyprpaper  \"${display_left}\""
          "displayhelper_waybar     \"${display_left}\""
        ];
      }

      {
        name = "beef (-left, -center, +right)";
        output = [
          {
            enable = false;
            search = "${display_middle}";
          }
          {
            enable = true;
            search = "${display_right}";
            mode = "${display_right_mode}";
            position = "${display_right_position}";
            scale = 1.0;
            transform = "normal";
            adaptive_sync = false;
          }
          {
            enable = false;
            search = "${display_left}";
          }
        ];
        exec = [
          "displayhelper_hyprland   \"${display_right}\""
          "displayhelper_hyprlock   \"${display_right}\""
          "displayhelper_hyprpaper  \"${display_right}\""
          "displayhelper_waybar     \"${display_right}\""
        ];
      }

      {
        name = "beef (+left, +center, -right)";
        output = [
          {
            enable = true;
            search = "${display_middle}";
            mode = "${display_middle_mode}";
            position = "${display_middle_position}";
            scale = 1.0;
            transform = "normal";
            adaptive_sync = false;
          }
          {
            enable = false;
            search = "${display_right}";
          }
          {
            enable = true;
            search = "${display_left}";
            mode = "${display_left_mode}";
            position = "${display_left_position}";
            scale = 1.0;
            transform = "normal";
            adaptive_sync = false;
          }
        ];
        exec = [
          "displayhelper_hyprland   \"${display_middle}\" \"${display_left}\""
          "displayhelper_hyprlock   \"${display_middle}\""
          "displayhelper_hyprpaper  \"${display_middle}\" \"${display_left}\""
          "displayhelper_waybar     \"${display_middle}\" \"${display_left}\""
        ];
      }

      {
        name = "beef (-left, +center, +right)";
        output = [
          {
            enable = true;
            search = "${display_middle}";
            mode = "${display_middle_mode}";
            position = "${display_left_position}";
            scale = 1.0;
            transform = "normal";
            adaptive_sync = false;
          }
          {
            enable = true;
            search = "${display_right}";
            mode = "${display_right_mode}";
            position = "${display_middle_position}";
            scale = 1.0;
            transform = "normal";
            adaptive_sync = false;
          }
          {
            enable = false;
            search = "${display_left}";
          }
        ];
        exec = [
          "displayhelper_hyprland   \"${display_middle}\" \"${display_right}\""
          "displayhelper_hyprlock   \"${display_middle}\""
          "displayhelper_hyprpaper  \"${display_middle}\" \"${display_right}\""
          "displayhelper_waybar     \"${display_middle}\" \"${display_right}\""
        ];

      }


      {
        name = "beef (+left, -center, +right)";
        output = [
          {
            enable = false;
            search = "${display_middle}";
          }
          {
            enable = true;
            search = "${display_right}";
            mode = "${display_right_mode}";
            position = "${display_right_position}";
            scale = 1.0;
            transform = "normal";
            adaptive_sync = false;
          }
          {
            enable = true;
            search = "${display_left}";
            mode = "${display_left_mode}";
            position = "${display_left_position}";
            scale = 1.0;
            transform = "normal";
            adaptive_sync = false;
          }
        ];
        exec = [
          "displayhelper_hyprland   \"${display_left}\" \"${display_right}\""
          "displayhelper_hyprlock   \"${display_left}\""
          "displayhelper_hyprpaper  \"${display_left}\" \"${display_right}\""
          "displayhelper_waybar     \"${display_left}\" \"${display_right}\""
        ];
      }
    ];
  };
}
