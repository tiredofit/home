{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.opensnitch-ui;
in
  with lib;
{
  options = {
    host.home.applications.opensnitch-ui = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Application Firewall";
      };
    };
  };

  config = mkIf cfg.enable {
    services = {
      opensnitch-ui = {
        enable = mkDefault true;
        package = mkDefault pkgs.opensnitch-ui;
      };
    };

    wayland.windowManager.hyprland = {
      settings = {
        windowrule = [
          "float,initialClass:(^opensnitch_ui$)"
          "size 900 600,initialClass:(^opensnitch_ui$),initialTitle:(^Preferences$)"
          "size 900 600,initialClass:(^opensnitch_ui$),initialTitle:(^Rule$)"
          "size 650 460,initialClass:(^opensnitch_ui$),initialTitle:(Firewall)"
          "size 650 460,initialClass:(^opensnitch_ui$),initialTitle:(OpenSnitch Network Statistics.*)"
          "size 650 460,initialClass:(^opensnitch_ui$),initialTitle:(^OpenSnitch v[0-9]\.[0-9]\.[0-9]$)"
        ];
      };
    };
  };
}
