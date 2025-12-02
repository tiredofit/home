{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.hyprpolkitagent;
in
  with lib;
{
  options = {
    host.home.applications.hyprpolkitagent = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Polkit authentication agent written in QT/QML";
      };
    };
  };

  config = mkIf cfg.enable {
    services.hyprpolkitagent = {
      enable = mkDefault true;
      package = mkDefault pkgs.hyprpolkitagent;
    };
  };
}
