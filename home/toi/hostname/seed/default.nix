{ config, lib, pkgs, ...}:
{
  host = {
    home = {
      applications = {
      };
      service = {
        vscode-server.enable = true;
      };
    };
  };
}
