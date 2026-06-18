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

    wayland.windowManager.hyprland = mkIf (config.host.home.feature.gui.isHyprland) {
      settings = {
        window_rule = [
          {
            float = true;
            match = {
              initial_title = "^(Authentication Required - Mozilla Thunderbird)$";
            };
          }
          {
            float = true;
            match = {
              class = "^(thunderbird)$";
              title = "^(.*)(Reminder)(.*)$";
            };
          }
          {
            float = true;
            size = "525 335";
            match = {
              class = "^(thunderbird)$";
              title = "^(Check Spelling)$";
            };
          }
          {
            float = true;
            match = {
              class = "^(thunderbird)$";
              title = "^About(.*)$";
            };
          }
          {
            workspace = "1";
            match = {
              class = "(thunderbird)$";
            };
          }
          {
            size = "570 370";
            match = {
              initial_class = "(^thunderbird$)";
              initial_title = "(^Check Spelling$)";
            };
          }
        ];
      };
    };
  };
}
