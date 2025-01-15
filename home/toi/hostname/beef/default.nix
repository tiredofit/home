{ config, lib, pkgs, specialArgs, ...}:
let
  inherit (specialArgs) displays display_center display_left display_right role;
  display_left="Dell Inc. DELL S3220DGF 9H4VF43";
  display_middle="Dell Inc. DELL S3220DGF 9H4VF43";
  display_right="Dell Inc. DELL S3220DGF GSDTF43";
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
        kanshi.enable = true;
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

  wayland.windowManager.hyprland = {
    xwayland.enable = true;
  };

  services.kanshi = {
    settings = [
      {
        profile.name = "'beef (+left, +center, +right)'";
        profile.outputs = [
          {
            criteria = "${display_middle}";
            mode = "2560x1440@164.05600";
            position = "2560,0";
          }
          {
            criteria = "${display_right}";
            mode = "2560x1440@119.99800";
            position = "5120,0";
          }
          {
            criteria = "${display_left}";
            mode = "2560x1440@164.05600";
            position = "0,0";
          }
        ];
        profile.exec = [
          "displayhelper_hyprland \"${display_middle}\" \"${display_right}\" \"${display_left}\""
          "displayhelper_waybar   \"${display_middle}\" \"${display_right}\" \"${display_left}\""
        ];
      }

      {
        profile.name = "'beef (-left, +center, -right)'";
        profile.outputs = [
          {
            criteria = "${display_middle}";
            mode = "2560x1440@164.05600";
            position = "0,0";
          }
          {
            criteria = "${display_right}";
            status = "disable";
          }
          {
            criteria = "${display_left}";
            status = "disable";
          }
        ];
        profile.exec = [
          "displayhelper_hyprland \"${display_middle}\""
          "displayhelper_waybar   \"${display_middle}\""
        ];
      }

      {
        profile.name = "'beef (+left, -center, -right)'";
        profile.outputs = [
          {
            criteria = "${display_middle}";
            status = "disable";
          }
          {
            criteria = "${display_right}";
            status = "disable";
          }
          {
            criteria = "${display_left}";
            mode = "2560x1440@164.05600";
            position = "0,0";
          }
        ];
        profile.exec = [
          "displayhelper_hyprland \"${display_left}\""
          "displayhelper_waybar   \"${display_left}\""
        ];
      }

      {
        profile.name = "'beef (-left, -center, +right)'";
        profile.outputs = [
          {
            criteria = "${display_middle}";
            status = "disable";
          }
          {
            criteria = "${display_right}";
            mode = "2560x1440@164.05600";
            position = "0,0";
          }
          {
            criteria = "${display_left}";
            status = "disable";
          }
        ];
        profile.exec = [
          "displayhelper_hyprland \"${display_right}\""
          "displayhelper_waybar   \"${display_right}\""
        ];
      }

      {
        profile.name = "'beef (+left, +center, -right)'";
        profile.outputs = [
          {
            criteria = "${display_middle}";
            mode = "2560x1440@164.05600";
            position = "2560,0";
          }
          {
            criteria = "${display_right}";
            status = "disable";
          }
          {
            criteria = "${display_left}";
            mode = "2560x1440@164.05600";
            position = "0,0";
          }
        ];
        profile.exec = [
          "displayhelper_hyprland \"${display_middle}\" \"${display_left}\""
          "displayhelper_waybar   \"${display_middle}\" \"${display_left}\""
        ];
      }

      {
        profile.name = "'beef (-left, +center, +right)'";
        profile.outputs = [
          {
            criteria = "${display_middle}";
            mode = "2560x1440@164.05600";
            position = "0,0";
          }
          {
            criteria = "${display_right}";
            mode = "2560x1440@119.99800";
            position = "2560,0";
          }
          {
            criteria = "${display_left}";
            status = "disable";
          }
        ];
        profile.exec = [
          "displayhelper_hyprland \"${display_middle}\" \"${display_right}\""
          "displayhelper_waybar   \"${display_middle}\" \"${display_right}\""
        ];
      }

      {
        profile.name = "'beef (+left, -center, +right)'";
        profile.outputs = [
          {
            criteria = "${display_middle}";
            status = "disable";
          }
          {
            criteria = "${display_right}";
            mode = "2560x1440@119.99800";
            position = "2560,0";
          }
          {
            criteria = "${display_left}";
            mode = "2560x1440@164.05600";
            position = "0,0";
          }
        ];
        profile.exec = [
          "displayhelper_hyprland \"${display_left}\" \"${display_right}\""
          "displayhelper_waybar   \"${display_left}\" \"${display_right}\""
        ];
      }
    ];
  };
}
