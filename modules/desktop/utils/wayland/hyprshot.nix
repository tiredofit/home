{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.hyprshot;
in
  with lib;
{
  options = {
    host.home.applications.hyprshot = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Hyprshot is an utility to easily take screenshots in Hyprland using your mouse.";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          hyprshot
          satty
        ];
    };

    xdg.configFile."satty/config.toml".text = ''
      [general]
      fullscreen = false
      early-exit = true
      initial-tool = "arrow" # [pointer, crop, line, arrow, rectangle, text, marker, blur, brush]
      copy-command = "wl-copy"
      output-filename = "/tmp/screenshot-%Y-%m-%d_%H:%M:%S.png"
      save-after-copy = false

      [font]
      family = "Roboto"
      style = "Bold"

      #[color-palette]
      #first= "#00ffff"
      #second= "#a52a2a"
      #third= "#dc143c"
      #fourth= "#ff1493"
      #fifth= "#ffd700"
      #custom= "#008000"
    '';
  };
}
