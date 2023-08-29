{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.drawio;
in
  with lib;
{
  options = {
    host.home.applications.drawio = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Diagram tool";
      };
    };
  };

  config = mkIf cfg.enable {


    home = {
      file = {
        ".config/draw-io/config.json".source = ../../../dotfiles/draw-io/config.json;
        ".config/draw-io/Prefrences".source = ../../../dotfiles/draw-io/Preferences;
      };
      packages = with pkgs;
        [
          drawio
        ];
    };
  };
}
