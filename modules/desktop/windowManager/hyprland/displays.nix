{ config, inputs, lib, pkgs, specialArgs, ... }:
let
  inherit (specialArgs) displays display_center display_left display_right hostname role;

  displayServer = config.host.home.feature.gui.displayServer ;
  windowManager = config.host.home.feature.gui.windowManager ;
in
with lib;
{
  config = mkIf (config.host.home.feature.gui.enable && displayServer == "wayland" && windowManager == "hyprland") {
    wayland.windowManager.hyprland = {
      settings = mkMerge [
        (mkIf (displays == 1) {
           "$monitor_middle" = "${display_center}";
           workspace = [
             "1,monitor:$monitor_middle,persistent:true"
             "4,monitor:$monitor_middle,persistent:true"
             "7,monitor:$monitor_middle,persistent:true"
             "2,monitor:$monitor_middle,,default:true,persistent:true"
             "5,monitor:$monitor_middle,persistent:true"
             "8,monitor:$monitor_middle,persistent:true"
             "3,monitor:$monitor_middle,,default:true,persistent:true"
             "6,monitor:$monitor_middle,persistent:true"
             "9,monitor:$monitor_middle,persistent:true"
           ];
        })
        (mkIf (displays == 2) {
           "$monitor_middle" = "${display_center}";
           "$monitor_right" = "${display_right}";
            workspace = [
              "1,monitor:$monitor_middle,persistent:true"
              "4,monitor:$monitor_middle,persistent:true"
              "7,monitor:$monitor_middle,persistent:true"
              "2,monitor:$monitor_middle,,default:true,persistent:true"
              "5,monitor:$monitor_middle,persistent:true"
              "8,monitor:$monitor_middle,persistent:true"
              "3,monitor:$monitor_right,,default:true,persistent:true"
              "6,monitor:$monitor_right,persistent:true"
              "9,monitor:$monitor_right,persistent:true"
            ];
        })
        (mkIf (displays == 3) {
           "$monitor_middle" = "${display_center}";
           "$monitor_right" = "${display_right}";
           "$monitor_left" = "${display_left}";
            workspace = [
              "1,monitor:$monitor_left,,default:true,persistent:true"
              "4,monitor:$monitor_left,persistent:true"
              "7,monitor:$monitor_left,persistent:true"
              "2,monitor:$monitor_middle,,default:true,persistent:true"
              "5,monitor:$monitor_middle,persistent:true"
              "8,monitor:$monitor_middle,persistent:true"
              "3,monitor:$monitor_right,,default:true,persistent:true"
              "6,monitor:$monitor_right,persistent:true"
              "9,monitor:$monitor_right,persistent:true"
            ];
        })
        (mkIf (hostname == "beef") {
          monitor = [
            "$monitor_left,2560x1440@119.998001,0x0,1.0"
            "$monitor_middle,2560x1440@119.998001,2560x0,1.0"
            "$monitor_right,2560x1440@59.950,5120x0,1.0"
          ];
        })
      ];
    };
  };
}