{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.opencode;
in
  with lib;
{
  options = {
    host.home.applications.opencode = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Generative Coding Agent";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        opencode
      ];
    };
  };
}
