{ config, lib, pkgs, specialArgs, ...}:
let
  inherit (specialArgs) role;
in
  with lib;
{
  host = {
    home = {
      applications = {
        kitty.enable = true;
        lazygit.enable = true;
        satty.enable = false;
        shikane.enable = false;
        rofi.enable = true;
        swayosd.enable = false;
        rofi.enable = true;
        grim.enable = false;
        nwg-displays.enable = false;
        slurp.enable = false;
        wayprompt.enable = false;
        waybar = {
          enable = true;
          service.enable = true;
        };
        ssh = {
          enable = true;
        };
        virt-manager.enable = true;
      };
      feature = {
        gui = {
          enable = true;
          displayServer = "wayland";
          windowManager = "sway";
        };
      };
      service = {
        vscode-server.enable = false;
      };
      user = {
      };
    };
  };
}

