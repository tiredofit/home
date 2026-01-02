{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.thunderbird;
in
  with lib;
{
  options = {
    host.home.applications.thunderbird = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Mail, Calendar, and IM";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          thunderbird
        ];
    };

    programs = {
      thunderbird = {
        enable = false;
        ## TODO - This needs conversion
      };
    };

    wayland.windowManager.hyprland = mkIf (config.host.home.feature.gui.displayServer == "wayland" && config.host.home.feature.gui.windowManager == "hyprland" && config.host.home.feature.gui.enable) {
      settings = {
        windowrule = [
          "float on, match:initial_title ^(Authentication Required - Mozilla Thunderbird)$"
          "float on, match:class ^(thunderbird)$, match:title ^(.*)(Reminder)(.*)$"
          "float on, size 525 335, match:class ^(thunderbird)$, match:title ^(Check Spelling)$"
          "float on, match:class ^(thunderbird)$, match:title ^About(.*)$"
          "workspace 1, match:class (thunderbird)$"
          "size 570 370, match:initial_class (^thunderbird$), match:initial_title (^Check Spelling$)"
        ];
      };
    };
  };
}
