{inputs, config, lib, pkgs, ...}:

let
  cfg = config.host.home.service.vscode-server;
in
  with lib;
{

  imports = [
    inputs.vscode-server.homeModules.default
  ];

  options = {
    host.home.service.vscode-server = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Enable Visual Studio Code Server";
      };
    };
  };

  config = mkIf cfg.enable {
    services = {
      vscode-server = {
        enable = true;
      };
    };
  };
}
