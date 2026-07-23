{ config, lib, pkgs, specialArgs, ...}:
let
  inherit (specialArgs) role;
in
  with lib;
{

  host = {
    home = {
      applications = {
        lazygit.enable = true;
        ssh = {
          enable = true;
        };
        virt-manager.enable = true;
        visual-studio-code.enable = true;
      };
      feature = {
        fonts.enable = true;
        gui = {
          enable = true;
          displayServer = "wayland";
          windowManager = [ "hyprland" ];
          shell = [ "dms" ];
        };
      };
      service = {
        vscode-server.enable = true;
      };
    };
  };
}