{ config, pkgs, ...}:
{
  home = {
    packages = with pkgs;
      [
        flameshot
      ];
  };

  xdg.configFile."flameshot/flameshot.ini".text = ''
    [General]
    buttons=@Variant(\0\0\0\x7f\0\0\0\vQList<int>\0\0\0\0\r\0\0\0\x2\0\0\0\x3\0\0\0\x4\0\0\0\x5\0\0\0\x6\0\0\0\xf\0\0\0\x13\0\0\0\a\0\0\0\b\0\0\0\n\0\0\0\v\0\0\0\x17\0\0\0\f)
    checkForUpdates=false
    contrastOpacity=188
    copyAndCloseAfterUpload=false
    disabledTrayIcon=false
    drawColor=#ff0000
    drawThickness=12
    historyConfirmationToDelete=false
    savePath=${config.home.homeDirectory}/
    showDesktopNotification=false
    showHelp=false
    showSidePanelButton=true
    showStartupLaunchMessage=false
    uiColor=#ca1501
    undoLimit=100
    uploadHistoryMax=25
  '';
}