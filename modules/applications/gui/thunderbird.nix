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

    wayland.windowManager.hyprland = {
      settings = {
        windowrulev2 = [
          "windowrulev2 = workspace 1,class:(thunderbird)$"
          "windowrulev2 = float,class:^(thunderbird)$,title:^(.*)(Reminder)(.*)$"
          "windowrulev2 = float,class:^(thunderbird)$,title:^About(.*)$"
          "windowrulev2 = float,class:^(thunderbird)$,title:^(Check Spelling)$"
          "windowrulev2 = size 525 335,class:^(thunderbird)$,title:^(Check Spelling)$"
        ];
      };
    };
  };
}
