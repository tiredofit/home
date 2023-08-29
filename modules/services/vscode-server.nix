{config, lib, pkgs, ...}:

let
  cfg = config.host.home.services.vscode-server;
in
  with lib;
{
  options = {
    host.home.services.vscode-server = {
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
