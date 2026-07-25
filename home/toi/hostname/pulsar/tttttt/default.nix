{ config, lib, pkgs, ... }:
with lib; {
  host = {
    home = {
      applications = {
        firefox.enable = mkForce true;
        ghostty.enable = mkForce true;
        grim.enable = mkForce false;
        hyprcursor.enable = mkForce true;
        hyprdim.enable = mkForce false;
        hypridle.enable = mkForce false;
        hyprlock.enable = mkForce false;
        hyprpaper.enable = mkForce false;
        hyprpicker.enable = mkForce false;
        hyprsunset.enable = mkForce false;
        nwg-displays.enable = mkForce false;
        playerctl.enable = mkForce false;
        python.enable = mkForce true;
        rofi.enable = mkForce false;
        satty.enable = mkForce false;
        shellcheck.enable = mkForce false;
        shikane.enable = mkForce false;
        slurp.enable = mkForce false;
        sway-notification-center.enable = mkForce false;
        swayosd.enable = mkForce false;
        virt-manager.enable = mkForce true;
        wayprompt.enable = mkForce false;
        waybar = {
          enable = mkForce false;
          service.enable = mkForce false;
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
