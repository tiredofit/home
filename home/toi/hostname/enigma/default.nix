{ config, lib, pkgs, ...}:
{
  host = {
    home = {
      applications = {
        mp3gain.enable = true;
        opencode.enable = true;
        zellij.enable = true;
      };
      service = {
        vscode-server.enable = false;
      };
    };
  };
}
