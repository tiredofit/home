{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.flameshot;
in
  with lib;
{

  options = {
    host.home.applications.flameshot = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Screenshot grabber";
      };
      service.enable = mkOption {
        default = true;
        type = with types; bool;
        description = "Auto start on user session start";
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      (pkgs.unstable.flameshot.override { enableWlrSupport = true; })
    ];

    services.flameshot = mkIf cfg.service.enable {
      enable = true;
      package = pkgs.unstable.flameshot.override { enableWlrSupport = true; };
    };

    wayland.windowManager.hyprland = mkIf (config.host.home.feature.gui.displayServer == "wayland" && config.host.home.feature.gui.windowManager == "hyprland" && config.host.home.feature.gui.enable) {
      settings = {
        windowrulev2 = [
          "noanim, class:^(flameshot)$"
          "float, class:^(flameshot)$"
          "move 0 0, class:^(flameshot)$"
          "pin, class:^(flameshot)$"
          "monitor 3, class:^(flameshot)$" # set this to your leftmost monitor id, otherwise you have to move your cursor to the leftmost monitor before executing flameshot
        ];
      };
    };

    xdg.configFile."flameshot/flameshot.ini".text = ''
      [General]
      buttons=@Variant(\0\0\0\x7f\0\0\0\vQList<int>\0\0\0\0\f\0\0\0\0\0\0\0\x1\0\0\0\x2\0\0\0\x3\0\0\0\x6\0\0\0\x12\0\0\0\xf\0\0\0\x13\0\0\0\b\0\0\0\t\0\0\0\x10\0\0\0\n)
      contrastOpacity=153
      copyOnDoubleClick=true
      drawColor=#0000ff
      drawThickness=13
      jpegQuality=75
      showDesktopNotification=false
      showMagnifier=true
      showSelectionGeometryHideTime=2996
      showSidePanelButton=false
      showStartupLaunchMessage=false
      squareMagnifier=false
      uiColor=#ff1a1e
    '';
  };
}
