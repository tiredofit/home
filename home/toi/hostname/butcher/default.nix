{ config, lib, pkgs, ...}:
{
  host = {
    home = {
      applications = {
        mp3gain.enable = true;
      };
      service = {
        vscode-server.enable = true;
      };
    };
  };
}
