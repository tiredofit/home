{ config, lib, pkgs, specialArgs, ...}:
let
  inherit (specialArgs) displays display_center role;
in
with lib;
{
  host = {
    home = {
      applications = {
        act.enable = mkDefault true;
        avidemux.enable = true;
        calibre.enable = true;
        czkawka.enable = mkDefault true;
        encfs.enable = true;
        github-client.enable = true;
        gnome-encfs-manager.enable = true;
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
          systemtray.enable = true;
        };
        nmap.enable = mkDefault true;
        obsidian.enable = true;
        peazip.enable = true;
        python.enable = true;
        pwvucontrol.enable = true;
        sonusmix.enable = true;
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
        thunderbird.enable = mkDefault true;
        virt-manager.enable = mkDefault true;
        visual-studio-code = {
          enable = mkDefault true;
          defaultApplication.enable = mkDefault true;
        };
        yq.enable = true;
        yt-dlp.enable = mkDefault true;
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
      service.decrypt_encfs_workspace.enable = true;
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
          criteria = "eDP-1";
          status = "enable";
          scale = 1.0;
        }
      ];
      profile.exec = [
        "displayhelper_hyprland \"eDP-1\""
        "displayhelper_waybar   \"eDP-1\""
      ];
    }

    {
      profile.name = "'laptop (+embedded, +hdmi)'";
      profile.outputs = [
        {
          criteria = "eDP-1";
          status = "enable";
          scale = 1.0;
        }
        {
          criteria = "HDMI-A-1";
          status = "enable";
        }
      ];
      profile.exec = [
        "displayhelper_hyprland \"eDP-1\" \"HDMI-A-1\""
        "displayhelper_waybar   \"eDP-1\" \"HDMI-A-1\""
      ];
    }

    {
      profile.name = "'laptop (-embedded, +hdmi)'";
      profile.outputs = [
        {
          criteria = "eDP-1";
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
      profile.name = "'laptop (+embedded, -hdmi) + dock (+hdmi, -dp1, -dp2)'";
      profile.outputs = [
        {
          criteria = "eDP-1";
          status = "enable";
          scale = 1.0;
        }
        {
          criteria = "DP-7";
          status = "enable";
        }
      ];
      profile.exec = [
        "displayhelper_hyprland \"eDP-1\" \"DP-7\""
        "displayhelper_waybar   \"eDP-1\" \"DP-7\""
      ];
    }

    {
      profile.name = "'laptop (+embedded, +hdmi) + dock (+hdmi, -dp1, -dp2)'";
      profile.outputs = [
        {
          criteria = "eDP-1";
          status = "enable";
          scale = 1.0;
        }
        {
          criteria = "HDMI-A-1";
          status = "enable";
        }
        {
          criteria = "DP-7";
          status = "enable";
        }
      ];
      profile.exec = [
        "displayhelper_hyprland \"eDP-1\" \"HDMI-A-1\" \"DP-7\""
        "displayhelper_waybar   \"eDP-1\" \"HDMI-A-1\" \"DP-7\""
      ];
    }

    {
      profile.name = "'laptop (-embedded, -hdmi) + dock (+hdmi, -dp1, -dp2)'";
      profile.outputs = [
        {
          criteria = "eDP-1";
           status = "disable";
        }
        {
          criteria = "DP-7";
          status = "enable";
        }
      ];
      profile.exec = [
        "displayhelper_hyprland \"DP-7\""
        "displayhelper_waybar   \"DP-7\""
      ];
    }

    {
      profile.name = "'laptop (-embedded, +hdmi) + dock (+hdmi, -dp1, -dp2)'";
      profile.outputs = [
        {
          criteria = "eDP-1";
           status = "disable";
        }
        {
          criteria = "HDMI-A-1";
          status = "enable";
        }
        {
          criteria = "DP-7";
          status = "enable";
        }
      ];
      profile.exec = [
        "displayhelper_hyprland \"HDMI-A-1\" \"DP-7\""
        "displayhelper_waybar   \"HDMI-A-1\" \"DP-7\""
      ];
    }

    {
      profile.name = "'laptop (+embedded, -hdmi) + dock (-hdmi, +dp1, -dp2)'";
      profile.outputs = [
        {
          criteria = "eDP-1";
          status = "enable";
          scale = 1.0;
        }
        {
          criteria = "DP-1";
          status = "enable";
        }
      ];
      profile.exec = [
        "displayhelper_hyprland \"eDP-1\" \"DP-1\""
        "displayhelper_waybar   \"eDP-1\" \"DP-1\""
      ];
    }

    {
      profile.name = "'laptop (+embedded, +hdmi) + dock (-hdmi, +dp1, -dp2)'";
      profile.outputs = [
        {
          criteria = "eDP-1";
          status = "enable";
          scale = 1.0;
        }
        {
          criteria = "HDMI-A-1";
          status = "enable";
        }
        {
          criteria = "DP-1";
          status = "enable";
        }
      ];
      profile.exec = [
        "displayhelper_hyprland \"eDP-1\" \"HDMI-A-1\" \"DP-1\""
        "displayhelper_waybar   \"eDP-1\" \"HDMI-A-1\" \"DP-1\""
      ];
    }

    {
      profile.name = "'laptop (+embedded, +hdmi) + dock (-hdmi, -dp1, +dp2)'";
      profile.outputs = [
        {
          criteria = "eDP-1";
          status = "enable";
          scale = 1.0;
        }
        {
          criteria = "HDMI-A-1";
          status = "enable";
        }
        {
          criteria = "DP-2";
          status = "enable";
        }
      ];
      profile.exec = [
        "displayhelper_hyprland \"eDP-1\" \"HDMI-A-1\" \"DP-2\""
        "displayhelper_waybar   \"eDP-1\" \"HDMI-A-1\" \"DP-2\""
      ];
    }

    {
      profile.name = "'laptop (+embedded, +hdmi) + dock (+hdmi, -dp1, -dp2)'";
      profile.outputs = [
        {
          criteria = "eDP-1";
          status = "enable";
          scale = 1.0;
        }
        {
          criteria = "HDMI-A-1";
          status = "enable";
        }
        {
          criteria = "DP-7";
          status = "enable";
        }
      ];
      profile.exec = [
        "displayhelper_hyprland \"eDP-1\" \"HDMI-A-1\" \"DP-7\""
        "displayhelper_waybar   \"eDP-1\" \"HDMI-A-1\" \"DP-7\""
      ];
    }

    {
      profile.name = "'laptop (+embedded, +hdmi) + dock (+hdmi, +dp1, -dp2)'";
      profile.outputs = [
        {
          criteria = "eDP-1";
          status = "enable";
          scale = 1.0;
        }
        {
          criteria = "HDMI-A-1";
          status = "enable";
        }
        {
          criteria = "DP-7";
          status = "enable";
        }
        {
          criteria = "DP-1";
          status = "enable";
        }
      ];
      profile.exec = [
        "displayhelper_hyprland \"eDP-1\" \"HDMI-A-1\" \"DP-7\" \"DP-1\""
        "displayhelper_waybar   \"eDP-1\" \"HDMI-A-1\" \"DP-7\" \"DP-1\""
      ];
    }

    {
      profile.name = "'laptop (+embedded, +hdmi) + dock (+hdmi, -dp1, +dp2)'";
      profile.outputs = [
        {
          criteria = "eDP-1";
          status = "enable";
          scale = 1.0;
        }
        {
          criteria = "HDMI-A-1";
          status = "enable";
        }
        {
          criteria = "DP-2";
          status = "enable";
        }
      ];
      profile.exec = [
        "displayhelper_hyprland \"eDP-1\" \"HDMI-A-1\" \"DP-2\""
        "displayhelper_waybar   \"eDP-1\" \"HDMI-A-1\" \"DP-2\""
      ];
    }

    {
      profile.name = "'laptop (+embedded, +hdmi) + dock (+hdmi, +dp1, +dp2)'";
      profile.outputs = [
        {
          criteria = "eDP-1";
          status = "enable";
          scale = 1.0;
        }
        {
          criteria = "HDMI-A-1";
          status = "enable";
        }
        {
          criteria = "DP-7";
          status = "enable";
        }
        {
          criteria = "DP-1";
          status = "enable";
        }
        {
          criteria = "DP-2";
          status = "enable";
        }
      ];
      profile.exec = [
        "displayhelper_hyprland \"eDP-1\" \"HDMI-A-1\" \"DP-7\" \"DP-1\" \"DP-2\""
        "displayhelper_waybar   \"eDP-1\" \"HDMI-A-1\" \"DP-7\" \"DP-1\" \"DP-2\""
      ];
    }
  ];

  wayland.windowManager.hyprland = {
    xwayland.enable = true;
  };
}
