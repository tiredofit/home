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
          address = "127.0.0.1";
          port = 5960;
          service.enable = true;
        };
      };
    };
  };

  wayland.windowManager.hyprland.xwayland.enable = false;
}

