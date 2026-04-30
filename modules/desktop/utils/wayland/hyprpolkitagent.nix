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
      service.enable = mkOption {
        default = true;
        type = with types; bool;
        description = "Auto start on user session start";
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      hyprpolkitagent
    ];
    services.hyprpolkitagent = mkIf cfg.service.enable {
      enable = mkDefault true;
      package = mkDefault pkgs.hyprpolkitagent;
    };
  };
}
