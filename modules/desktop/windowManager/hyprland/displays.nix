{ config, inputs, lib, pkgs, specialArgs, ... }:
let
  inherit (specialArgs) displays display_center display_left display_right role;

  displayServer = config.host.home.feature.gui.displayServer ;
  windowManager = config.host.home.feature.gui.windowManager ;
in
with lib;
{

  config = mkIf (config.host.home.feature.gui.enable && displayServer == "wayland" && windowManager == "hyprland") {
    wayland.windowManager.hyprland = {
      enable = true;
      settings = mkMerge [
        (mkIf (displays == 1) [
          {
            "$monitor_middle=${display_center}"
            workspace = 1,monitor:$monitor_middle,persistent:true
            workspace = 4,monitor:$monitor_middle,persistent:true
            workspace = 7,monitor:$monitor_middle,persistent:true
            workspace = 2,monitor:$monitor_middle,persistent:true
            workspace = 5,monitor:$monitor_middle,persistent:true
            workspace = 8,monitor:$monitor_middle,persistent:true
            workspace = 3,monitor:$monitor_middle,persistent:true
            workspace = 6,monitor:$monitor_middle,persistent:true
            workspace = 9,monitor:$monitor_middle,persistent:true
          }
        ])
      ];
    };
  };
}



#$monitor_left=DP-3
#$monitor_middle=DP-2
#$monitor_right=HDMI-A-1
#monitor=$monitor_left,2560x1440@119.998001,0x0,1.0
#monitor=$monitor_middle,2560x1440@119.998001,2560x0,1.0
#monitor=$monitor_right,2560x1440@59.950,5120x0,1.0
#
## Workspaces
#workspace = 1,monitor:$monitor_left,,default:true,persistent:true
#workspace = 4,monitor:$monitor_left,persistent:true
#workspace = 7,monitor:$monitor_left,persistent:true
#workspace = 2,monitor:$monitor_middle,,default:true,persistent:true
#workspace = 5,monitor:$monitor_middle,persistent:true
#workspace = 8,monitor:$monitor_middle,persistent:true
#workspace = 3,monitor:$monitor_right,default:true,persistent:true
#workspace = 6,monitor:$monitor_right,persistent:true
#workspace = 9,monitor:$monitor_right,persistent:true
      ];
    };
  };
}
