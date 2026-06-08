{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.playerctl;
  shell = config.host.home.feature.gui.shell;
  displayServer = config.host.home.feature.gui.displayServer;
  dmsActive = config.host.home.feature.gui.enable && displayServer == "wayland" && builtins.elem "dms" shell;
in
  with lib;
{
  options = {
    host.home.applications.playerctl = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Media Keys tool";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          playerctl
        ];
    };

    wayland.windowManager.hyprland = mkIf (config.host.home.feature.gui.displayServer == "wayland" && builtins.elem "hyprland" config.host.home.feature.gui.windowManager && config.host.home.feature.gui.enable && !dmsActive) {
      settings = {
        bind = [
          {_args = ["XF86AudioPlay" (lib.generators.mkLuaInline "hl.dsp.exec_cmd('${config.host.home.feature.uwsm.prefix}playerctl play-pause')") (lib.generators.mkLuaInline "{locked=true}")];}
          {_args = ["XF86AudioPrev" (lib.generators.mkLuaInline "hl.dsp.exec_cmd('${config.host.home.feature.uwsm.prefix}playerctl previous')") (lib.generators.mkLuaInline "{locked=true}")];}
          {_args = ["XF86AudioNext" (lib.generators.mkLuaInline "hl.dsp.exec_cmd('${config.host.home.feature.uwsm.prefix}playerctl next')") (lib.generators.mkLuaInline "{locked=true}")];}
          {_args = ["XF86AudioMedia" (lib.generators.mkLuaInline "hl.dsp.exec_cmd('${config.host.home.feature.uwsm.prefix}playerctl play-pause')") (lib.generators.mkLuaInline "{locked=true}")];}
          {_args = ["XF86AudioStop" (lib.generators.mkLuaInline "hl.dsp.exec_cmd('${config.host.home.feature.uwsm.prefix}playerctl stop')") (lib.generators.mkLuaInline "{locked=true}")];}
        ];
      };
    };
  };
}
