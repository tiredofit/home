{ config, lib, pkgs, ... }:
with lib; {
  host = {
    home = {
      applications = {
        firefox.enable = true;
        grim.enable = false;
        hyprcursor.enable = false;
        hyprdim.enable = false;
        hypridle.enable = false;
        hyprlock.enable = mkForce false;
        hyprpaper.enable = false;
        hyprpicker.enable = false;
        hyprsunset.enable = false;
        kitty.enable = true;
        nwg-displays.enable = false;
        playerctl.enable = false;
        python.enable = true;
        rofi.enable = true;
        satty.enable = false;
        shellcheck.enable = true;
        shikane.enable = false;
        slurp.enable = false;
        sway-notification-center.enable = false;
        swayosd.enable = false;
        virt-manager.enable = true;
        wayprompt.enable = false;
        waybar = {
          enable = true;
          service.enable = true;
        };
      };

      service = {
        wayvnc = {
          enable = true;
          address = "0.0.0.0";
          port = 5960;
          service.enable = true;
          secretsFile = ./secrets/wayvnc.yaml;
        };
      };
    };
  };

  wayland.windowManager.hyprland.xwayland.enable = false;
}

