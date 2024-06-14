{ config, lib, pkgs, specialArgs, ...}:
let
  inherit (specialArgs) displays display_center display_left display_right role;
in
with lib;
{
  host = {
    home = {
      applications = {
        avidemux.enable = true;
        cura.enable = true;
        electrum.enable = false;
        encfs.enable = true;
        floorp.enable = true;
        github-client.enable = true;
        gnome-encfs-manager.enable = true;
        gnome-software.enable = true;
        hadolint.enable = true;
        hugo.enable = false;
        lazygit.enable = true;
        nix-development_tools.enable = true;
        obsidian.enable = true;
        opensnitch-ui.enable = true;
        python.enable = true;
        rs-tftpd.enable = true;
        shellcheck.enable = true;
        shfmt.enable = true;
        smartgit.enable = false;
        ssh = {
          enable = true;
          ignore = {
            "192.168.1.0/24" = true;
            "192.168.4.0/24" = true;
          };
        };
        szyszka.enable = true;
        veracrypt.enable = true;
        xmlstarlet.enable = true;
        yq.enable = true;
        zoom.enable = mkForce false;
      };
      feature = {
        emulation = {
          windows.enable = true;
        };
        gui = {
          enable = true;
          displayServer = "wayland";
          windowManager = "hyprland";
        };
      };
      service.decrypt_encfs_workspace.enable = true;
      user = {
        dave = {
          secrets = {
            act = {
              toi.enable = true;
            };
            github = {
              toi.enable = true;
            };
            ssh = {
              sd.enable = true;
              sr.enable = true;
              toi.enable = true;
            };
          };
        };
      };
    };
  };

  #  ------   -----   -------
  # | DP-3 | | DP-2| | HDMI-1|
  #  ------   -----   -------

  #  ---------------- ----------------- ------------
  # | DisplayPort-2 | | DisplayPort-1 | | HDMI-A-0 |
  #  ---------------- ----------------- ------------
  ## TODO - This should really become a module and only require resolutions, rate, and fingerprint
  programs = {
    autorandr = {
      enable = true;
      profiles = {
        beef = {
          fingerprint = {
            "${display_center}" = "00ffffffffffff0010acf4d056563831241e0104b5462878fb2de5ad5045a826115054a54b008100b300d100714fa9408180d1c00101565e00a0a0a0295030203500b9882100001a000000ff00394834564634330a2020202020000000fc0044454c4c205333323230444746000000fd0030a4fafa41010a202020202020012202033bf14f90050403020716010611123f13141f230907078301000065030c001000e305c000e60605096c6c2c6d1a0000020330a4000f6c2c6c2c64fa0050a0a0285008206800b9882100001a6fc200a0a0a0555030203500b9882100001a000000000000000000000000000000000000000000000000000000000000000066";
            "${display_left}" = "00ffffffffffff0010acf4d0564c5a30261e0104b5462878fb2de5ad5045a826115054a54b008100b300d100714fa9408180d1c00101565e00a0a0a0295030203500b9882100001a000000ff00363342514634330a2020202020000000fc0044454c4c205333323230444746000000fd0030a4fafa41010a202020202020011802033bf14f90050403020716010611123f13141f230907078301000065030c001000e305c000e60605096c6c2c6d1a0000020330a4000f6c2c6c2c64fa0050a0a0285008206800b9882100001a6fc200a0a0a0555030203500b9882100001a000000000000000000000000000000000000000000000000000000000000000066";
            "${display_right}" = "00ffffffffffff0010acf2d056564d30201e010380462878ea2de5ad5045a826115054a54b008100b300d100714fa9408180d1c00101565e00a0a0a0295030203500b9882100001a000000ff00475344544634330a2020202020000000fc0044454c4c205333323230444746000000fd0030901ee63c000a202020202020013e020353f15590050403020716010611123f13141f5a5d5e5f60612309070783010000e200d567030c001000383c67d85dc4017888016d1a000002033090e60f6c2c6c2ce305c000e40f000018e60605016c6c2c40e7006aa0a0675008209804b9882100001a6fc200a0a0a0555030203500b9882100001a000000000000000059";
          };
          config = {
            "${display_left}" = {
              enable = true;
              primary = false;
              position = "0x0";
              mode = "2560x1440";
              #rate = "120.02";
            };
            "${display_center}" = {
              enable = true;
              primary = true;
              position = "2560x0";
              mode = "2560x1440";
              #rate = "120.02";
            };
            "${display_right}" = {
              enable = true;
              primary = false;
              position = "5120x0";
              mode = "2560x1440";
              #rate = "59.95";
            };
          };
        };
      };
    };
  };

  services.autorandr.enable = false;
}
