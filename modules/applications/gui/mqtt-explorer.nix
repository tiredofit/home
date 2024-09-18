{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.mqtt-explorer;
in
  with lib;
{
  options = {
    host.home.applications.mqtt-explorer = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Message Queuing Browser";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          pkg-mqtt-explorer
        ];
    };
  };
}
