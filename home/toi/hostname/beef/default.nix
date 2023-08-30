{ config, lib, pkgs, ...}:
{
  host = {
    home = {
      applications = {
        act.enable = true;
        android-tools.enable = true;
        calibre.enable = true;
        encfs.enable = true;
        git.enable = true;
        github-client.enable = true;
        hugo.enable = true;
        lazygit.enable = true;
        nextcloud-client.enable = true;
        tea.enable = true;
      };
      feature = {
        gui = {
          enable = true;
          displayServer = "x";
          windowManager = "i3";
        };
      };
      service = {
        decrypt_encfs_workspace.enable = true;
        vscode-server.enable = true;
      };
    };
  };

  #  ------   -----   -------
  # | DP-3 | | DP-2| | HDMI-1|
  #  ------   -----   -------

  #  ---------------- ----------------- ------------
  # | DisplayPort-2 | | DisplayPort-1 | | HDMI-A-0 |
  #  ---------------- ----------------- ------------
  programs = {
    autorandr = {
      enable = true;
      profiles = {
        beef = {
          fingerprint = {
            "DisplayPort-1" = "00ffffffffffff0010acf4d056563831241e0104b5462878fb2de5ad5045a826115054a54b008100b300d100714fa9408180d1c00101565e00a0a0a0295030203500b9882100001a000000ff00394834564634330a2020202020000000fc0044454c4c205333323230444746000000fd0030a4fafa41010a202020202020012202033bf14f90050403020716010611123f13141f230907078301000065030c001000e305c000e60605096c6c2c6d1a0000020330a4000f6c2c6c2c64fa0050a0a0285008206800b9882100001a6fc200a0a0a0555030203500b9882100001a000000000000000000000000000000000000000000000000000000000000000066";
            "DisplayPort-2" = "00ffffffffffff0010acf4d0564c5a30261e0104b5462878fb2de5ad5045a826115054a54b008100b300d100714fa9408180d1c00101565e00a0a0a0295030203500b9882100001a000000ff00363342514634330a2020202020000000fc0044454c4c205333323230444746000000fd0030a4fafa41010a202020202020011802033bf14f90050403020716010611123f13141f230907078301000065030c001000e305c000e60605096c6c2c6d1a0000020330a4000f6c2c6c2c64fa0050a0a0285008206800b9882100001a6fc200a0a0a0555030203500b9882100001a000000000000000000000000000000000000000000000000000000000000000066";
            "HDMI-A-0" = "00ffffffffffff0010acf2d056564d30201e010380462878ea2de5ad5045a826115054a54b008100b300d100714fa9408180d1c00101565e00a0a0a0295030203500b9882100001a000000ff00475344544634330a2020202020000000fc0044454c4c205333323230444746000000fd0030901ee63c000a202020202020013e020353f15590050403020716010611123f13141f5a5d5e5f60612309070783010000e200d567030c001000383c67d85dc4017888016d1a000002033090e60f6c2c6c2ce305c000e40f000018e60605016c6c2c40e7006aa0a0675008209804b9882100001a6fc200a0a0a0555030203500b9882100001a000000000000000059";
          };
          config = {
            "DisplayPort-2" = {
              enable = true;
              primary = false;
              position = "0x0";
              mode = "2560x1440";
              rate = "120.00";
            };
            "DisplayPort-1" = {
              enable = true;
              primary = true;
              position = "2560x0";
              mode = "2560x1440";
              rate = "120.00";
            };
            "HDMI-A-0" = {
              enable = true;
              primary = false;
              position = "5120x0";
              mode = "2560x1440";
              rate = "143.91";
            };
          };
        };
      };
    };
  };

  services.autorandr.enable = true;

  sops.secrets = {
    "bashrc.d/toi_remotehosts.sh" = {
      format = "binary";
      sopsFile = ../secrets/bash-toi_remotehosts.sh;
      mode = "500";
    };
  };
}
