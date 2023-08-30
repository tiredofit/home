{config, lib, pkgs, ...}:
  with lib;
let
  cfg = config.host.home.applications.rofi;
  displayServer = config.host.home.feature.gui.displayServer ;
  rofiPackage =
    if displayServer == "wayland"
    then pkgs.rofi-wayland
    else pkgs.rofi;
in
{
  options = {
    host.home.applications.rofi = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Launcher";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      file = { ## TODO Turn this into options below and move away from the dotfiles folder
        ".config/rofi".source = ../../../dotfiles/rofi;
      };

      packages = with pkgs;
        [
          rofiPackage
        ];
    };

    #programs.rofi = {
    #  enable = true;
    #  package = rofiPackage;
    #};
  };
}
