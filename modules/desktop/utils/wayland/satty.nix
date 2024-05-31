{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.satty;
in
  with lib;
{
  options = {
    host.home.applications.satty = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Screenshot annotizer";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          satty
        ];
    };

    wayland.windowManager.hyprland = mkIf (config.host.home.feature.gui.displayServer == "wayland" && config.host.home.feature.gui.windowManager == "hyprland" && config.host.home.feature.gui.enable) {
      settings = {
        #"SUPER_SHIFT, S, exec, pkill satty || hyprshot -s -r -m region | satty  -f -"
        bind = [
          "SUPER_SHIFT, S, exec, pkill satty || grim -g \"$(${pkgs.slurp}/bin/slurp)\" - | satty -f -"
        ];
        windowrulev2 = [
          "float,class:^(com.gabm.satty)$"
          "pin,class:^(com.gabm.satty)$"
        ];
      };
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
