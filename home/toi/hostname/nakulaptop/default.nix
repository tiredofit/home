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
      };
    };
  };

  services.autorandr.enable = true;
}
