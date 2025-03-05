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
    };
  };

  config = mkIf cfg.enable {
    services.flameshot = {
      enable = true;
      package = pkgs.unstable.flameshot.override { enableWlrSupport = true; };
    };

    #xdg.configFile."flameshot/flameshot.ini".text = ''
    #  [General]
    #  #buttons=@Variant(\0\0\0\x7f\0\0\0\vQList<int>\0\0\0\0\v\0\0\0\x2\0\0\0\x3\0\0\0\x4\0\0\0\x5\0\0\0\xf\0\0\0\x16\0\0\0\a\0\0\0\b\0\0\0\n\0\0\0\v\0\0\0\x17)
    #  checkForUpdates=false
    #  contrastOpacity=127
    #  #copyAndCloseAfterUpload=false
    #  disabledTrayIcon=true
    #  drawThickness=12
    #  historyConfirmationToDelete=false
    #  showDesktopNotification=false
    #  showHelp=false
    #  showSidePanelButton=true
    #  showStartupLaunchMessage=false
    #  uiColor=#069ffc
#
    #  [Shortcuts]
    #  TYPE_ACCEPT=
    #  TYPE_COPY=Return
    #'';
  };
}
