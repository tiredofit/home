{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.hyprsunset;
in
  with lib;
{
  options = {
    host.home.applications.hyprsunset = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Application to enable a blue-light filter on Hyprland";
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
      hyprsunset
    ];
    services.hyprsunset = mkIf cfg.service.enable {
      enable = mkDefault true;
      package = mkDefault pkgs.hyprsunset;
    };
  };
}
