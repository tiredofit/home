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
        mcp-servers = {
          enable = true;
          secretsFile = ./tttttt/secrets/mcp/mcp.yaml;
          servers = {
            mcp-nixos.enable = false;
            opnsense.enable = true;
          };
        };
        opencode = {
          enable = true;
          mcp.enable = true;
        };
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
          shell.enable = [ "dms" ];
        };
        theming.enable = true;
      };
      service = {
        vscode-server.enable = true;
      };
    };
  };
}