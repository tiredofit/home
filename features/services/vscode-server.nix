{ config, pkgs, lib, vscode-server, ...}:
{

  services = {
    vscode-server = {
      enable = true;
    };
  };

}
