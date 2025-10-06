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
          "float, initialTitle:^(Authentication Required - Mozilla Thunderbird)$"
          "float,class:^(thunderbird)$,title:^(.*)(Reminder)(.*)$"
          "float,class:^(thunderbird)$,title:^(Check Spelling)$"
          "float,class:^(thunderbird)$,title:^About(.*)$"
          "size 525 335,class:^(thunderbird)$,title:^(Check Spelling)$"
          "workspace 1,class:(thunderbird)$"
          "size 570 370,initialClass:(^thunderbird$),initialTitle:(^Check Spelling$)"
        ];
      };
    };
  };
}
