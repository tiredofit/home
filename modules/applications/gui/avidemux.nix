{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.avidemux;
in
  with lib;
{
  options = {
    host.home.applications.avidemux = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Audio / Video Editor";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          avidemux
        ];
    };
  };
}
