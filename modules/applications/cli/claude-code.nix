{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.claude-code;
in
  with lib;
{
  options = {
    host.home.applications.claude-code = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Generative Coding Agent";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          claude-code
        ];
    };
  };
}
