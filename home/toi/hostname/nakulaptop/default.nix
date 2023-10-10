{ config, lib, pkgs, specialArgs, ...}:
let
  inherit (specialArgs) displays display_center display_left display_right role;
in
with lib;
{
  programs = {
    autorandr = {
      enable = true;
      profiles = {
        single = {
          fingerprint = {
            "${display_center}" = "00ffffffffffff0009e5e90700000000011c0104a51f1178022190a658549f2610505400000001010101010101010101010101010101c0398018713828403020360035ae1000001a000000000000000000000000000000000000000000fe00424f452043510a202020202020000000fe004e5631343046484d2d4e36330a00a4";
          };
          config = {
            "${display_center}" = {
              enable = true;
              primary = true;
              mode = "1920x1080";
              rate = "60";
            };
          };
        };
        dual = {
          fingerprint = {
            "${display_right}" = "00ffffffffffff0010acf2d056564d30201e010380462878ea2de5ad5045a826115054a54b008100b300d100714fa9408180d1c00101565e00a0a0a0295030203500b9882100001a000000ff00475344544634330a2020202020000000fc0044454c4c205333323230444746000000fd0030901ee63c000a202020202020013e020353f15590050403020716010611123f13141f5a5d5e5f60612309070783010000e200d567030c001000383c67d85dc4017888016d1a000002033090e60f6c2c6c2ce305c000e40f000018e60605016c6c2c40e7006aa0a0675008209804b9882100001a6fc200a0a0a0555030203500b9882100001a000000000000000059";
            "${display_center}" = "00ffffffffffff0009e5e90700000000011c0104a51f1178022190a658549f2610505400000001010101010101010101010101010101c0398018713828403020360035ae1000001a000000000000000000000000000000000000000000fe00424f452043510a202020202020000000fe004e5631343046484d2d4e36330a00a4";
          };
          config = {
            "${display_center}" = {
              enable = true;
              primary = true;
              mode = "2560x1440";
              rate = "59.95";
            };
            "${display_right}" = {
              enable = true;
              primary = false;
              mode = "1920x1080";
              position = "320x1440";
              rate = "60";
            };
          };
        };
      };

    };
  };

  services.autorandr.enable = true;
}
