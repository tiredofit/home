{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.hyprpicker;
in
  with lib;
{
  options = {
    host.home.applications.hyprpicker = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Wayland color picker";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          unstable.hyprpicker
        ];
    };

    wayland.windowManager.hyprland = {
      settings = {
        bind = [
          "SUPER_SHIFT, P, exec, ${config.host.home.feature.uwsm.prefix}pkill hyprpicker || ${config.host.home.feature.uwsm.prefix}hyprpicker --autocopy --no-fancy --format=hex"
        ];
      };
    };
  };
}
