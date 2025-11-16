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
        #networkmanager = {
        #  enable = true;
        #  systemtray.enable = false;
        #};
        rofi.enable = true;
        ssh = {
          enable = true;
        };
        virt-manager.enable = true;
      };
      feature = {
        gui = {
          enable = true;
          displayServer = "wayland";
          windowManager = "hyprland";
        };
      };
      user = {
      };
    };
  };
}
