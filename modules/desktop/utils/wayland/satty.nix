{config, lib, pkgs, ...}:
## PERSONALIZE
let
  cfg = config.host.home.applications.satty;
  shell = config.host.home.feature.gui.shell;
  displayServer = config.host.home.feature.gui.displayServer;
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
          unstable.satty
        ];
    };

    ## DMS
    #wayland.windowManager.hyprland = mkIf (config.host.home.feature.gui.isHyprland && !config.host.home.feature.gui.isDms) {
    wayland.windowManager.hyprland = mkIf (config.host.home.feature.gui.isHyprland) {
      settings = {
        #"SUPER_SHIFT, S, exec, pkill satty || hyprshot -s -r -m region | satty  -f -"
        bind = [
          { _args = ["SUPER + SHIFT + S" (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("${config.host.home.feature.uwsm.prefix}pkill satty || ${config.host.home.feature.uwsm.prefix}grim -g \"$(${pkgs.slurp}/bin/slurp)\" - | ${config.host.home.feature.uwsm.prefix}satty --disable-notifications -f -")'')]; }
        ];
        window_rule = [
          {
            float = true;
            pin = true;
            match = {
              class = "^(com.gabm.satty)$";
            };
          }
        ];
      };
    };

    xdg.configFile."satty/config.toml".text = ''
      [general]
      fullscreen = false
      early-exit = true
      initial-tool = "blur" # [pointer, crop, line, arrow, rectangle, text, marker, blur, brush]
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
