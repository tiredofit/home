{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.jq;
in
  with lib;
{
  options = {
    host.home.applications.jq = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "JSON parser";
      };
    };
  };

  config = mkIf cfg.enable {
    programs = {
      jq = {
        enable = true;
      };
    };
  };
}
