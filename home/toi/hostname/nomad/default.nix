{ config, lib, pkgs, specialArgs, ...}:
let
  inherit (specialArgs) displays display_center role;
  dock_left="Dell Inc. DELL S3220DGF 63BQF43";
  dock_left_mode="2560x1440@164.05600";
  dock_left_position="0,0";
  dock_middle="Dell Inc. DELL S3220DGF 9H4VF43";
  dock_middle_mode="2560x1440@164.05600";
  dock_middle_position="2560,0";
  dock_right="Dell Inc. DELL S3220DGF GSDTF43";
  dock_right_mode="2560x1440@119.99800";
  dock_right_position="5120,0";
  laptop_display="California Institute of Technology 0x1413";
  laptop_external="HDMI-A-1";
in
with lib;
{
  host = {
    home = {
      applications = {
        act.enable = mkDefault true;
        avidemux.enable = true;
        calibre.enable = true;
        chromium.enable = true;
        cryfs.enable = true;
        czkawka.enable = true;
        github-client.enable = true;
        gnome-software.enable = true;
        hadolint.enable = true;
        hugo.enable = false;
        lazydocker.enable = true;
        lazygit.enable = true;
        kanshi.enable = true;
        mp3gain.enable = mkDefault true;
        nix-development_tools.enable = true;
        networkmanager = {
          enable = true;
          systemtray.enable = false;
        };
        nmap.enable = mkDefault true;
        obsidian.enable = true;
        peazip.enable = true;
        python.enable = true;
        pwvucontrol.enable = true;
        sonusmix.enable = false;
        shellcheck.enable = true;
        shfmt.enable = true;
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
          enable = mkDefault true;
          defaultApplication.enable = true;
        };
        yq.enable = true;
        yt-dlp.enable = true;
        zoom.enable = false;
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

  services.kanshi.settings = [
    {
      profile.name = "'laptop (+embedded, -hdmi)'";
      profile.outputs = [
        {
          criteria = "${laptop_display}";
          status = "enable";
          scale = 1.0;
        }
      ];
      profile.exec = [
        "displayhelper_hyprland \"${laptop_display}\""
        "displayhelper_waybar   \"${laptop_display}\""
      ];
    }

    {
      profile.name = "'laptop (+embedded, +hdmi)'";
      profile.outputs = [
        {
          criteria = "${laptop_display}";
          status = "enable";
          scale = 1.0;
        }
        {
          criteria = "HDMI-A-1";
          status = "enable";
        }
      ];
      profile.exec = [
        "displayhelper_hyprland \"${laptop_display}\" \"HDMI-A-1\""
        "displayhelper_waybar   \"${laptop_display}\" \"HDMI-A-1\""
      ];
    }

    {
      profile.name = "'laptop (-embedded, +hdmi)'";
      profile.outputs = [
        {
          criteria = "${laptop_display}";
           status = "disable";
        }
        {
          criteria = "HDMI-A-1";
          status = "enable";
        }
      ];
      profile.exec = [
        "displayhelper_hyprland \"HDMI-A-1\""
        "displayhelper_waybar   \"HDMI-A-1\""
      ];
    }

    {
      profile.name = "'laptop (+embedded, -hdmi) + dock (-dp2, -dp1, +hdmi)'";
      profile.outputs = [
        {
          criteria = "${laptop_display}";
          status = "enable";
          scale = 1.0;
        }
        {
          criteria = "${dock_right}";
          status = "enable";
          mode = "${dock_right_mode}";
          position = "${dock_right_position}";
        }
      ];
      profile.exec = [
        "displayhelper_hyprland \"${laptop_display}\" \"${dock_right}\""
        "displayhelper_waybar   \"${laptop_display}\" \"${dock_right}\""
      ];
    }

    {
      profile.name = "'laptop (+embedded, +hdmi) + dock (-dp2, -dp1, +hdmi)'";
      profile.outputs = [
        {
          criteria = "${laptop_display}";
          status = "enable";
          scale = 1.0;
        }
        {
          criteria = "HDMI-A-1";
          status = "enable";
        }
        {
          criteria = "${dock_right}";
          status = "enable";
          mode = "${dock_right_mode}";
          position = "${dock_right_position}";
        }
      ];
      profile.exec = [
        "displayhelper_hyprland \"${laptop_display}\" \"HDMI-A-1\" \"${dock_right}\""
        "displayhelper_waybar   \"${laptop_display}\" \"HDMI-A-1\" \"${dock_right}\""
      ];
    }

    {
      profile.name = "'laptop (-embedded, -hdmi) + dock (-dp2, -dp1, +hdmi )'";
      profile.outputs = [
        {
          criteria = "${laptop_display}";
           status = "disable";
        }
        {
          criteria = "${dock_right}";
          status = "enable";
          mode = "${dock_right_mode}";
          position = "${dock_right_position}";
        }
      ];
      profile.exec = [
        "displayhelper_hyprland \"${dock_right}\""
        "displayhelper_waybar   \"${dock_right}\""
      ];
    }

    {
      profile.name = "'laptop (-embedded, +hdmi) + dock (-dp2, -dp1, +hdmi)'";
      profile.outputs = [
        {
          criteria = "${laptop_display}";
           status = "disable";
        }
        {
          criteria = "HDMI-A-1";
          status = "enable";
        }
        {
          criteria = "${dock_right}";
          status = "enable";
          mode = "${dock_right_mode}";
          position = "${dock_right_position}";
        }
      ];
      profile.exec = [
        "displayhelper_hyprland \"HDMI-A-1\" \"${dock_right}\""
        "displayhelper_waybar   \"HDMI-A-1\" \"${dock_right}\""
      ];
    }

    {
      profile.name = "'laptop (+embedded, -hdmi) + dock (-dp2, +dp1, -hdmi)'";
      profile.outputs = [
        {
          criteria = "${laptop_display}";
          status = "enable";
          scale = 1.0;
        }
        {
          criteria = "${dock_middle}";
          status = "enable";
        }
      ];
      profile.exec = [
        "displayhelper_hyprland \"${laptop_display}\" \"${dock_middle}\""
        "displayhelper_waybar   \"${laptop_display}\" \"${dock_middle}\""
      ];
    }

    {
      profile.name = "'laptop (+embedded, +hdmi) + dock (-dp2, +dp1, -hdmi)'";
      profile.outputs = [
        {
          criteria = "${laptop_display}";
          status = "enable";
          scale = 1.0;
        }
        {
          criteria = "HDMI-A-1";
          status = "enable";
        }
        {
          criteria = "${dock_middle}";
          status = "enable";
        }
      ];
      profile.exec = [
        "displayhelper_hyprland \"${laptop_display}\" \"HDMI-A-1\" \"${dock_middle}\""
        "displayhelper_waybar   \"${laptop_display}\" \"HDMI-A-1\" \"${dock_middle}\""
      ];
    }

    {
      profile.name = "'laptop (+embedded, +hdmi) + dock (+dp2, -dp1, -hdmi)'";
      profile.outputs = [
        {
          criteria = "${laptop_display}";
          status = "enable";
          scale = 1.0;
        }
        {
          criteria = "HDMI-A-1";
          status = "enable";
        }
        {
          criteria = "${dock_left}";
          status = "enable";
          mode = "${dock_left_mode}";
          position = "${dock_left_position}";
        }
      ];
      profile.exec = [
        "displayhelper_hyprland \"${laptop_display}\" \"HDMI-A-1\" \"${dock_left}\""
        "displayhelper_waybar   \"${laptop_display}\" \"HDMI-A-1\" \"${dock_left}\""
      ];
    }

    {
      profile.name = "'laptop (+embedded, +hdmi) + dock (-dp2, -dp1, +hdmi)'";
      profile.outputs = [
        {
          criteria = "${laptop_display}";
          status = "enable";
          scale = 1.0;
        }
        {
          criteria = "HDMI-A-1";
          status = "enable";
        }
        {
          criteria = "${dock_right}";
          status = "enable";
          mode = "${dock_right_mode}";
          position = "${dock_right_position}";
        }
      ];
      profile.exec = [
        "displayhelper_hyprland \"${laptop_display}\" \"HDMI-A-1\" \"${dock_right}\""
        "displayhelper_waybar   \"${laptop_display}\" \"HDMI-A-1\" \"${dock_right}\""
      ];
    }

    {
      profile.name = "'laptop (+embedded, +hdmi) + dock (-dp2, +dp1, +hdmi)'";
      profile.outputs = [
        {
          criteria = "${laptop_display}";
          status = "enable";
          scale = 1.0;
        }
        {
          criteria = "HDMI-A-1";
          status = "enable";
        }
        {
          criteria = "${dock_middle}";
          status = "enable";
          mode = "${dock_middle_mode}";
          position = "${dock_middle_position}";
        }
        {
          criteria = "${dock_right}";
          status = "enable";
          mode = "${dock_right_mode}";
          position = "${dock_right_position}";
        }
      ];
      profile.exec = [
        "displayhelper_hyprland \"${laptop_display}\" \"HDMI-A-1\" \"${dock_right}\" \"${dock_middle}\""
        "displayhelper_waybar   \"${laptop_display}\" \"HDMI-A-1\" \"${dock_right}\" \"${dock_middle}\""
      ];
    }

    {
      profile.name = "'laptop (+embedded, +hdmi) + dock (+dp2, -dp1, +hdmi)'";
      profile.outputs = [
        {
          criteria = "${laptop_display}";
          status = "enable";
          scale = 1.0;
        }
        {
          criteria = "HDMI-A-1";
          status = "enable";
        }
        {
          criteria = "${dock_left}";
          status = "enable";
          mode = "${dock_left_mode}";
          position = "${dock_left_position}";
        }
      ];
      profile.exec = [
        "displayhelper_hyprland \"${laptop_display}\" \"HDMI-A-1\" \"${dock_left}\""
        "displayhelper_waybar   \"${laptop_display}\" \"HDMI-A-1\" \"${dock_left}\""
      ];
    }

    {
      profile.name = "'laptop (+embedded, +hdmi) + dock (+dp2, +dp1, +hdmi)'";
      profile.outputs = [
        {
          criteria = "${laptop_display}";
          status = "enable";
          scale = 1.0;
        }
        {
          criteria = "HDMI-A-1";
          status = "enable";
        }
        {
          criteria = "${dock_left}";
          status = "enable";
          mode = "${dock_left_mode}";
          position = "${dock_left_position}";
        }
        {
          criteria = "${dock_middle}";
          status = "enable";
          mode = "${dock_middle_mode}";
          position = "${dock_middle_position}";
        }
        {
          criteria = "${dock_right}";
          status = "enable";
          mode = "${dock_right_mode}";
          position = "${dock_right_position}";
        }

      ];
      profile.exec = [
        "displayhelper_hyprland \"${laptop_display}\" \"HDMI-A-1\" \"${dock_right}\" \"${dock_middle}\" \"${dock_left}\""
        "displayhelper_waybar   \"${laptop_display}\" \"HDMI-A-1\" \"${dock_right}\" \"${dock_middle}\" \"${dock_left}\""
      ];
    }
  ];
}
