{ config, lib, pkgs, ...}:
{
  host = {
    home = {
      applications = {
        direnv.enable = true;
        neovim.enable = true;
        opencode = {
          enable = true;
          mcp.enable = true;
        };
        python.enable = true;
        zellij.enable = true;
      };
      service = {
        vscode-server.enable = false;
      };
    };
  };
}
