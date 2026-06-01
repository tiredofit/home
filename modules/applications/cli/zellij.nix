{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.zellij;
in
  with lib;
{
  options = {
    host.home.applications.zellij = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Terminal multiplexer";
      };
    };
  };

  config = mkIf cfg.enable {
    programs = {
      zellij = {
        enable = true;
        enableBashIntegration = mkDefault true;
        enableZshIntegration = mkDefault true;
        exitShellOnExit = mkDefault false;
        
      };
    };
  };
}
