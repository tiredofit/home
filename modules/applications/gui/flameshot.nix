{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.flameshot;
    flameshotGrim = pkgs.flameshot.overrideAttrs (oldAttrs: {
    src = pkgs.fetchFromGitHub {
      owner = "flameshot-org";
      repo = "flameshot";
      rev = "3d21e4967b68e9ce80fb2238857aa1bf12c7b905";
      sha256 = "sha256-OLRtF/yjHDN+sIbgilBZ6sBZ3FO6K533kFC1L2peugc=";
    };
    cmakeFlags = [
      "-DUSE_WAYLAND_CLIPBOARD=1"
      "-DUSE_WAYLAND_GRIM=1"
    ];
    buildInputs = oldAttrs.buildInputs ++ [ pkgs.libsForQt5.kguiaddons ];
  });
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
      package = flameshotGrim;
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
