{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.virt-manager;
in
  with lib;
{
  options = {
    host.home.applications.virt-manager = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Virtual Machine manager";
      };
    };
  };
  ## TODO - Is this even required
  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          virt-manager
        ];
    };

    wayland.windowManager.hyprland = mkIf (config.host.home.feature.gui.isHyprland) {
      settings = {
        window_rule = [
          {
            float = true;
            match = {
              title = "^(virt-manager)$";
            };
          }
        ];
      };
    };
  };
}
