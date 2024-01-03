{config, lib, pkgs, ...}:
let
  cfg = config.host.home.feature.mime.defaults;
in
  with lib;
{
  options = {
    host.home.feature.mime.defaults = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Enable MIME defaults";
      };
    };
  };

  config = mkIf cfg.enable {
    xdg.mime.enable = true ;
  };
}
